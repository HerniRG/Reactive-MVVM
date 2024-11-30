import Foundation

/// Use case for managing heroes, including fetching and logout operations.
final class HeroUseCase: HeroUseCaseProtocol {
    
    var heroRepo: HeroRepositoryProtocol
    
    /// Initializes the use case with a hero repository.
    init(heroRepo: HeroRepositoryProtocol = DefaultHeroRepository(heroService: HeroService())) {
        self.heroRepo = heroRepo
    }
    
    /// Fetches a list of heroes, optionally filtered by name, and sorts them.
    /// - Parameter filter: A filter string to search for heroes by name.
    /// - Returns: A sorted list of heroes matching the filter.
    func getHeroes(filter: String) async throws -> [Hero] {
        let heroes = try await heroRepo.getHeroes(filter: filter)
        return sortHeroes(heroes)
    }
    
    /// Deletes the stored token to log out the user.
    func logout() {
        TokenManager.shared.deleteToken()
    }
    
    /// Sorts heroes alphabetically by name.
    /// - Parameter heroes: The list of heroes to sort.
    /// - Returns: A sorted list of heroes.
    private func sortHeroes(_ heroes: [Hero]) -> [Hero] {
        return heroes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}

/// A fake implementation of `HeroUseCaseProtocol` for unit testing.
final class HeroUseCaseFake: HeroUseCaseProtocol {
    
    var heroRepo: any HeroRepositoryProtocol
    
    /// Predefined list of fake heroes for testing.
    private let fakeHeroes: [Hero] = [
        Hero(
            id: UUID(),
            name: "Goku",
            description: "The most powerful Saiyan.",
            photo: "https://example.com/goku.jpg",
            favorite: true
        ),
        Hero(
            id: UUID(),
            name: "Vegeta",
            description: "The prince of all Saiyans.",
            photo: "https://example.com/vegeta.jpg",
            favorite: false
        ),
        Hero(
            id: UUID(),
            name: "Piccolo",
            description: "The strongest Namekian.",
            photo: "https://example.com/piccolo.jpg",
            favorite: false
        )
    ]
    
    /// Initializes the fake use case with a hero repository.
    init(heroRepo: any HeroRepositoryProtocol = DefaultHeroRepository(heroService: HeroService())) {
        self.heroRepo = heroRepo
    }
    
    /// Simulates fetching heroes, applying a filter and sorting them.
    /// - Parameter filter: A filter string to search for heroes by name.
    /// - Returns: A sorted list of filtered fake heroes.
    func getHeroes(filter: String) async throws -> [Hero] {
        let filteredHeroes = filter.isEmpty
            ? fakeHeroes
            : fakeHeroes.filter { $0.name.localizedCaseInsensitiveContains(filter) }
        return sortHeroes(filteredHeroes)
    }
    
    /// Sorts heroes alphabetically by name.
    private func sortHeroes(_ heroes: [Hero]) -> [Hero] {
        return heroes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    /// Simulates a logout operation by printing a message to the console.
    func logout() {
        print("Fake logout executed")
    }
}
