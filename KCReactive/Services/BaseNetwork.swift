//
//  BaseNetwork.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 14/11/24.
//

import Foundation

struct BaseNetwork {
    static func createRequest(url: String, httpMethod: String, body: Encodable? = nil, requiresAuth: Bool = true) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        if requiresAuth, let token = TokenManager.shared.loadToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Token incluido en el encabezado: \(token)")
        }
        
        return request
    }
}
