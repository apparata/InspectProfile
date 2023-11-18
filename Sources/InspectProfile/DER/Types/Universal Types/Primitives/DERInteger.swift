import Foundation

public struct DERInteger: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let value: Int
    public let range: Range<Int>
    public let description: String

    public init(tag: DERTag, value: Int, range: Range<Int>) {
        self.id = UUID()
        self.tag = tag
        self.type = "Integer"
        self.value = value
        self.range = range
        self.description = "`\(value)`"
    }
}
