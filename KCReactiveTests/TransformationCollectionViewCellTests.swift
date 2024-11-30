import XCTest
@testable import KCReactive

final class TransformationCollectionViewCellTests: XCTestCase {

    // MARK: - Initialization Tests
    func testCollectionViewCellInitialization() {
        // Load the nib for TransformationCollectionViewCell
        let nib = UINib(nibName: "TransformationCollectionViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? TransformationCollectionViewCell
        
        // Verify that the cell initializes correctly
        XCTAssertNotNil(cell, "TransformationCollectionViewCell should be initializable from the nib")
    }
    
    // MARK: - Outlet Connection Tests
    func testCollectionViewCellOutletsConnection() {
        // Load the nib for TransformationCollectionViewCell
        let nib = UINib(nibName: "TransformationCollectionViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? TransformationCollectionViewCell
        
        // Verify that the outlets are connected
        XCTAssertNotNil(cell?.transformationImageView, "The UIImageView for the transformation should be connected")
        XCTAssertNotNil(cell?.transformationLabel, "The UILabel for the transformation name should be connected")
        XCTAssertNotNil(cell?.containerView, "The UIView for the container should be connected")
    }
    
    // MARK: - UI Configuration Tests
    func testCollectionViewCellUIConfiguration() {
        // Load the nib for TransformationCollectionViewCell
        let nib = UINib(nibName: "TransformationCollectionViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? TransformationCollectionViewCell
        
        // Force UI initialization
        cell?.awakeFromNib()
        
        // Verify specific container configurations
        XCTAssertEqual(cell?.containerView.layer.cornerRadius, 12, "The container should have a corner radius of 12")
        XCTAssertTrue(cell?.containerView.layer.masksToBounds ?? false, "The container should clip sublayers to its bounds")
        XCTAssertEqual(cell?.containerView.backgroundColor, UIColor.systemGray6, "The container should have a light gray background")
        
        // Verify specific shadow configurations
        XCTAssertEqual(cell?.layer.shadowColor, UIColor.black.cgColor, "The shadow should be black")
        XCTAssertEqual(cell?.layer.shadowOpacity, 0.1, "The shadow opacity should be 0.1")
        XCTAssertEqual(cell?.layer.shadowOffset, CGSize(width: 0, height: 2), "The shadow offset should be (0, 2)")
        XCTAssertEqual(cell?.layer.shadowRadius, 4, "The shadow radius should be 4")
        XCTAssertFalse(cell?.layer.masksToBounds ?? true, "The main layer should not clip shadows")
        
        // Verify specific image configurations
        XCTAssertTrue(cell?.transformationImageView.clipsToBounds ?? false, "The image should clip content outside its bounds")
    }
    
    // MARK: - Data Configuration Tests
    func testCollectionViewCellConfigurationWithTransformation() {
        // Create a simulated transformation
        let transformation = Transformation(
            id: UUID(),
            name: "Super Saiyan",
            description: "First Saiyan transformation.",
            photo: "https://example.com/super_saiyan.jpg"
        )
        
        // Load the nib for TransformationCollectionViewCell
        let nib = UINib(nibName: "TransformationCollectionViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? TransformationCollectionViewCell
        
        // Configure the cell with the simulated transformation
        cell?.configure(with: transformation)
        
        // Verify that the cell displays the data correctly
        XCTAssertEqual(cell?.transformationLabel.text, "Super Saiyan", "The label should display the transformation name")
    }
}
