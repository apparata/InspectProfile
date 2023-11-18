import Foundation

public struct DEROctetString: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let value: Data
    public let range: Range<Int>
    public let description: String

    public init(tag: DERTag, value: Data, range: Range<Int>) {
        self.id = UUID()
        self.tag = tag
        self.type = "Octet String"
        self.value = value
        self.range = range
        self.description = "`\(value.count) bytes`"
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(tag)
        hasher.combine(type)
        hasher.combine(value)
    }
}
