import UIKit


final class OAuth2Service {
    static let shared = OAuth2Service()
    private init () {}
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        if let task = task, task.state == .running {
            if lastCode == code {
                completion(.failure(NetworkError.duplicateRequest)) // Возвращаем ошибку, что запрос уже выполняется
                return
            } else {
                // Отменяем предыдущий запрос
                task.cancel()
            }
        }
        
        lastCode = code
        
        guard let request = makeRequest(code) else {
            completion(
                .failure(NetworkError.urlRequestError(NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))))
            return
        }
        task = getUnsplashToken(request: request) { (result: Result<Data, Error>)  in
            let parsed = result.flatMap { data -> Result<String, Error> in
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    return .success(responseBody.accessToken)
                } catch {
                    print("Failed to decode OAuthTokenResponseBody: \(error.localizedDescription)")
                    print("Received data: \(String(data: data, encoding: .utf8) ?? "nil")")
                    return .failure(error)
                }
            }
            completion(parsed)
            self.task = nil
        }
    }
    
    private func makeRequest(_ code: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("URL error")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
    
        
    func getUnsplashToken(
        request: URLRequest,
        responseHandler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let resultCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                responseHandler(result)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                resultCompletion(.failure(NetworkError.requestCancelled))
                return
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= responseCode {
                    if let data = data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Server Response JSON: \(jsonString)")
                        }
                        resultCompletion(.success(data))
                    } else {
                        // Если данных нет
                        resultCompletion(.failure(NetworkError.noData))
                    }
                } else {
                    // Возвращаем ошибку с кодом HTTP-ответа
                    resultCompletion(.failure(NetworkError.httpStatusCode(responseCode)))
                }
            } else {
                // Если статус-код отсутствует
                resultCompletion(.failure(NetworkError.invalidResponse))
            }
        }
        task.resume()
        return task
    }
}
