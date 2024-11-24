import Combine
import Foundation

// MARK: - Enumeración del Estado de la Vista
enum State {
    case loading
    case showLogin
    case navigateToHeroes
}

// MARK: - ViewModel del Login
@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - Publicación de Propiedades
    @Published var state: State = .loading
    @Published var userMessage: (message: String, isError: Bool)?

    // MARK: - Propiedades Privadas
    private let loginUseCase: LoginUseCaseProtocol

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
                    NSLocalizedString("UnexpectedError", comment: "Unexpected error during login"),
                    isError: true
                )
                updateState(to: .showLogin)
                return
            }
            setUserMessage(
                NSLocalizedString("LoginSuccess", comment: "Successful login message"),
                isError: false
            )
            updateStateWithDelay(to: .navigateToHeroes)
        } catch {
            handleLoginError(error)
        }
    }

    // MARK: - Métodos Privados

    /// Inicializa el estado de la vista según la existencia de un token.
    private func initializeState() {
        if loginUseCase.checkToken() {
            setUserMessage(
                NSLocalizedString("WelcomeBack", comment: "Welcome back message for returning user"),
                isError: false
            )
            updateStateWithDelay(to: .navigateToHeroes)
        } else {
            updateState(to: .showLogin)
        }
    }

    /// Limpia el mensaje del usuario.
    private func clearUserMessage() {
        userMessage = nil
    }

    /// Actualiza el estado de la vista.
    private func updateState(to newState: State) {
        state = newState
    }

    /// Actualiza el estado de la vista con un breve retraso.
    private func updateStateWithDelay(to newState: State) {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
            updateState(to: newState)
        }
    }

    /// Establece un mensaje para el usuario.
    private func setUserMessage(_ message: String, isError: Bool) {
        userMessage = (message: message, isError: isError)
    }

    /// Maneja los errores ocurridos durante el login.
    private func handleLoginError(_ error: Error) {
        setUserMessage(error.localizedDescription, isError: true)
        updateState(to: .showLogin)
    }
}
