import Foundation

public struct DeveloperCertificatesNode: NodeType {

    public var id: UUID = UUID()

    public var type: String = "Developer Certificates"

    public var description: String {
        String(children?.count ?? 0)
    }

    public var children: [Node]?

    public init(children: [Node]?) {
        self.children = children
    }
}
