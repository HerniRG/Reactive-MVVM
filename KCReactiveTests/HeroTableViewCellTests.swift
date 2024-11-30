import XCTest
@testable import KCReactive

final class HeroTableViewCellTests: XCTestCase {
    
    func testCellInitialization() {
        // Load the nib file for HeroTableViewCell
        let nib = UINib(nibName: "HeroTableViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? HeroTableViewCell
        
        // Verify that the cell initializes correctly
        XCTAssertNotNil(cell, "HeroTableViewCell should be initializable from the nib")
    }
    
    func testCellOutletsConnection() {
        // Load the nib file for HeroTableViewCell
        let nib = UINib(nibName: "HeroTableViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? HeroTableViewCell
        
        // Verify that the outlets are connected
        XCTAssertNotNil(cell?.title, "The UILabel for the title should be connected")
        XCTAssertNotNil(cell?.photo, "The UIImageView for the photo should be connected")
        XCTAssertNotNil(cell?.containerView, "The UIView for the container should be connected")
    }
    
    func testUIConfiguration() {
        // Load the nib file for HeroTableViewCell
        let nib = UINib(nibName: "HeroTableViewCell", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        let cell = objects.first as? HeroTableViewCell
        
        // Force the UI setup
        cell?.awakeFromNib()
        
        // Verify container-specific configurations
        XCTAssertEqual(cell?.containerView.layer.cornerRadius, 12, "The container should have a corner radius of 12")
        XCTAssertTrue(cell?.containerView.layer.masksToBounds ?? false, "The container should clip sublayers to its bounds")
        XCTAssertEqual(cell?.containerView.backgroundColor, UIColor.systemGray6, "The container should have a light gray background")
        
        // Verify shadow-specific configurations
        XCTAssertEqual(cell?.layer.shadowColor, UIColor.black.cgColor, "The shadow should be black")
        XCTAssertEqual(cell?.layer.shadowOpacity, 0.2, "The shadow opacity should be 0.2")
        XCTAssertEqual(cell?.layer.shadowOffset, CGSize(width: 0, height: 4), "The shadow offset should be (0, 4)")
        XCTAssertEqual(cell?.layer.shadowRadius, 6, "The shadow radius should be 6")
        XCTAssertFalse(cell?.layer.masksToBounds ?? true, "The main layer should not clip the shadows")
        
        // Verify title-specific configurations
        XCTAssertEqual(cell?.title.textColor, UIColor.systemGray, "The title's text color should be gray")
    }
}
