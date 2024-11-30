import Combine
import Foundation

final class DetailsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var transformations: [Transformation]? = nil
    @Published var isFavorite: Bool

    // MARK: - Public Properties
    let hero: Hero

    // MARK: - Private Properties
    private let transformationUseCase: TransformationUseCaseProtocol

    // MARK: - Initializer
    /// Initializes the ViewModel with a hero and optional transformation use case.
    init(
        hero: Hero,
        transformationUseCase: TransformationUseCaseProtocol = TransformationUseCase()
    ) {
        self.hero = hero
        self.transformationUseCase = transformationUseCase
        self.isFavorite = hero.favorite ?? false // Set initial favorite state
        
        Task {
            await loadTransformations()
        }
    }

    // MARK: - Public Methods
    /// Toggles the favorite state locally (visual-only, not persisted).
    func toggleFavorite() {
        isFavorite.toggle()
    }

    /// Loads the hero's transformations asynchronously.
    func loadTransformations() async {
        do {
            let fetchedTransformations = try await transformationUseCase.getTransformations(id: hero.id.uuidString)
            self.transformations = fetchedTransformations.isEmpty ? nil : fetchedTransformations
        } catch {
            self.transformations = nil
        }
    }
}
