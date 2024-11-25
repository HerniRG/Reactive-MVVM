//
//  ToastViewTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class ToastViewTests: XCTestCase {
    
    func testToastViewInitialization() {
        // Crear una instancia de ToastView
        let toast = ToastView()
        
        // Verificar que se inicializa correctamente
        XCTAssertNotNil(toast, "ToastView debería inicializarse correctamente")
        
        // Verificar que los valores predeterminados son correctos
        XCTAssertEqual(toast.backgroundColor, .black, "El color de fondo por defecto debería ser negro")
        XCTAssertEqual(toast.layer.cornerRadius, 4, "ToastView debería tener esquinas redondeadas con radio 4")
        XCTAssertTrue(toast.clipsToBounds, "ToastView debería recortar las subcapas fuera de los bordes")
    }
    
    func testToastViewConfiguration() {
        // Crear una instancia de ToastView
        let toast = ToastView()
        
        // Configurar mensaje y color de fondo
        let message = "Test Message"
        let color = UIColor.red
        toast.configure(message: message, backgroundColor: color)
        
        // Verificar configuración
        XCTAssertEqual(toast.backgroundColor, color, "El color de fondo debería configurarse correctamente")
    }
    
    func testToastViewShow() {
        // Crear un contenedor simulado
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        
        // Crear una instancia de ToastView
        let toast = ToastView()
        
        // Configurar y mostrar el ToastView
        toast.configure(message: "Hello Toast", backgroundColor: .blue)
        toast.show(in: containerView, duration: 1.0)
        
        // Verificar que el ToastView se agregó al contenedor
        XCTAssertTrue(containerView.subviews.contains(toast), "ToastView debería ser añadido al contenedor")
        
        // Simular la animación de desaparición después del tiempo configurado
        let expectation = self.expectation(description: "ToastView should be removed from the container")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(containerView.subviews.contains(toast), "ToastView debería ser eliminado del contenedor tras mostrarse")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
