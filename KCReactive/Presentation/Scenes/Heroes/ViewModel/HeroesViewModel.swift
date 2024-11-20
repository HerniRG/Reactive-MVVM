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
    @Published var heroes: [Hero] = [] // Lista de héroes
    @Published var isLoading: Bool = false // Estado de carga
    @Published var errorMessage: String? = nil // Mensaje de error opcional
    
    private var heroService = HeroService() // Dependencia para realizar peticiones
    
    // MARK: - Initializer
    init(heroService: HeroService = HeroService()) {
        self.heroService = heroService
        Task {
            await loadHeroes()
        }
    }
    
    func loadHeroes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let heroes = try await heroService.getHeroes(filter: "")
            self.heroes = heroes
        } catch {
            handleLoadHeroesError(error)
        }
        
        isLoading = false
    }
    
    // Borra el token del Keychain para cerrar sesión
    func logout() {
        TokenManager.shared.deleteToken()
    }
    
    // MARK: - Private Methods
    private func handleLoadHeroesError(_ error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = "No hay conexión a internet. Por favor, verifica tu red."
            case .timedOut:
                errorMessage = "La solicitud ha tardado demasiado. Inténtalo más tarde."
            default:
                errorMessage = "Ha ocurrido un error. Intenta nuevamente."
            }
        } else {
            errorMessage = "Ha ocurrido un error desconocido."
        }
    }
}
