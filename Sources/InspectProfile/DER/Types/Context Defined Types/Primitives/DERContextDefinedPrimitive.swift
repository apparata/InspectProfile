import Foundation

public struct DERContextDefinedPrimitive: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let description: String
    public let primitive: Data

    public init(tag: DERTag, primitive: Data) {
        self.id = UUID()
        self.tag = tag
        self.type = "Context Defined Primitive"
        self.description = "Tag: `\(tag.value)`"
        self.primitive = primitive
    }
}
