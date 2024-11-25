//
//  HeroDomainModelTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class HeroDomainModelTests: XCTestCase {
    
    func testHeroDomainModel() {
        let hero = Hero(id: UUID(), name: "Goku", description: "El Saiyan más poderoso.", photo: "url", favorite: true, transformations: nil)
        XCTAssertNotNil(hero, "El modelo de Hero debería ser inicializable")
        XCTAssertEqual(hero.name, "Goku", "El nombre del héroe debería ser 'Goku'")
        XCTAssertTrue((hero.favorite != nil), "El héroe debería estar marcado como favorito")
        
        let requestModel = HeroFilter(name: "Goku")
        XCTAssertNotNil(requestModel, "El modelo de filtro debería ser inicializable")
        XCTAssertEqual(requestModel.name, "Goku", "El filtro debería coincidir con el nombre proporcionado")
    }
    
    func testHeroUseCase() async throws {
        let heroUseCase = HeroUseCase(heroRepo: HeroRepositoryFake(heroService: HeroServiceFake(scenario: .success) ))
        XCTAssertNotNil(heroUseCase, "HeroUseCase debería ser inicializable")
        
        let heroes = try await heroUseCase.getHeroes(filter: "")
        XCTAssertNotNil(heroes, "La respuesta de héroes no debería ser nil")
        XCTAssertEqual(heroes.count, 3, "Debería haber 3 héroes en el caso simulado")
    }
}
