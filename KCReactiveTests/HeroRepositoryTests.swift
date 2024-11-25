//
//  HeroRepositoryTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class HeroRepositoryTests: XCTestCase {
    
    func testHeroRepository() async throws {
        let networkFake = HeroServiceFake(scenario: .success)
        let heroRepository = DefaultHeroRepository(heroService: networkFake)
        XCTAssertNotNil(heroRepository, "HeroRepository debería ser inicializable")
        
        let heroes = try await heroRepository.getHeroes(filter: "")
        XCTAssertNotNil(heroes, "La respuesta de héroes no debería ser nil")
        XCTAssertEqual(heroes.count, 3, "Debería haber 3 héroes en el caso simulado")
    }
}
