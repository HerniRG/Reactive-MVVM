//
//  DetailsViewModel.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 19/11/24.
//

import Combine
import Foundation

final class DetailsViewModel: ObservableObject {
    // MARK: - Propiedades Publicadas
    @Published var transformations: [Transformation]? = nil
    @Published var isFavorite: Bool

    // MARK: - Propiedades Públicas
    let hero: Hero

    // MARK: - Propiedades Privadas
    private let transformationUseCase: TransformationUseCaseProtocol

    // MARK: - Inicializador
    init(
        hero: Hero,
        transformationUseCase: TransformationUseCaseProtocol = TransformationUseCase()
    ) {
        self.hero = hero
        self.transformationUseCase = transformationUseCase
        self.isFavorite = hero.favorite ?? false // Inicializamos con el estado del héroe
        
        Task {
            await loadTransformations()
        }
    }

    // MARK: - Métodos Públicos
    func toggleFavorite() {
        isFavorite.toggle() // es solo para un manejo visual, no lo persistimos o llamamos a la api.
    }

    func loadTransformations() async {
        do {
            let fetchedTransformations = try await transformationUseCase.getTransformations(id: hero.id.uuidString)
            self.transformations = fetchedTransformations.isEmpty ? nil : fetchedTransformations
        } catch {
            self.transformations = nil
        }
    }
}
