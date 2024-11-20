//
//  HeroUseCase.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

final class HeroUseCase: HeroUseCaseProtocol {
    
    var heroRepo: HeroRepositoryProtocol
    
    init(heroRepo: HeroRepositoryProtocol = DefaultHeroRepository(heroService: HeroService())) {
        self.heroRepo = heroRepo
    }
    
    func getHeroes(filter: String) async throws -> [Hero] {
        do {
            // Llama al repositorio para obtener los héroes
            let heroes = try await heroRepo.getHeroes(filter: filter)
            return heroes
        } catch {
            // Manejo de errores adicional si es necesario
            throw error
        }
    }
}
