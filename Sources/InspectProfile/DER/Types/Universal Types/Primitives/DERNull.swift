import Foundation

public struct DERNull: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let description: String

    public init(tag: DERTag) {
        self.id = UUID()
        self.tag = tag
        self.type = "Null"
        self.description = "NULL"
    }
}
