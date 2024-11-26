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
    /// Ordena los héroes antes de devolverlos.
    func getHeroes(filter: String) async throws -> [Hero] {
        let heroes = try await heroRepo.getHeroes(filter: filter)
        return sortHeroes(heroes)
    }
    
    /// Elimina el token almacenado, realizando el logout del usuario.
    func logout() {
        TokenManager.shared.deleteToken()
    }
    
    /// Ordena los héroes alfabéticamente por nombre.
    /// - Parameter heroes: Lista de héroes a ordenar.
    /// - Returns: Lista de héroes ordenados.
    private func sortHeroes(_ heroes: [Hero]) -> [Hero] {
        return heroes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
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
    
    var heroRepo: any HeroRepositoryProtocol
    
    /// Lista de héroes simulados.
    private let fakeHeroes: [Hero] = [
        Hero(
            id: UUID(),
            name: "Goku",
            description: "El Saiyan más poderoso.",
            photo: "https://example.com/goku.jpg",
            favorite: true
        ),
        Hero(
            id: UUID(),
            name: "Vegeta",
            description: "El príncipe de los Saiyans.",
            photo: "https://example.com/vegeta.jpg",
            favorite: false
        ),
        Hero(
            id: UUID(),
            name: "Piccolo",
            description: "El namekiano más poderoso.",
            photo: "https://example.com/piccolo.jpg",
            favorite: false
        )
    ]
    
    init(heroRepo: any HeroRepositoryProtocol = DefaultHeroRepository(heroService: HeroService())) {
        self.heroRepo = heroRepo
    }
    
    /// Simula la obtención de héroes, devolviendo héroes ordenados.
    func getHeroes(filter: String) async throws -> [Hero] {
        let filteredHeroes = filter.isEmpty
            ? fakeHeroes
            : fakeHeroes.filter { $0.name.localizedCaseInsensitiveContains(filter) }
        return sortHeroes(filteredHeroes)
    }
    
    /// Ordena los héroes alfabéticamente por nombre.
    private func sortHeroes(_ heroes: [Hero]) -> [Hero] {
        return heroes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    func logout() {
        print("Fake logout executed")
    }
}
