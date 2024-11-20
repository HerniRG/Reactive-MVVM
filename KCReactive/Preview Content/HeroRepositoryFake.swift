//
//  HeroRepositoryFake.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

final class HeroRepositoryFake: HeroRepositoryProtocol {
    
    private var heroService: HeroServiceProtocol
    
    init(heroService: HeroServiceProtocol) {
        self.heroService = heroService
    }
    
    func getHeroes(filter: String) async throws -> [Hero] {
        return try await heroService.getHeroes(filter: filter)
    }
}
