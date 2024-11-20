//
//  NetworkLoginFake.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

final class NetworkLoginFake: NetworkLoginProtocol {
    func loginApp(user: String, password: String) async throws -> String {
        return UUID().uuidString
    }
}
