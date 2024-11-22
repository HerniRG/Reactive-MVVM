//
//  HeroesViewModel.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 15/11/24.
//

import Combine
import Foundation

// MARK: - ViewModel para la Lista de Héroes
@MainActor
final class HeroesViewModel: ObservableObject {

    // MARK: - Propiedades Publicadas
    @Published var heroes: [Hero] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false

    // MARK: - Propiedades Privadas
    private let heroUseCase: HeroUseCaseProtocol

    // MARK: - Inicializador

    init(heroUseCase: HeroUseCaseProtocol = HeroUseCase()) {
        self.heroUseCase = heroUseCase
        // Cargar la lista de héroes al inicializar
        Task {
            await loadHeroes()
        }
    }

    // MARK: - Métodos Públicos
    /// Carga la lista de héroes, opcionalmente filtrados por nombre.
    func loadHeroes(filter: String = "") async {
        isLoading = true
        showError = false

        do {
            // Intentar obtener los héroes utilizando el caso de uso
            let heroes = try await heroUseCase.getHeroes(filter: filter)
            self.heroes = heroes
            showError = heroes.isEmpty  // Mostrar error si no hay héroes
        } catch {
            showError = true  // Actualizar estado si ocurre un error
        }

        isLoading = false  // Finalizar estado de carga
    }

    /// Realiza el proceso de logout eliminando el token almacenado.
    func logout() {
        heroUseCase.logout()
    }
}
