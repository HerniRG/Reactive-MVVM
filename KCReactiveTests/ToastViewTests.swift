import XCTest
@testable import KCReactive

final class ToastViewTests: XCTestCase {
    
    func testToastViewInitialization() {
        // Create an instance of ToastView
        let toast = ToastView()
        
        // Verify initialization
        XCTAssertNotNil(toast, "ToastView should initialize successfully")
        
        // Verify default values
        XCTAssertEqual(toast.backgroundColor, .black, "Default background color should be black")
        XCTAssertEqual(toast.layer.cornerRadius, 4, "ToastView should have a corner radius of 4")
        XCTAssertTrue(toast.clipsToBounds, "ToastView should clip sublayers outside its bounds")
    }
    
    func testToastViewConfiguration() {
        // Create an instance of ToastView
        let toast = ToastView()
        
        // Configure message and background color
        let message = "Test Message"
        let color = UIColor.red
        toast.configure(message: message, backgroundColor: color)
        
        // Verify configuration
        XCTAssertEqual(toast.backgroundColor, color, "Background color should be set correctly")
    }
    
    func testToastViewShow() {
        // Create a simulated container
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        
        // Create an instance of ToastView
        let toast = ToastView()
        
        // Configure and show ToastView
        toast.configure(message: "Hello Toast", backgroundColor: .blue)
        toast.show(in: containerView, duration: 1.0)
        
        // Verify that ToastView is added to the container
        XCTAssertTrue(containerView.subviews.contains(toast), "ToastView should be added to the container")
        
        // Simulate disappearance animation after the configured duration
        let expectation = self.expectation(description: "ToastView should be removed from the container")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(containerView.subviews.contains(toast), "ToastView should be removed from the container after showing")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
