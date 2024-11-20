//
//  LoginRepositoryFake.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

final class LoginRepositoryFake: LoginRepositoryProtocol {

    private var network: NetworkLoginProtocol
    
    init(network: NetworkLoginProtocol) {
        self.network = network
    }
    
    func login(user: String, password: String) async throws -> String {
        return try await network.loginApp(user: user, password: password)
    }
}
