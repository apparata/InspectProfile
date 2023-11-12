import Foundation

public struct DERUTCTime: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let value: String
    public let description: String

    public init(tag: DERTag, value: String) {
        self.id = UUID()
        self.tag = tag
        self.type = "UTC Time"
        self.value = value
        self.description = "`\(value)`"
    }
}
