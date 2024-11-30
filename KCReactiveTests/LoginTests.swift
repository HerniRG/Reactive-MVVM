import XCTest
import Combine
@testable import KCReactive

final class LoginTests: XCTestCase {
    
    func testLoginFake() async throws {
        let KC = TokenManager()
        XCTAssertNotNil(KC, "TokenManager should initialize successfully")
        
        // Ensure no tokens persist at the start
        KC.deleteToken()
        XCTAssertNil(KC.loadToken(), "Token should be nil at the start of the test")
        
        // Create a fake use case instance
        let obj = LoginUseCaseFake()
        XCTAssertNotNil(obj, "LoginUseCaseFake should initialize successfully")
        
        // Validate token state before login
        let initialTokenState = KC.loadToken()
        XCTAssertNil(initialTokenState, "Token should not exist before login")
        
        // Check for a valid token (simulated)
        let tokenCheck = obj.checkToken()
        XCTAssertEqual(tokenCheck, true, "checkToken() should return true in the simulated case")
        
        // Perform login
        let loginResult = try await obj.loginApp(user: "fakeUser", password: "fakePassword")
        XCTAssertEqual(loginResult, true, "Login should succeed in the simulated case")
        
        // Validate that the token was saved
        let jwt = KC.loadToken()
        XCTAssertNotNil(jwt, "Token should be saved after login")
        XCTAssertEqual(jwt, "LoginFakeSuccess", "Saved token should match 'LoginFakeSuccess'")
        
        // Simulate logout and validate token deletion
        KC.deleteToken()
        let afterLogoutToken = KC.loadToken()
        XCTAssertNil(afterLogoutToken, "Token should be deleted after logout")
    }
    
    func testLoginReal() async throws {
        let KC = TokenManager()
        XCTAssertNotNil(KC, "TokenManager should initialize successfully")
        
        // Reset token before starting the test
        KC.deleteToken()
        let initialToken = KC.loadToken()
        XCTAssertNil(initialToken, "Token should be nil after reset")
        
        // Set up dependencies
        let network = NetworkLoginFake(scenario: .success)
        let repo = LoginRepositoryFake(network: network)
        let userCase = LoginUseCase(repo: repo)
        XCTAssertNotNil(userCase, "LoginUseCase should initialize successfully")
        
        // Validate token state before login
        let tokenValidation = userCase.checkToken()
        XCTAssertEqual(tokenValidation, false, "Token should be invalid at the start")
        
        // Simulate login
        let loginResult = try await userCase.loginApp(user: "testUser", password: "testPassword")
        XCTAssertEqual(loginResult, true, "Login should succeed in the simulated case")
        
        // Verify that the token was saved
        var jwt = KC.loadToken()
        XCTAssertNotNil(jwt, "Token should be saved after login")
        XCTAssertEqual(jwt, "LoginFakeSuccess", "Saved token should match 'LoginFakeSuccess'")
        
        // Logout and validate token deletion
        KC.deleteToken()
        jwt = KC.loadToken()
        XCTAssertNil(jwt, "Token should be nil after logout")
    }
    
    func testLoginAutoLoginAsincrono() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = self.expectation(description: "Auto-login state")
        
        let viewModel = LoginViewModel(loginUseCase: LoginUseCaseFake())
        XCTAssertNotNil(viewModel, "ViewModel should initialize successfully")
        
        var didFulfill = false
        
        // Observe state changes
        viewModel.$state
            .sink { state in
                print("Current state: \(state)")
                if state == .navigateToHeroes, !didFulfill {
                    didFulfill = true
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        // Trigger auto-login
        viewModel.triggerAutoLogin()
        
        waitForExpectations(timeout: 10)
    }
}
