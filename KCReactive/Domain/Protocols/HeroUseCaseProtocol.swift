//
//  HeroUseCaseProtocol.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

protocol HeroUseCaseProtocol {
    var heroRepo: HeroRepositoryProtocol { get }
    func getHeroes(filter: String) async throws -> [Hero]
}
