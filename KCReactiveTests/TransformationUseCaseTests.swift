import XCTest
@testable import KCReactive

final class TransformationUseCaseTests: XCTestCase {

    func testTransformationUseCaseWithFakeRepository() async throws {
        // Configure TransformationRepositoryFake with a simulated service
        let fakeRepository = TransformationRepositoryFake(
            transformationService: TransformationServiceFake(scenario: .success)
        )
        
        // Create the TransformationUseCase using the fake repository
        let useCase = TransformationUseCase(transformationRepo: fakeRepository)
        XCTAssertNotNil(useCase, "TransformationUseCase should initialize successfully")

        // Execute the use case to fetch transformations
        let transformations = try await useCase.getTransformations(id: "GokuID")
        XCTAssertNotNil(transformations, "Transformations response should not be nil")
        
        // Verify that the processed transformations are correct
        XCTAssertEqual(transformations.count, 2, "There should be 2 transformations after processing")
        
        // Verify the order of transformations
        XCTAssertEqual(transformations[0].name, "Super Saiyan", "The first transformation should be 'Super Saiyan'")
        XCTAssertEqual(transformations[1].name, "Ultra Instinct", "The second transformation should be 'Ultra Instinct'")
    }
}
