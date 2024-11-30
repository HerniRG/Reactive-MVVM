import Foundation

protocol HeroUseCaseProtocol {
    var heroRepo: HeroRepositoryProtocol { get }
    func getHeroes(filter: String) async throws -> [Hero]
    func logout()
}
