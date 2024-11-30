import XCTest
@testable import KCReactive

final class HeroRepositoryTests: XCTestCase {
    
    func testHeroRepository() async throws {
        // Simulate a successful network response
        let networkFake = HeroServiceFake(scenario: .success)
        
        // Initialize the repository with the fake service
        let heroRepository = DefaultHeroRepository(heroService: networkFake)
        XCTAssertNotNil(heroRepository, "HeroRepository should be initializable")
        
        // Fetch heroes and verify the response
        let heroes = try await heroRepository.getHeroes(filter: "")
        XCTAssertNotNil(heroes, "The hero response should not be nil")
        XCTAssertEqual(heroes.count, 3, "There should be 3 heroes in the simulated case")
    }
}
