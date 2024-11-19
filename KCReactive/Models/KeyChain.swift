//
//  KeyChain.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 14/11/24.
//

import Foundation
import KeychainSwift

final class TokenManager {
    private let keychain = KeychainSwift()
    private let tokenKey = "SESSION_TOKEN"
    
    static let shared = TokenManager()
    
    func saveToken(_ token: String) {
        keychain.set(token, forKey: tokenKey)
        print("Token guardado correctamente: \(token)")
    }
    
    func loadToken() -> String? {
        let token = keychain.get(tokenKey)
        print("Token recuperado: \(token ?? "No encontrado")")
        return token
    }
    
    func deleteToken() {
        keychain.delete(tokenKey)
        print("Token eliminado")
    }
}
