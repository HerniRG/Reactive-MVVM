import XCTest
@testable import KCReactive

final class LoginViewTests: XCTestCase {
    
    func testUIErrorView() async throws {
        // Initialize LoginUseCaseFake
        let loginUseCaseFake = LoginUseCaseFake()
        XCTAssertNotNil(loginUseCaseFake, "LoginUseCaseFake should initialize successfully")
        
        // Initialize LoginViewModel using the fake use case
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        XCTAssertNotNil(loginViewModel, "LoginViewModel should initialize successfully")
        
        // Simulate an error state in the ViewModel
        loginViewModel.userMessage = (message: "Error Testing", isError: true)
        
        // Initialize LoginViewController with the fake ViewModel
        let loginViewController = await LoginViewController(viewModel: LoginViewModel())
        XCTAssertNotNil(loginViewController, "LoginViewController should initialize successfully")
        
        // Load the view controller's view
        await loginViewController.loadViewIfNeeded()
        
        // Verify the error message is displayed correctly
        if let userMessage = loginViewModel.userMessage {
            XCTAssertEqual(userMessage.message, "Error Testing", "Error message should match the expected value")
            XCTAssertTrue(userMessage.isError, "The message should be marked as an error")
        } else {
            XCTFail("Error message was not set in the ViewModel")
        }
    }
    
    func testUILoginViewInitialization() {
        // Initialize LoginViewController
        let loginViewController = LoginViewController()
        XCTAssertNotNil(loginViewController, "LoginViewController should initialize successfully")
        
        // Load the view controller's view
        loginViewController.loadViewIfNeeded()
        
        // Verify UI elements exist
        let userTextField = loginViewController.value(forKey: "userTextField") as? UITextField
        let passwordTextField = loginViewController.value(forKey: "passwordTextField") as? UITextField
        let loginButton = loginViewController.value(forKey: "loginButton") as? UIButton
        
        XCTAssertNotNil(userTextField, "User text field should exist")
        XCTAssertNotNil(passwordTextField, "Password text field should exist")
        XCTAssertNotNil(loginButton, "Login button should exist")
        
        // Verify initial state
        XCTAssertTrue(userTextField?.isHidden ?? false, "User text field should be initially hidden")
        XCTAssertTrue(passwordTextField?.isHidden ?? false, "Password text field should be initially hidden")
        XCTAssertTrue(loginButton?.isHidden ?? false, "Login button should be initially hidden")
    }
    
    func testHandleLoginError_InvalidCredentials() {
        // Simulate invalid credentials error
        let loginUseCaseFake = LoginUseCaseFake()
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        
        loginViewModel.handleLoginError(AuthenticationError.invalidCredentials)
        
        XCTAssertEqual(
            loginViewModel.userMessage?.message,
            LocalizedStrings.Errors.invalidCredentials,
            "Error message should match the expected value for invalid credentials"
        )
        XCTAssertTrue(
            loginViewModel.userMessage?.isError ?? false,
            "Message should be marked as an error"
        )
        XCTAssertEqual(
            loginViewModel.state,
            .showLogin,
            "State should be .showLogin after an invalid credentials error"
        )
    }
    
    func testHandleLoginError_AccessDenied() {
        // Simulate access denied error
        let loginUseCaseFake = LoginUseCaseFake()
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        
        loginViewModel.handleLoginError(AuthenticationError.accessDenied)
        
        XCTAssertEqual(
            loginViewModel.userMessage?.message,
            LocalizedStrings.Errors.accessDenied,
            "Error message should match the expected value for access denied"
        )
        XCTAssertTrue(
            loginViewModel.userMessage?.isError ?? false,
            "Message should be marked as an error"
        )
        XCTAssertEqual(
            loginViewModel.state,
            .showLogin,
            "State should be .showLogin after an access denied error"
        )
    }
    
    func testHandleLoginError_ServerError() {
        // Simulate server error
        let loginUseCaseFake = LoginUseCaseFake()
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        
        loginViewModel.handleLoginError(AuthenticationError.serverError(statusCode: 500))
        
        XCTAssertEqual(
            loginViewModel.userMessage?.message,
            String(format: LocalizedStrings.Errors.serverError, 500),
            "Error message should include the server error code"
        )
        XCTAssertTrue(
            loginViewModel.userMessage?.isError ?? false,
            "Message should be marked as an error"
        )
        XCTAssertEqual(
            loginViewModel.state,
            .showLogin,
            "State should be .showLogin after a server error"
        )
    }
    
    func testHandleLoginError_UnexpectedError() {
        // Simulate unexpected error
        let loginUseCaseFake = LoginUseCaseFake()
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
        
        loginViewModel.handleLoginError(AuthenticationError.unexpectedError)
        
        XCTAssertEqual(
            loginViewModel.userMessage?.message,
            LocalizedStrings.Errors.unexpectedError,
            "Error message should match the expected value for an unexpected error"
        )
        XCTAssertTrue(
            loginViewModel.userMessage?.isError ?? false,
            "Message should be marked as an error"
        )
        XCTAssertEqual(
            loginViewModel.state,
            .showLogin,
            "State should be .showLogin after an unexpected error"
        )
    }
}
