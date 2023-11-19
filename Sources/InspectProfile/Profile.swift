import Foundation

public class Profile: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let url: URL?
    public let data: Data
    public let nodes: [Node]
    public let semanticNodes: [Node]

    public init(
        name: String = "Untitled",
        url: URL? = nil,
        data: Data,
        nodes: [Node] = [],
        semanticNodes: [Node] = []
    ) {
        self.id = UUID()
        self.name = name
        self.url = url
        self.data = data
        self.nodes = nodes
        self.semanticNodes = semanticNodes
    }

    public func dataForNode(_ node: Node) -> Data? {
        guard let range = node.range else {
            return nil
        }
        return data[range]
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(url)
        hasher.combine(data)
    }

    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.data == rhs.data
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case url
        case data
        case nodes
        case semanticNodes
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        data = try container.decode(Data.self, forKey: .data)
        nodes = try container.decode([Node].self, forKey: .nodes)
        semanticNodes = try container.decode([Node].self, forKey: .semanticNodes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encode(data, forKey: .data)
        try container.encode(nodes, forKey: .nodes)
        try container.encode(semanticNodes, forKey: .semanticNodes)
    }
}
