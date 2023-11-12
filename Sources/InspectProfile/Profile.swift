import Foundation

public struct Profile: Identifiable {
    public let id: UUID
    public let name: String
    public let nodes: [DERNode]

    public init(name: String = "Untitled", nodes: [DERNode] = []) {
        self.id = UUID()
        self.name = name
        self.nodes = nodes
    }
}

extension Profile: Codable, Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(nodes)
    }

    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.nodes == rhs.nodes
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case nodes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        nodes = try container.decode([DERNode].self, forKey: .nodes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(nodes, forKey: .nodes)
    }
}
