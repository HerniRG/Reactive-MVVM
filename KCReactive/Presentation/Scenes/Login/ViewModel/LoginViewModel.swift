import Combine
import Foundation

// MARK: - Enumeración del Estado de la Vista
enum State {
    case loading
    case showLogin
    case navigateToHeroes
}

// MARK: - ViewModel del Login
final class LoginViewModel: ObservableObject {
    
    // MARK: - Publicación de Propiedades
    @Published var state: State = .loading
    @Published var userMessage: (message: String, isError: Bool)?
    
    // MARK: - Propiedades Privadas
    private let loginUseCase: LoginUseCaseProtocol
    private let navigationDelay: UInt64 = 1_000_000_000
    
    // MARK: - Inicializador
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
        initializeState()
    }
    
    // MARK: - Métodos Públicos
    
    /// Método público para usar la inicialización de estado en tests (auto-login)
    func triggerAutoLogin() {
        initializeState()
    }
    
    /// Realiza el login del usuario.
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

// MARK: - Inicialización del Estado
private extension LoginViewModel {
    /// Inicializa el estado de la vista según la existencia de un token.
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

// MARK: - Gestión de Mensajes de Usuario
private extension LoginViewModel {
    /// Limpia el mensaje del usuario.
    func clearUserMessage() {
        userMessage = nil
    }
    
    /// Establece un mensaje para el usuario.
    func setUserMessage(_ message: String, isError: Bool) {
        userMessage = (message: message, isError: isError)
    }
}

// MARK: - Actualización del Estado
private extension LoginViewModel {
    /// Actualiza el estado de la vista.
    func updateState(to newState: State) {
        state = newState
    }
    
    /// Actualiza el estado de la vista con un breve retraso.
    func updateStateWithDelay(to newState: State) {
        Task {
            try? await Task.sleep(nanoseconds: navigationDelay)
            updateState(to: newState)
        }
    }
}

// MARK: - Gestión de Errores
extension LoginViewModel {
    /// Maneja los errores ocurridos durante el login.
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
