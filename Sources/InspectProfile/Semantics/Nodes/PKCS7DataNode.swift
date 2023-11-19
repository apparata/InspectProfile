import Foundation

public struct PKCS7DataNode: NodeType {

    public static let objectID: DERObjectID = .PKCS7.data

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
