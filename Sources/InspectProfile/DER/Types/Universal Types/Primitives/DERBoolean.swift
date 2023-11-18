import Foundation

public struct DERBoolean: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let value: Bool
    public let range: Range<Int>
    public let description: String

    public init(tag: DERTag, value: Bool, range: Range<Int>) {
        self.id = UUID()
        self.tag = tag
        self.type = "Boolean"
        self.value = value
        self.range = range
        self.description = "`\(value)`"
    }
}
