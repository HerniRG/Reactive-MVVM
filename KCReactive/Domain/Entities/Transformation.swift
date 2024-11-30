import Foundation

struct Transformation: Codable, Hashable {
    var id: UUID
    var name: String
    var description: String
    var photo: String
}

struct TransformationFilter: Codable {
    var id: String 
}
