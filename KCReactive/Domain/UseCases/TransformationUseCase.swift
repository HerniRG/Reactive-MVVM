import Foundation

/// Use case for managing hero transformations.
final class TransformationUseCase: TransformationUseCaseProtocol {

    var transformationRepo: TransformationRepositoryProtocol

    /// Initializes the use case with a repository.
    init(transformationRepo: TransformationRepositoryProtocol = DefaultTransformationRepository(transformationService: TransformationService())) {
        self.transformationRepo = transformationRepo
    }

    /// Fetches and processes transformations for the given hero.
    /// - Parameter id: The hero's identifier.
    /// - Returns: A list of processed transformations.
    func getTransformations(id: String) async throws -> [Transformation] {
        do {
            let transformations = try await transformationRepo.getTransformations(id: id)
            return processTransformations(transformations)
        } catch {
            throw error
        }
    }

    /// Processes transformations by removing duplicates and sorting them.
    /// - Parameter transformations: The list of transformations to process.
    /// - Returns: A sorted list of unique transformations.
    private func processTransformations(_ transformations: [Transformation]) -> [Transformation] {
        let uniqueTransformations = Array(
            Dictionary(grouping: transformations, by: { $0.name })
                .compactMapValues { $0.first }
                .values
        )
        return uniqueTransformations.sorted { lhs, rhs in
            lhs.name.compare(rhs.name, options: .numeric) == .orderedAscending
        }
    }
}

/// A fake use case for testing, providing predefined transformations.
final class TransformationUseCaseFake: TransformationUseCaseProtocol {
    
    var transformationRepo: any TransformationRepositoryProtocol

    /// Predefined transformations for testing.
    private let fakeTransformations: [Transformation] = [
        Transformation(
            id: UUID(),
            name: "Super Saiyan",
            description: "First Saiyan transformation.",
            photo: "https://example.com/super_saiyan.jpg"
        ),
        Transformation(
            id: UUID(),
            name: "Ultra Instinct",
            description: "The ultimate transformation.",
            photo: "https://example.com/ultra_instinct.jpg"
        )
    ]

    /// Initializes the fake use case with a repository.
    init(transformationRepo: TransformationRepositoryProtocol = DefaultTransformationRepository(transformationService: TransformationService())) {
        self.transformationRepo = transformationRepo
    }

    /// Returns predefined transformations for testing.
    func getTransformations(id: String) async throws -> [Transformation] {
        return fakeTransformations
    }
}
