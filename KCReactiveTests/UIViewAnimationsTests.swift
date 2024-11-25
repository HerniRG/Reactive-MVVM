//
//  UIViewAnimationsTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class UIViewAnimationsTests: XCTestCase {
    
    func testFadeInAnimation() {
        let view = UIView()
        view.alpha = 0
        view.fadeIn(duration: 0.5)
        
        // Simula el final de la animación
        let expectation = self.expectation(description: "Fade-in animation should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            XCTAssertEqual(view.alpha, 1, "La vista debería tener alpha 1 tras la animación de fade-in")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testAnimateFromBottomWithBounce() {
        let view = UIView()
        let initialYOffset: CGFloat = 100
        
        // Configurar el estado inicial
        view.transform = CGAffineTransform(translationX: 0, y: initialYOffset)
        XCTAssertEqual(view.transform.ty, initialYOffset, "La vista debería comenzar con un desplazamiento vertical")
        
        view.animateFromBottomWithBounce(yOffset: initialYOffset)
        
        // Simula el final de la animación
        let expectation = self.expectation(description: "Bounce animation should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            XCTAssertEqual(view.transform, .identity, "La transformación debería ser .identity tras la animación")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.5, handler: nil)
    }
    
    func testFadeInWithTranslation() {
        let view = UIView()
        let initialYOffset: CGFloat = 100
        
        // Configurar el estado inicial
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: initialYOffset)
        XCTAssertEqual(view.alpha, 0, "La vista debería comenzar con alpha 0")
        XCTAssertEqual(view.transform.ty, initialYOffset, "La vista debería comenzar con un desplazamiento vertical")
        
        view.fadeInWithTranslation(yOffset: initialYOffset, duration: 0.5)
        
        // Simula el final de la animación
        let expectation = self.expectation(description: "Fade-in with translation animation should complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            XCTAssertEqual(view.alpha, 1, "La vista debería tener alpha 1 tras la animación")
            XCTAssertEqual(view.transform, .identity, "La transformación debería ser .identity tras la animación")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testAnimatePressEffect() {
        let view = UIView()
        let expectedScale: CGFloat = 1
        
        view.animatePress(scale: expectedScale, duration: 0.1)
        
        // Verificar el efecto inicial
        let expectationInitial = self.expectation(description: "Press effect should reduce the scale")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(view.transform.a, expectedScale, "La escala de la vista debería reducirse a \(expectedScale)")
            XCTAssertEqual(view.transform.d, expectedScale, "La escala de la vista debería reducirse a \(expectedScale)")
            expectationInitial.fulfill()
        }
        
        // Verificar que vuelva al estado original
        let expectationFinal = self.expectation(description: "Press effect should return to original scale")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertEqual(view.transform, .identity, "La transformación debería ser .identity tras la animación")
            expectationFinal.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
