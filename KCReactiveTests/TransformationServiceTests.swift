import XCTest
@testable import KCReactive

final class TransformationServiceTests: XCTestCase {
    
    // Test for the fake service with a successful response
    func testTransformationServiceFakeSuccess() async throws {
        let service = TransformationServiceFake(scenario: .success)
        
        // Simulate a valid ID for Goku
        let transformations = try await service.getTransformations(id: "GokuID")
        
        // Verify the number of transformations returned
        XCTAssertEqual(transformations.count, 2, "Should return 2 transformations for Goku")
        
        // Verify the names of the transformations
        XCTAssertEqual(transformations[0].name, "Super Saiyan", "The first transformation should be 'Super Saiyan'")
        XCTAssertEqual(transformations[1].name, "Ultra Instinct", "The second transformation should be 'Ultra Instinct'")
    }
    
    // Test for the fake service with an empty response
    func testTransformationServiceFakeEmpty() async throws {
        let service = TransformationServiceFake(scenario: .empty)
        
        // Simulate an unknown ID
        let transformations = try await service.getTransformations(id: "UnknownID")
        
        // Verify no transformations are returned
        XCTAssertEqual(transformations.count, 0, "Should not return transformations for an unknown ID")
    }
}
