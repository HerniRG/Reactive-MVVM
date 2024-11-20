//
//  HeroRepositoryProtocol.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

protocol HeroRepositoryProtocol {
    func getHeroes(filter: String) async throws -> [Hero]
}
