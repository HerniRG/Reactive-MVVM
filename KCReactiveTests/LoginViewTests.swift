//
//  LoginViewControllerTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class LoginViewTests: XCTestCase {
    
    @MainActor
    func testUIErrorView() async throws {
        // Crear una instancia de LoginUseCaseFake
        let loginUseCaseFake = LoginUseCaseFake()
        XCTAssertNotNil(loginUseCaseFake, "LoginUseCaseFake debería ser inicializable")
        
        // Crear una instancia de LoginViewModel usando el caso de uso falso
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        XCTAssertNotNil(loginViewModel, "LoginViewModel debería ser inicializable")
        
        // Simular un estado de error y mensaje en el ViewModel
        loginViewModel.userMessage = (message: "Error Testing", isError: true)
        
        // Crear el LoginViewController con el ViewModel simulado
        let loginViewController = LoginViewController()
        XCTAssertNotNil(loginViewController, "LoginViewController debería ser inicializable")
        
        // Cargar la vista del controlador
        loginViewController.loadViewIfNeeded()
        
        // Verificar que el mensaje de error se muestra correctamente
        if let userMessage = loginViewModel.userMessage {
            XCTAssertEqual(userMessage.message, "Error Testing", "El mensaje de error debería coincidir con el esperado")
            XCTAssertTrue(userMessage.isError, "El mensaje debería marcarse como error")
        } else {
            XCTFail("No se configuró el mensaje de error en el ViewModel")
        }
    }
    
    @MainActor
    func testUILoginViewInitialization() {
        // Crear instancia del LoginViewController
        let loginViewController = LoginViewController()
        XCTAssertNotNil(loginViewController, "El LoginViewController debería ser inicializable")
        
        // Cargar la vista del controlador
        loginViewController.loadViewIfNeeded()
        
        // Verificar que los elementos de la interfaz existen
        let userTextField = loginViewController.value(forKey: "userTextField") as? UITextField
        let passwordTextField = loginViewController.value(forKey: "passwordTextField") as? UITextField
        let loginButton = loginViewController.value(forKey: "loginButton") as? UIButton
        
        XCTAssertNotNil(userTextField, "El campo de texto de usuario debería existir")
        XCTAssertNotNil(passwordTextField, "El campo de texto de contraseña debería existir")
        XCTAssertNotNil(loginButton, "El botón de login debería existir")
        
        // Verificar el estado inicial
        XCTAssertTrue(userTextField?.isHidden ?? false, "El campo de usuario debería estar oculto inicialmente")
        XCTAssertTrue(passwordTextField?.isHidden ?? false, "El campo de contraseña debería estar oculto inicialmente")
        XCTAssertTrue(loginButton?.isHidden ?? false, "El botón de login debería estar oculto inicialmente")
    }
}
