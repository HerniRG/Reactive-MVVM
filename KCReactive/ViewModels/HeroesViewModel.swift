//
//  HeroesViewModel.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 15/11/24.
//

import Combine
import Foundation

final class HeroesViewModel: ObservableObject {
    // Lista de héroes
    @Published var heroes: [Hero] = []
    @Published var isLoading: Bool = false // Estado de carga
    @Published var errorMessage: String? = nil // Mensaje de error opcional
    
    private var cancellables = Set<AnyCancellable>() // Set para almacenar los suscriptores
    private let heroService = HeroService() // Dependencia para realizar peticiones
    
    func loadHeroes() {
        isLoading = true
        errorMessage = nil
        
        heroService.getHeroes(filter: "")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                // Manejo de errores
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Error al cargar héroes: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] heroes in
                // Actualizar la lista de héroes
                self?.heroes = heroes
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    // Borra el token del Keychain para cerrar sesión
    func logout() {
        TokenManager.shared.deleteToken()
    }
}
