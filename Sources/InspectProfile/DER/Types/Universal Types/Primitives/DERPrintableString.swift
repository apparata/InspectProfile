import Foundation

public struct DERPrintableString: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let value: String
    public let range: Range<Int>
    public let description: String

    public init(tag: DERTag, value: String, range: Range<Int>) {
        self.id = UUID()
        self.tag = tag
        self.type = "Printable String"
        self.value = value
        self.range = range
        if value.contains("\n") || value.contains("\r") {
            self.description = "\"\"\"\n\(value)\n\"\"\""
        } else {
            self.description = "\"\(value)\""
        }
    }
}
