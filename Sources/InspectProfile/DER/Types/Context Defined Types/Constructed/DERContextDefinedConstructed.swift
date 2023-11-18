import Foundation

public struct DERContextDefinedConstructed: DERConstructed {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let range: Range<Int>
    public let description: String
    public let children: [DERNode]

    public init(tag: DERTag, children: [DERNode], range: Range<Int>) {
        self.id = UUID()
        self.tag = tag
        self.type = "Context Defined Constructed"
        self.range = range
        self.description = "Tag: `\(tag.value)` (\(children.count) children)"
        self.children = children
    }
}
