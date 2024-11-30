import Foundation

struct Hero: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var description: String
    var photo: String
    var favorite: Bool?
}

struct HeroFilter: Codable {
    var name: String
}
