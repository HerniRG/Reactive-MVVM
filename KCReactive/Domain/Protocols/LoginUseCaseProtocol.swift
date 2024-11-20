//
//  LoginUseCaseProtocol.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

protocol LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol { get }
    func loginApp(user: String, password: String) async throws -> Bool
}
