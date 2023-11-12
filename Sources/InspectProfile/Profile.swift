import Foundation

public class Profile: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let url: URL?
    public let nodes: [DERNode]

    public init(name: String = "Untitled", url: URL? = nil, nodes: [DERNode] = []) {
        self.id = UUID()
        self.name = name
        self.url = url
        self.nodes = nodes
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(url)
        hasher.combine(nodes)
    }

    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.nodes == rhs.nodes
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case url
        case nodes
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        nodes = try container.decode([DERNode].self, forKey: .nodes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encode(nodes, forKey: .nodes)
    }
}
