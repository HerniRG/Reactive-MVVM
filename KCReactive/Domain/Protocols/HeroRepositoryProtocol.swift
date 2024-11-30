import Foundation

protocol HeroRepositoryProtocol {
    func getHeroes(filter: String) async throws -> [Hero]
}
