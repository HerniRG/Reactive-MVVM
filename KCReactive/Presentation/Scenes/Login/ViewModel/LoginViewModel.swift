import Combine
import Foundation

// MARK: - View State Enumeration
enum State {
    case loading
    case showLogin
    case navigateToHeroes
}

// MARK: - LoginViewModel
final class LoginViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var state: State = .loading
    @Published var userMessage: (message: String, isError: Bool)?
    
    // MARK: - Private Properties
    private let loginUseCase: LoginUseCaseProtocol
    private let navigationDelay: UInt64 = 1_000_000_000 // 1 second delay in nanoseconds.
    
    // MARK: - Initializer
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
        initializeState()
    }
    
    // MARK: - Public Methods
    
    /// Resets the state for testing purposes (auto-login).
    func triggerAutoLogin() {
        initializeState()
    }
    
    /// Executes the login process for the user.
    func login(user: String, password: String) async {
        clearUserMessage()
        updateState(to: .loading)
        
        do {
            guard try await loginUseCase.loginApp(user: user, password: password) else {
                setUserMessage(
                    LocalizedStrings.Errors.unexpectedError,
                    isError: true
                )
                updateState(to: .showLogin)
                return
            }
            setUserMessage(
                LocalizedStrings.Login.loginSuccess,
                isError: false
            )
            updateStateWithDelay(to: .navigateToHeroes)
        } catch {
            handleLoginError(error)
        }
    }
}

// MARK: - State Initialization
private extension LoginViewModel {
    /// Sets the initial state based on token existence.
    func initializeState() {
        if loginUseCase.checkToken() {
            setUserMessage(
                LocalizedStrings.Login.welcomeBack,
                isError: false
            )
            updateStateWithDelay(to: .navigateToHeroes)
        } else {
            updateState(to: .showLogin)
        }
    }
}

// MARK: - User Message Management
private extension LoginViewModel {
    func clearUserMessage() {
        userMessage = nil
    }
    
    /// Updates the user message with the specified content and error state.
    func setUserMessage(_ message: String, isError: Bool) {
        userMessage = (message: message, isError: isError)
    }
}

// MARK: - State Management
private extension LoginViewModel {
    /// Updates the view state immediately.
    func updateState(to newState: State) {
        state = newState
    }
    
    /// Updates the view state after a delay.
    func updateStateWithDelay(to newState: State) {
        Task {
            try? await Task.sleep(nanoseconds: navigationDelay)
            updateState(to: newState)
        }
    }
}

// MARK: - Error Handling
extension LoginViewModel {
    /// Handles errors during the login process.
    func handleLoginError(_ error: Error) {
        let message: String
        if let authError = error as? AuthenticationError {
            switch authError {
            case .invalidCredentials:
                message = LocalizedStrings.Errors.invalidCredentials
            case .accessDenied:
                message = LocalizedStrings.Errors.accessDenied
            case .serverError(let statusCode):
                message = String(format: LocalizedStrings.Errors.serverError, statusCode)
            case .networkError:
                message = LocalizedStrings.Errors.networkError
            case .unexpectedError:
                message = LocalizedStrings.Errors.unexpectedError
            }
        } else {
            message = LocalizedStrings.Errors.unexpectedError
        }
        
        setUserMessage(message, isError: true)
        updateState(to: .showLogin)
    }
}
