import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case requestCancelled
    case duplicateRequest
    case invalidResponse
    case noData
}

extension URLSession {
    
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
    -> URLSessionTask {
        
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                if 200 ..< 300 ~= statusCode {
                    
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(result))
                    } catch {
                        fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                    }
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.invalidResponse))
            }
        }
        return task
    }
}

extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL?) -> URLRequest {
        guard let baseURL = baseURL else {
            fatalError("Base URL is nil")
        }
        guard let url = URL(string: path, relativeTo: baseURL) else { fatalError("Invalid URL")}
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
