import Foundation

public struct DERUTCTime: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let value: String
    public let range: Range<Int>
    public let description: String

    public init(tag: DERTag, value: String, range: Range<Int>) {
        self.id = UUID()
        self.tag = tag
        self.type = "UTC Time"
        self.value = value
        self.range = range
        self.description = "`\(value)`"
    }
}
