import Foundation

public struct DERSequence: DERConstructed {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let description: String
    public let children: [DERNode]

    public init(tag: DERTag, children: [DERNode]) {
        self.id = UUID()
        self.tag = tag
        self.type = "Sequence"
        self.description = "\(children.count) children"
        self.children = children
    }
}

extension DERSequence {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(tag)
        hasher.combine(children)
    }

    public static func == (lhs: DERSequence, rhs: DERSequence) -> Bool {
        lhs.tag == rhs.tag && lhs.children == rhs.children
    }

    enum CodingKeys: CodingKey {
        case id
        case tag
        case type
        case description
        case children
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        tag = try container.decode(DERTag.self, forKey: .tag)
        type = try container.decode(String.self, forKey: .type)
        description = try container.decode(String.self, forKey: .description)
        children = try container.decode([DERNode].self, forKey: .children)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(tag, forKey: .tag)
        try container.encode(type, forKey: .type)
        try container.encode(description, forKey: .description)
        try container.encode(children, forKey: .children)
    }
}
