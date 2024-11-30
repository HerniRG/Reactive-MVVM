import Foundation

protocol LoginRepositoryProtocol {
    func login(user: String, password: String) async throws -> String
}
