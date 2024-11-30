import Combine
import Foundation

// MARK: - HeroesViewModel
final class HeroesViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var heroes: [Hero] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false

    // MARK: - Private Properties
    private let heroUseCase: HeroUseCaseProtocol

    // MARK: - Initializer
    init(heroUseCase: HeroUseCaseProtocol = HeroUseCase()) {
        self.heroUseCase = heroUseCase
        Task {
            await loadHeroes()
        }
    }

    // MARK: - Public Methods
    func loadHeroes(filter: String = "") async {
        isLoading = true
        showError = false

        do {
            let heroes = try await heroUseCase.getHeroes(filter: filter)
            self.heroes = heroes
            showError = heroes.isEmpty
        } catch {
            showError = true
        }

        isLoading = false
    }

    func logout() {
        heroUseCase.logout()
    }
}
