//
//  LoginViewControllerTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class LoginViewTests: XCTestCase {
    
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
        let loginViewController = await LoginViewController(viewModel: LoginViewModel())
        XCTAssertNotNil(loginViewController, "LoginViewController debería ser inicializable")
        
        // Cargar la vista del controlador
        await loginViewController.loadViewIfNeeded()
        
        // Verificar que el mensaje de error se muestra correctamente
        if let userMessage = loginViewModel.userMessage {
            XCTAssertEqual(userMessage.message, "Error Testing", "El mensaje de error debería coincidir con el esperado")
            XCTAssertTrue(userMessage.isError, "El mensaje debería marcarse como error")
        } else {
            XCTFail("No se configuró el mensaje de error en el ViewModel")
        }
    }
    
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
    
    
    func testHandleLoginError_InvalidCredentials() {
        let loginUseCaseFake = LoginUseCaseFake()
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        
        loginViewModel.handleLoginError(AuthenticationError.invalidCredentials)
        
        XCTAssertEqual(
            loginViewModel.userMessage?.message,
            LocalizedStrings.Errors.invalidCredentials,
            "El mensaje de error debería ser el esperado para credenciales inválidas"
        )
        XCTAssertTrue(
            loginViewModel.userMessage?.isError ?? false,
            "El mensaje debería marcarse como error"
        )
        XCTAssertEqual(
            loginViewModel.state,
            .showLogin,
            "El estado debería ser .showLogin después de un error de credenciales inválidas"
        )
    }
    
    
    func testHandleLoginError_AccessDenied() {
        let loginUseCaseFake = LoginUseCaseFake()
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        
        loginViewModel.handleLoginError(AuthenticationError.accessDenied)
        
        XCTAssertEqual(
            loginViewModel.userMessage?.message,
            LocalizedStrings.Errors.accessDenied,
            "El mensaje de error debería ser el esperado para acceso denegado"
        )
        XCTAssertTrue(
            loginViewModel.userMessage?.isError ?? false,
            "El mensaje debería marcarse como error"
        )
        XCTAssertEqual(
            loginViewModel.state,
            .showLogin,
            "El estado debería ser .showLogin después de un error de acceso denegado"
        )
    }
    
    func testHandleLoginError_ServerError() {
        let loginUseCaseFake = LoginUseCaseFake()
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        
        loginViewModel.handleLoginError(AuthenticationError.serverError(statusCode: 500))
        
        XCTAssertEqual(
            loginViewModel.userMessage?.message,
            String(format: LocalizedStrings.Errors.serverError, 500),
            "El mensaje de error debería incluir el código de error del servidor"
        )
        XCTAssertTrue(
            loginViewModel.userMessage?.isError ?? false,
            "El mensaje debería marcarse como error"
        )
        XCTAssertEqual(
            loginViewModel.state,
            .showLogin,
            "El estado debería ser .showLogin después de un error del servidor"
        )
    }
    
    func testHandleLoginError_UnexpectedError() {
        let loginUseCaseFake = LoginUseCaseFake()
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        
        loginViewModel.handleLoginError(AuthenticationError.unexpectedError)
        
        XCTAssertEqual(
            loginViewModel.userMessage?.message,
            LocalizedStrings.Errors.unexpectedError,
            "El mensaje de error debería ser el esperado para un error inesperado"
        )
        XCTAssertTrue(
            loginViewModel.userMessage?.isError ?? false,
            "El mensaje debería marcarse como error"
        )
        XCTAssertEqual(
            loginViewModel.state,
            .showLogin,
            "El estado debería ser .showLogin después de un error inesperado"
        )
    }
}
