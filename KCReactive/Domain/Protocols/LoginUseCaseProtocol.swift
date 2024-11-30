import Foundation

protocol LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol { get }
    func loginApp(user: String, password: String) async throws -> Bool
    func checkToken() -> Bool
}
