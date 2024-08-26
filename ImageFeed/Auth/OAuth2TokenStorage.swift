import Foundation

final class OAuth2TokenStorage {
    enum Keys: String {
            case bearerToken
        }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
            get {
                return userDefaults.string(forKey: Keys.bearerToken.rawValue)
            }
            set {
                userDefaults.set(newValue!, forKey: Keys.bearerToken.rawValue)
            }
        }
    
    func clearToken() {
            userDefaults.removeObject(forKey: Keys.bearerToken.rawValue)
        }
}
