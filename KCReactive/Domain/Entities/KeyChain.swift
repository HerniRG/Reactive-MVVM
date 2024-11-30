import Foundation
import KeychainSwift

/// Manages token storage in Keychain.
final class TokenManager {
    private let keychain = KeychainSwift()
    private let tokenKey = ConstantsApp.CONST_TOKEN_KEY
    
    static let shared = TokenManager()
    
    func saveToken(_ token: String) {
        keychain.set(token, forKey: tokenKey)
    }
    
    func loadToken() -> String? {
        return keychain.get(tokenKey)
    }
    
    func deleteToken() {
        keychain.delete(tokenKey)
    }
}
