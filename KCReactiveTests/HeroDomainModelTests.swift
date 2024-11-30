import XCTest
@testable import KCReactive

final class HeroDomainModelTests: XCTestCase {
    
    func testHeroDomainModel() {
        // Test initializing a Hero model
        let hero = Hero(id: UUID(), name: "Goku", description: "The most powerful Saiyan.", photo: "url", favorite: true)
        XCTAssertNotNil(hero, "The Hero model should be initializable")
        XCTAssertEqual(hero.name, "Goku", "The hero's name should be 'Goku'")
        XCTAssertTrue((hero.favorite != nil), "The hero should be marked as favorite")
        
        // Test initializing a HeroFilter model
        let requestModel = HeroFilter(name: "Goku")
        XCTAssertNotNil(requestModel, "The filter model should be initializable")
        XCTAssertEqual(requestModel.name, "Goku", "The filter should match the provided name")
    }
    
    func testHeroUseCase() async throws {
        // Test initializing the HeroUseCase
        let heroUseCase = HeroUseCase(heroRepo: HeroRepositoryFake(heroService: HeroServiceFake(scenario: .success)))
        XCTAssertNotNil(heroUseCase, "HeroUseCase should be initializable")
        
        // Test fetching heroes using the use case
        let heroes = try await heroUseCase.getHeroes(filter: "")
        XCTAssertNotNil(heroes, "The hero response should not be nil")
        XCTAssertEqual(heroes.count, 3, "There should be 3 heroes in the simulated case")
    }
}
