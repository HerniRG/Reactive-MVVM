import XCTest
@testable import KCReactive

final class DetailsTests: XCTestCase {

    // MARK: - Tests for DetailsViewModel
    
    func testDetailsViewModelInitialization() async throws {
        // Create a simulated hero
        let hero = Hero(id: UUID(), name: "Goku", description: "The most powerful Saiyan.", photo: "https://example.com/goku.jpg", favorite: true)
        
        // Create a simulated use case
        let useCase = TransformationUseCaseFake()
        
        // Initialize the ViewModel
        let viewModel = DetailsViewModel(hero: hero, transformationUseCase: useCase)
        XCTAssertNotNil(viewModel, "DetailsViewModel should be initializable")
        XCTAssertEqual(viewModel.hero.name, "Goku", "The hero should be 'Goku'")
        
        // Load the transformations
        await viewModel.loadTransformations()
        XCTAssertNotNil(viewModel.transformations, "Transformations should have been loaded")
        XCTAssertEqual(viewModel.transformations?.count, 2, "There should be 2 simulated transformations")
    }

    // MARK: - Tests for DetailsViewController

    func testDetailsViewControllerInitialization() throws {
        // Create a simulated hero
        let hero = Hero(id: UUID(), name: "Goku", description: "The most powerful Saiyan.", photo: "https://example.com/goku.jpg", favorite: true)
        
        // Create a simulated use case
        let useCase = TransformationUseCaseFake()
        
        // Create the ViewModel
        let viewModel = DetailsViewModel(hero: hero, transformationUseCase: useCase)
        
        // Initialize the ViewController
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        XCTAssertNotNil(detailsViewController, "DetailsViewController should be initializable")
        
        // Load the view
        detailsViewController.loadViewIfNeeded()
        
        // Verify that outlets exist
        XCTAssertNotNil(detailsViewController.value(forKey: "imageView") as? UIImageView, "The UIImageView should exist")
        XCTAssertNotNil(detailsViewController.value(forKey: "descriptionLabel") as? UILabel, "The UILabel should exist")
        XCTAssertNotNil(detailsViewController.value(forKey: "transformationsCollectionView") as? UICollectionView, "The UICollectionView should exist")
    }
}
