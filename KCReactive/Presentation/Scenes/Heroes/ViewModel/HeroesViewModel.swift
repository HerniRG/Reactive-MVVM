//
//  HeroesViewModel.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 15/11/24.
//

import Combine
import Foundation

@MainActor
final class HeroesViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var heroes: [Hero] = [] // Lista de héroes
    @Published var isLoading: Bool = false // Estado de carga
    @Published var showError: Bool = false // Indica si ocurrió un error

    // MARK: - Private Properties
    private let heroUseCase: HeroUseCaseProtocol // Dependencia del caso de uso

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
            // Utiliza el caso de uso para obtener los héroes
            let heroes = try await heroUseCase.getHeroes(filter: filter)
            self.heroes = heroes
            showError = heroes.isEmpty // Si la lista está vacía, mostrar el error
        } catch {
            // Si ocurre un error, mostramos el mensaje de error
            self.showError = true
        }

        isLoading = false
    }
    
    func logout() {
        TokenManager.shared.deleteToken()
    }
}
