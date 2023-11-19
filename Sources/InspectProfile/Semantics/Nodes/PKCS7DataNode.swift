import Foundation

public struct PKCS7DataNode: NodeType {

    public static let objectID = DERObjectID(
        "1.2.840.113549.1.7.1",
        name: "PKCS#7: Data"
    )

    public var id: UUID = UUID()

    public var type: String {
        Self.objectID.name ?? "\(self.type)"
    }

    public var description: String {
        Self.objectID.string
    }

    public var children: [Node]?

    public init(children: [Node]?) {
        self.children = children
    }
}
