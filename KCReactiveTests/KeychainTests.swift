//
//  KeychainTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class KeychainTests: XCTestCase {
    
    func testKeyChainLibrary() throws {
        let tokenManager = TokenManager()
        
        // Verificar que el objeto se crea correctamente
        XCTAssertNotNil(tokenManager, "TokenManager debería inicializarse correctamente")
        
        // Guardar un token y verificar que se guardó correctamente
        tokenManager.saveToken("123")
        let savedToken = tokenManager.loadToken()
        XCTAssertNotNil(savedToken, "El token debería haberse guardado correctamente")
        XCTAssertEqual(savedToken, "123", "El token recuperado no coincide con el guardado")
        
        // Eliminar el token y verificar que se eliminó correctamente
        tokenManager.deleteToken()
        let deletedToken = tokenManager.loadToken()
        XCTAssertNil(deletedToken, "El token debería haberse eliminado correctamente")
    }
}
