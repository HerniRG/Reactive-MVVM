//
//  LoginRepositoryProtocol.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

protocol LoginRepositoryProtocol {
    func login(user: String, password: String) async throws -> String
}
