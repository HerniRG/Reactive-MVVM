//
//  DetailsViewTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class DetailsTests: XCTestCase {

    // MARK: - Tests para DetailsViewModel
    
    @MainActor
    func testDetailsViewModelInitialization() async throws {
        // Crear un héroe simulado
        let hero = Hero(id: UUID(), name: "Goku", description: "El Saiyan más poderoso.", photo: "https://example.com/goku.jpg", favorite: true, transformations: nil)
        
        // Crear un caso de uso simulado
        let useCase = TransformationUseCaseFake()
        
        // Inicializar el ViewModel
        let viewModel = DetailsViewModel(hero: hero, transformationUseCase: useCase)
        XCTAssertNotNil(viewModel, "DetailsViewModel debería ser inicializable")
        XCTAssertEqual(viewModel.hero.name, "Goku", "El héroe debería ser 'Goku'")
        
        // Cargar las transformaciones
        await viewModel.loadTransformations()
        XCTAssertNotNil(viewModel.transformations, "Las transformaciones deberían haberse cargado")
        XCTAssertEqual(viewModel.transformations?.count, 2, "Debería haber 2 transformaciones simuladas")
    }

    // MARK: - Tests para DetailsViewController

    @MainActor
    func testDetailsViewControllerInitialization() throws {
        // Crear un héroe simulado
        let hero = Hero(id: UUID(), name: "Goku", description: "El Saiyan más poderoso.", photo: "https://example.com/goku.jpg", favorite: true, transformations: nil)
        
        // Crear un caso de uso simulado
        let useCase = TransformationUseCaseFake()
        
        // Crear el ViewModel
        let viewModel = DetailsViewModel(hero: hero, transformationUseCase: useCase)
        
        // Inicializar el ViewController
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        XCTAssertNotNil(detailsViewController, "DetailsViewController debería ser inicializable")
        
        // Cargar la vista
        detailsViewController.loadViewIfNeeded()
        
        // Verificar que los outlets existen
        XCTAssertNotNil(detailsViewController.value(forKey: "imageView") as? UIImageView, "El UIImageView debería existir")
        XCTAssertNotNil(detailsViewController.value(forKey: "descriptionLabel") as? UILabel, "El UILabel debería existir")
        XCTAssertNotNil(detailsViewController.value(forKey: "transformationsCollectionView") as? UICollectionView, "El UICollectionView debería existir")
    }
}
