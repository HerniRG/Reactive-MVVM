import Combine
import Foundation

enum State {
    case loading
    case showLogin
    case navigateToHeroes
}

@MainActor
final class LoginViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var state: State = .loading
    @Published var toastMessage: (message: String, isError: Bool)?
    
    // MARK: - Private Properties
    private var authService: AuthService
    
    // MARK: - Initializer
    init(authService: AuthService = AuthService()) {
        self.authService = authService
        checkToken()
    }
    
    // MARK: - Public Methods
    func login(user: String, password: String) async {
        // Limpiamos cualquier mensaje previo
        toastMessage = nil
        state = .loading
        
        do {
            try await authService.login(user: user, password: password)
            handleLoginSuccess()
        } catch {
            handleLoginError(error)
        }
    }
    
    // MARK: - Private Methods
    private func checkToken() {
        if let token = TokenManager.shared.loadToken(), !token.isEmpty {
            print("Token válido encontrado: \(token)")
            toastMessage = (message: "Bienvenido de nuevo", isError: false) // Mostrar toast de éxito
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // Breve espera para mostrar el toast
                state = .navigateToHeroes
            }
        } else {
            print("No se encontró un token válido")
            state = .showLogin
        }
    }
    
    private func handleLoginSuccess() {
        // Publicamos el mensaje de éxito
        toastMessage = (message: "Login exitoso", isError: false)
        // Esperamos un breve momento para mostrar el Toast antes de navegar
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
            state = .navigateToHeroes
        }
    }
    
    private func handleLoginError(_ error: Error) {
        let errorMessage: String
        if let authError = error as? AuthenticationError {
            errorMessage = authError.localizedDescription
        } else if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = "No hay conexión a internet. Por favor, verifica tu red."
            case .timedOut:
                errorMessage = "La solicitud ha tardado demasiado. Inténtalo más tarde."
            default:
                errorMessage = "Ha ocurrido un error. Intenta nuevamente."
            }
        } else {
            errorMessage = "Ha ocurrido un error desconocido."
        }
        // Publicamos el mensaje de error
        toastMessage = (message: errorMessage, isError: true)
        state = .showLogin
    }
}
