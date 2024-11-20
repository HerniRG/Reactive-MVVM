//
//  TransformationRepositoryProtocol.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

protocol TransformationRepositoryProtocol {
    func getTransformations(id: String) async throws -> [Transformation]
}
