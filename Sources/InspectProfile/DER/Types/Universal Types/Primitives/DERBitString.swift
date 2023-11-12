import Foundation

public struct DERBitString: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let bitCount: Int
    public let value: Data
    public let description: String

    public init(tag: DERTag, bitCount: Int, value: Data) {
        self.id = UUID()
        self.tag = tag
        self.type = "Bit String"
        self.bitCount = bitCount
        self.value = value
        self.description = "\(bitCount) bits"
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(tag)
        hasher.combine(type)
        hasher.combine(bitCount)
        hasher.combine(value)
    }
}
