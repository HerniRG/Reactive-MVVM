import Foundation

/// Use case for handling user login and token management.
final class LoginUseCase: LoginUseCaseProtocol {
    
    var repo: LoginRepositoryProtocol
    
    /// Initializes the use case with a login repository.
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: NetworkLogin())) {
        self.repo = repo
    }

    /// Logs in the user and saves the token if successful.
    /// - Parameters:
    ///   - user: The username.
    ///   - password: The user's password.
    /// - Returns: `true` if the login was successful.
    func loginApp(user: String, password: String) async throws -> Bool {
        let token = try await repo.login(user: user, password: password)
        TokenManager.shared.saveToken(token)
        return true
    }

    /// Checks if a valid token exists.
    /// - Returns: `true` if a valid token is stored.
    func checkToken() -> Bool {
        if let token = TokenManager.shared.loadToken(), !token.isEmpty {
            return true
        }
        return false
    }
}

/// A fake implementation of `LoginUseCaseProtocol` for testing purposes.
final class LoginUseCaseFake: LoginUseCaseProtocol {
    
    var repo: LoginRepositoryProtocol
    
    /// Initializes the fake use case with a login repository.
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: NetworkLogin())) {
        self.repo = repo
    }

    /// Simulates a successful login by saving a fake token.
    /// - Parameters:
    ///   - user: The username.
    ///   - password: The user's password.
    /// - Returns: Always returns `true`.
    func loginApp(user: String, password: String) async throws -> Bool {
        TokenManager.shared.saveToken("LoginFakeSuccess")
        return true
    }

    /// Simulates the existence of a valid token.
    /// - Returns: Always returns `true`.
    func checkToken() -> Bool {
        return true
    }
}
