import Foundation

public struct DERUTF8String: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let value: String
    public let description: String

    public init(tag: DERTag, value: String) {
        self.id = UUID()
        self.tag = tag
        self.type = "UTF-8 String"
        self.value = value
        if value.contains("\n") || value.contains("\r") {
            self.description = "\"\"\"\n\(value)\n\"\"\""
        } else {
            self.description = "\"\(value)\""
        }
    }
}
