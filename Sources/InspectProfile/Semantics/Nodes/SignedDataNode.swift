import Foundation

public struct SignedDataNode: SemanticNodeType {
    
    public static let objectID = DERObjectID(
        "1.2.840.113549.1.7.2",
        name: "PKCS#7: Signed Data"
    )

    public static let objectName = "PKCS#7: Signed Data"

    public var id: UUID = UUID()

    public var type: String = "SignedDataNode"

    public let description: String

    public var children: [SemanticNode]?

    public init(objectID: DERObjectID, children: [SemanticNode]?) {
        self.description = objectID.name ?? type
        self.children = children
    }
}
