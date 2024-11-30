import Foundation

protocol TransformationRepositoryProtocol {
    func getTransformations(id: String) async throws -> [Transformation]
}
