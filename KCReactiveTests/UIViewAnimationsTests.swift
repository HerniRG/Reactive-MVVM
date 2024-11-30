import XCTest
@testable import KCReactive

final class UIViewAnimationsTests: XCTestCase {
    
    func testFadeInAnimation() {
        let view = UIView()
        view.alpha = 0
        view.fadeIn(duration: 0.5)
        
        // Simulate animation completion
        let expectation = self.expectation(description: "Fade-in animation should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            XCTAssertEqual(view.alpha, 1, "The view's alpha should be 1 after the fade-in animation")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testAnimateFromBottomWithBounce() {
        let view = UIView()
        let initialYOffset: CGFloat = 100
        
        // Set the initial state
        view.transform = CGAffineTransform(translationX: 0, y: initialYOffset)
        XCTAssertEqual(view.transform.ty, initialYOffset, "The view should start with a vertical offset")
        
        view.animateFromBottomWithBounce(yOffset: initialYOffset)
        
        // Simulate animation completion
        let expectation = self.expectation(description: "Bounce animation should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            XCTAssertEqual(view.transform, .identity, "The transform should be .identity after the animation")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.5, handler: nil)
    }
    
    func testFadeInWithTranslation() {
        let view = UIView()
        let initialYOffset: CGFloat = 100
        
        // Set the initial state
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: initialYOffset)
        XCTAssertEqual(view.alpha, 0, "The view should start with alpha 0")
        XCTAssertEqual(view.transform.ty, initialYOffset, "The view should start with a vertical offset")
        
        view.fadeInWithTranslation(yOffset: initialYOffset, duration: 0.5)
        
        // Simulate animation completion
        let expectation = self.expectation(description: "Fade-in with translation animation should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            XCTAssertEqual(view.alpha, 1, "The view's alpha should be 1 after the animation")
            XCTAssertEqual(view.transform, .identity, "The transform should be .identity after the animation")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testAnimatePressEffect() {
        let view = UIView()
        let expectedScale: CGFloat = 1
        
        view.animatePress(scale: expectedScale, duration: 0.1)
        
        // Verify initial effect
        let expectationInitial = self.expectation(description: "Press effect should reduce the scale")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(view.transform.a, expectedScale, "The view's scale should reduce to \(expectedScale)")
            XCTAssertEqual(view.transform.d, expectedScale, "The view's scale should reduce to \(expectedScale)")
            expectationInitial.fulfill()
        }
        
        // Verify return to original state
        let expectationFinal = self.expectation(description: "Press effect should return to original scale")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertEqual(view.transform, .identity, "The transform should be .identity after the animation")
            expectationFinal.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
