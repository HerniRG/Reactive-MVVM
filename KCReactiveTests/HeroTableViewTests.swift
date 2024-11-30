import XCTest
@testable import KCReactive
import Combine

final class HeroTableViewTests: XCTestCase {
    
    func testHeroViewModel() async throws {
        // Test ViewModel initialization and hero loading
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel should be initializable")
        
        await viewModel.loadHeroes()
        XCTAssertEqual(viewModel.heroes.count, 3, "There should be 3 heroes in the simulated case")
    }
    
    func testHeroesCombine() async throws {
        // Test Combine publisher for heroes
        var subscriptions = Set<AnyCancellable>()
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel should be initializable")
        
        let expectation = XCTestExpectation(description: "Heroes loaded using Combine")
        
        viewModel.$heroes
            .sink { heroes in
                if heroes.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        await viewModel.loadHeroes()
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testViewModelInitialization() async throws {
        // Test ViewModel initialization
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel should be initializable")
        
        await viewModel.loadHeroes()
        XCTAssertEqual(viewModel.heroes.count, 3, "There should be 3 simulated heroes")
    }
    
    func testViewModelEmptyHeroes() async throws {
        // Test loading heroes with no matching filter
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel should be initializable")
        
        await viewModel.loadHeroes(filter: "Nonexistent")
        XCTAssertEqual(viewModel.heroes.count, 0, "There should be no heroes matching the filter")
    }
    
    func testViewModelLogout() {
        // Test ViewModel logout behavior
        let viewModel = HeroesViewModel(heroUseCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel, "HeroesViewModel should be initializable")
        
        viewModel.logout()
        XCTAssertNil(TokenManager.shared.loadToken(), "The token should be removed after logout")
    }
    
    func testHeroTableViewControllerInitialization() throws {
        // Test ViewController initialization and outlet connections
        let heroTableViewController = HeroTableViewController()
        XCTAssertNotNil(heroTableViewController, "HeroTableViewController should initialize correctly")
        
        heroTableViewController.loadViewIfNeeded()
        
        XCTAssertNotNil(heroTableViewController.value(forKey: "tableView") as? UITableView, "The UITableView should be connected")
        XCTAssertNotNil(heroTableViewController.value(forKey: "loadingIndicator") as? UIActivityIndicatorView, "The UIActivityIndicatorView should be connected")
        XCTAssertNotNil(heroTableViewController.value(forKey: "errorLabel") as? UILabel, "The UILabel for errors should be connected")
    }
}
