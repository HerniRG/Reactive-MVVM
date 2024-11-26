//
//  LoginTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
import Combine
@testable import KCReactive

final class LoginTests: XCTestCase {
    
    func testLoginFake() async throws {
        let KC = TokenManager()
        XCTAssertNotNil(KC, "TokenManager debería inicializarse correctamente")

        KC.deleteToken() // Asegúrate de que no haya tokens persistentes al inicio.
        XCTAssertNil(KC.loadToken(), "El token debería ser nil al inicio de la prueba")
        
        // Crear instancia del caso de uso simulado
        let obj = LoginUseCaseFake()
        XCTAssertNotNil(obj, "LoginUseCaseFake debería inicializarse correctamente")
        
        // Validar token antes del login
        let initialTokenState = KC.loadToken()
        XCTAssertNil(initialTokenState, "El token no debería existir antes del login")
        
        // Verificar si hay un token válido (simulado)
        let tokenCheck = obj.checkToken()
        XCTAssertEqual(tokenCheck, true, "checkToken() debería devolver true en el caso simulado")
        
        // Realizar login
        let loginResult = try await obj.loginApp(user: "fakeUser", password: "fakePassword")
        XCTAssertEqual(loginResult, true, "El login debería ser exitoso en el caso simulado")
        
        // Validar que el token fue guardado
        let jwt = KC.loadToken()
        XCTAssertNotNil(jwt, "El token debería haberse guardado después del login")
        XCTAssertEqual(jwt, "LoginFakeSuccess", "El token guardado debería ser 'LoginFakeSuccess'")
        
        // Cerrar sesión simulada (implementar eliminación de token en TokenManager)
        KC.deleteToken()
        let afterLogoutToken = KC.loadToken()
        XCTAssertNil(afterLogoutToken, "El token debería haberse eliminado después del logout")
    }
    
    func testLoginReal() async throws {
        // Instancia de KeyChain
        let KC = TokenManager()
        XCTAssertNotNil(KC, "TokenManager debería ser inicializable")
        
        // Reiniciar el token antes de comenzar la prueba
        KC.deleteToken()
        let initialToken = KC.loadToken()
        XCTAssertNil(initialToken, "El token debería ser nil después del reinicio")
        
        // Configurar las dependencias
        let network = NetworkLoginFake(scenario: .success)
        let repo = LoginRepositoryFake(network: network)
        let userCase = LoginUseCase(repo: repo)
        XCTAssertNotNil(userCase, "LoginUseCase debería ser inicializable")
        
        // Validación inicial de token
        let tokenValidation = userCase.checkToken()
        XCTAssertEqual(tokenValidation, false, "El token debería ser inválido al inicio")
        
        // Simular login
        let loginResult = try await userCase.loginApp(user: "testUser", password: "testPassword")
        XCTAssertEqual(loginResult, true, "El login debería ser exitoso en el caso simulado")
        
        // Verificar que el token se guardó correctamente
        var jwt = KC.loadToken()
        XCTAssertNotNil(jwt, "El token debería haberse guardado después del login")
        XCTAssertEqual(jwt, "LoginFakeSuccess", "El token guardado debería ser 'LoginFakeSuccess'")
        
        // Cerrar sesión
        KC.deleteToken()
        jwt = KC.loadToken()
        XCTAssertNil(jwt, "El token debería ser nil después del logout")
    }
    
    func testLoginAutoLoginAsincrono() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = self.expectation(description: "Estado de login automático")
        
        let viewModel = LoginViewModel(loginUseCase: LoginUseCaseFake())
        XCTAssertNotNil(viewModel, "El ViewModel debería inicializarse correctamente")
        
        var didFulfill = false
        
        viewModel.$state
            .sink { state in
                print("Estado actual: \(state)")
                if state == .navigateToHeroes, !didFulfill {
                    didFulfill = true
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.triggerAutoLogin()
        
        waitForExpectations(timeout: 10)
    }
}
