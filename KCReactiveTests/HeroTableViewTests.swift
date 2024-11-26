//
//  HeroTableViewControllerTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive
import Combine

final class HeroTableViewTests: XCTestCase {
    
    func testHeroViewModel() async throws {
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "El HeroesViewModel debería ser inicializable")
        
        await viewModel.loadHeroes()
        XCTAssertEqual(viewModel.heroes.count, 3, "Debería haber 3 héroes en el caso simulado")
    }
    
    func testHeroesCombine() async throws {
        // Crear un Set para los suscriptores de Combine
        var subscriptions = Set<AnyCancellable>()
        
        // Crear una instancia del ViewModel
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "El HeroesViewModel debería ser inicializable")
        
        // Configurar una expectativa para esperar el resultado
        let expectation = XCTestExpectation(description: "Héroes obtenidos con Combine")
        
        // Suscribirse al publisher de héroes en el ViewModel
        viewModel.$heroes
            .sink { heroes in
                if heroes.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        // Simular la carga de héroes
        await viewModel.loadHeroes()
        
        // Esperar a que la expectativa se cumpla
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testViewModelInitialization() async throws {
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel debería ser inicializable")
        
        await viewModel.loadHeroes()
        XCTAssertEqual(viewModel.heroes.count, 3, "Debería haber 3 héroes simulados")
    }
    
    func testViewModelEmptyHeroes() async throws {
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel debería ser inicializable")
        
        await viewModel.loadHeroes(filter: "No existe")
        XCTAssertEqual(viewModel.heroes.count, 0, "No debería haber héroes con un filtro que no coincide")
    }
    
    func testViewModelLogout() {
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel debería ser inicializable")
        
        viewModel.logout()
        XCTAssertNil(TokenManager.shared.loadToken(), "El token debería eliminarse tras el logout")
    }
    
    func testHeroTableViewControllerInitialization() throws {
        // Crear el controlador de vista
        let heroTableViewController = HeroTableViewController()
        XCTAssertNotNil(heroTableViewController, "HeroTableViewController debería inicializarse correctamente")
        
        // Cargar la vista
        heroTableViewController.loadViewIfNeeded()
        
        // Verificar que los outlets están conectados
        XCTAssertNotNil(heroTableViewController.value(forKey: "tableView") as? UITableView, "El UITableView debería estar conectado")
        XCTAssertNotNil(heroTableViewController.value(forKey: "loadingIndicator") as? UIActivityIndicatorView, "El UIActivityIndicatorView debería estar conectado")
        XCTAssertNotNil(heroTableViewController.value(forKey: "errorLabel") as? UILabel, "El UILabel para errores debería estar conectado")
    }
}
