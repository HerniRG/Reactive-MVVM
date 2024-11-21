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
    @Published var toastMessage: (message: String, isError: Bool)?
    
    // MARK: - Propiedades Privadas
    private let loginUseCase: LoginUseCaseProtocol
    
    // MARK: - Inicializador
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
        checkToken()
    }
    
    // MARK: - Métodos Públicos
    /// Realiza el proceso de login con el usuario y contraseña proporcionados.
    /// - Parameters:
    ///   - user: Nombre de usuario.
    ///   - password: Contraseña del usuario.
    func login(user: String, password: String) async {
        // Limpiar cualquier mensaje previo
        toastMessage = nil
        // Actualizar el estado a cargando
        state = .loading
        
        do {
            // Intentar realizar el login mediante el caso de uso
            let success = try await loginUseCase.loginApp(user: user, password: password)
            
            if success {
                handleLoginSuccess()
            } else {
                // Manejo de caso inesperado donde success es false
                handleLoginError(AuthenticationError.invalidCredentials)
            }
        } catch {
            // Manejar el error ocurrido durante el login
            handleLoginError(error)
        }
    }
    
    // MARK: - Métodos Privados
    /// Verifica si existe un token válido almacenado y actualiza el estado de la vista en consecuencia.
    private func checkToken() {
        if let token = TokenManager.shared.loadToken(), !token.isEmpty {
            print("Token válido encontrado: \(token)")
            // Mostrar mensaje de bienvenida
            toastMessage = (message: "Bienvenido de nuevo", isError: false)
            // Navegar a la pantalla de héroes después de una breve espera
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
                state = .navigateToHeroes
            }
        } else {
            print("No se encontró un token válido")
            // Mostrar la interfaz de login
            state = .showLogin
        }
    }
    
    /// Maneja el éxito del login actualizando el estado y mostrando un mensaje.
    private func handleLoginSuccess() {
        // Publicar el mensaje de éxito
        toastMessage = (message: "Login exitoso", isError: false)
        // Navegar a la pantalla de héroes después de una breve espera
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
            state = .navigateToHeroes
        }
    }
    
    /// Maneja los errores ocurridos durante el login y muestra mensajes adecuados.
    /// - Parameter error: Error ocurrido durante el login.
    private func handleLoginError(_ error: Error) {
        let errorMessage: String
        
        // Determinar el mensaje de error según el tipo de error
        if let authError = error as? AuthenticationError {
            errorMessage = authError.localizedDescription
        } else if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = "No hay conexión a internet. Por favor, verifica tu red."
            case .timedOut:
                errorMessage = "La solicitud ha tardado demasiado. Inténtalo más tarde."
            default:
                errorMessage = "Ha ocurrido un error de red. Intenta nuevamente."
            }
        } else {
            errorMessage = "Ha ocurrido un error desconocido."
        }
        
        // Publicar el mensaje de error
        toastMessage = (message: errorMessage, isError: true)
        // Volver a mostrar la interfaz de login
        state = .showLogin
    }
}
