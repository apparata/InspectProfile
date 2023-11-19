import Foundation

public struct DERProfileNode: NodeType {

    public var id: UUID = UUID()

    public var type: String = "DER Profile"

    public var description: String {
        "\(String(data.count)) bytes"
    }

    public var children: [Node]? = nil

    public let data: Data

    public init(data: Data) {
        self.data = data
    }
}
