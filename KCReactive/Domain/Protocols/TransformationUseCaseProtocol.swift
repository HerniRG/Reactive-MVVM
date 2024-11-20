//
//  TransformationUseCaseProtocol.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

protocol TransformationUseCaseProtocol {
    var transformationRepo: TransformationRepositoryProtocol { get }
    func getTransformations(id: String) async throws -> [Transformation]
}
