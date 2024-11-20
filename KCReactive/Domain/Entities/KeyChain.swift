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
    private let tokenKey = ConstantsApp.CONST_TOKEN_KEY
    
    static let shared = TokenManager()
    
    func saveToken(_ token: String) {
        keychain.set(token, forKey: tokenKey)
        debugPrint("Token guardado correctamente: \(token)")
    }
    
    func loadToken() -> String? {
        let token = keychain.get(tokenKey)
        debugPrint("Token recuperado: \(token ?? "No encontrado")")
        return token
    }
    
    func deleteToken() {
        keychain.delete(tokenKey)
        debugPrint("Token eliminado")
    }
}
