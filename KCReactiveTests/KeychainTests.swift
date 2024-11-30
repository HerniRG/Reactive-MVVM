import XCTest
@testable import KCReactive

final class KeychainTests: XCTestCase {
    
    func testKeyChainLibrary() throws {
        let tokenManager = TokenManager()
        
        // Verify that the TokenManager initializes correctly
        XCTAssertNotNil(tokenManager, "TokenManager should initialize successfully")
        
        // Save a token and verify it was saved correctly
        tokenManager.saveToken("123")
        let savedToken = tokenManager.loadToken()
        XCTAssertNotNil(savedToken, "The token should be saved successfully")
        XCTAssertEqual(savedToken, "123", "The retrieved token should match the saved token")
        
        // Delete the token and verify it was deleted correctly
        tokenManager.deleteToken()
        let deletedToken = tokenManager.loadToken()
        XCTAssertNil(deletedToken, "The token should be deleted successfully")
    }
}
