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
    @Published var heroes: [Hero] = []          // Lista de héroes obtenidos
    @Published var isLoading: Bool = false      // Indica si está cargando datos
    @Published var showError: Bool = false      // Indica si ocurrió un error durante la carga

    // MARK: - Propiedades Privadas
    private let heroUseCase: HeroUseCaseProtocol   // Caso de uso para obtener los héroes

    // MARK: - Inicializador
    /// Inicializa el ViewModel con un caso de uso de héroes.
    /// - Parameter heroUseCase: Protocolo que define el caso de uso para obtener héroes.
    init(heroUseCase: HeroUseCaseProtocol = HeroUseCase()) {
        self.heroUseCase = heroUseCase
        // Cargar la lista de héroes al inicializar
        Task {
            await loadHeroes()
        }
    }

    // MARK: - Métodos Públicos
    /// Carga la lista de héroes, opcionalmente filtrados por nombre.
    /// - Parameter filter: Cadena de texto para filtrar los héroes por nombre.
    func loadHeroes(filter: String = "") async {
        // Actualizar el estado a cargando y resetear el error
        isLoading = true
        showError = false

        do {
            // Intentar obtener los héroes utilizando el caso de uso
            let heroes = try await heroUseCase.getHeroes(filter: filter)
            self.heroes = heroes
            // Mostrar error si la lista de héroes está vacía
            showError = heroes.isEmpty
        } catch {
            // Si ocurre un error, actualizar el estado de error
            showError = true
            print("Error al cargar héroes: \(error.localizedDescription)")
        }

        // Finalizar el estado de carga
        isLoading = false
    }
    
    /// Realiza el proceso de logout eliminando el token almacenado.
    func logout() {
        TokenManager.shared.deleteToken()
    }
}
