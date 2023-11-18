import Foundation

public struct DERNull: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let range: Range<Int>
    public let description: String

    public init(tag: DERTag, range: Range<Int>) {
        self.id = UUID()
        self.tag = tag
        self.type = "Null"
        self.range = range
        self.description = "NULL"
    }
}
