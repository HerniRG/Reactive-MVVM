import Foundation

protocol TransformationUseCaseProtocol {
    var transformationRepo: TransformationRepositoryProtocol { get }
    func getTransformations(id: String) async throws -> [Transformation]
}
