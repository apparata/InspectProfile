import Foundation

public struct DEROctetString: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let value: Data
    public let description: String

    public init(tag: DERTag, value: Data) {
        self.id = UUID()
        self.tag = tag
        self.type = "Octet String"
        self.value = value
        self.description = "`\(value.count) bytes`"
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(tag)
        hasher.combine(type)
        hasher.combine(value)
    }
}
