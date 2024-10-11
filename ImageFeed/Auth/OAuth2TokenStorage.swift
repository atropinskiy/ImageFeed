import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            KeychainWrapper.standard.set(newValue!, forKey: Keys.bearerToken.rawValue)
        }
    }
    
    func clearToken() {
        KeychainWrapper.standard.removeObject(forKey: Keys.bearerToken.rawValue)
    }
}
