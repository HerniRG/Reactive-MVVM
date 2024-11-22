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
    
    /// Obtiene la lista de héroes, opcionalmente filtrados por nombre.
    func getHeroes(filter: String) async throws -> [Hero] {
        return try await heroRepo.getHeroes(filter: filter)
    }
    
    /// Elimina el token almacenado, realizando el logout del usuario.
    func logout() {
        TokenManager.shared.deleteToken()
    }
}

/// `HeroUseCaseFake` es una implementación simulada de `HeroUseCaseProtocol` para pruebas unitarias.
///
/// - Simula:
///   - `getHeroes(filter:)`: Devuelve una lista predefinida de héroes (`Goku` y `Vegeta`), aplicando un filtro.
///   - `logout()`: Simula un logout con un mensaje en consola.
///
/// Ejemplo:
/// ```
/// let fakeUseCase = HeroUseCaseFake()
/// let heroes = try await fakeUseCase.getHeroes(filter: "")
/// assert(heroes.count == 2) // Devuelve los dos héroes
/// fakeUseCase.logout() // Imprime "Fake logout executed"
/// ```

final class HeroUseCaseFake: HeroUseCaseProtocol {
    
    /// Repositorio ficticio requerido por el protocolo
    var heroRepo: any HeroRepositoryProtocol
    
    /// Lista de héroes simulados.
    private let fakeHeroes: [Hero] = [
        Hero(
            id: UUID(),
            name: "Goku",
            description: "El Saiyan más poderoso.",
            photo: "https://example.com/goku.jpg",
            favorite: true,
            transformations: nil
        ),
        Hero(
            id: UUID(),
            name: "Vegeta",
            description: "El príncipe de los Saiyans.",
            photo: "https://example.com/vegeta.jpg",
            favorite: false,
            transformations: nil
        )
    ]
    
    /// Inicializador que acepta un repositorio ficticio opcional.
    init(heroRepo: any HeroRepositoryProtocol = DefaultHeroRepository(heroService: HeroService())) {
        self.heroRepo = heroRepo
    }
    
    /// Simula la obtención de héroes, devolviendo dos héroes predefinidos.
    func getHeroes(filter: String) async throws -> [Hero] {
        if filter.isEmpty {
            return fakeHeroes
        }
        return fakeHeroes.filter { $0.name.localizedCaseInsensitiveContains(filter) }
    }
    
    /// Simula el proceso de logout, eliminando el token.
    func logout() {
        print("Fake logout executed")
    }
}
