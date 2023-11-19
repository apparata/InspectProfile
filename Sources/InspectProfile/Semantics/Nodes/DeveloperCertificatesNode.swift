import Foundation

public struct DeveloperCertificatesNode: SemanticNodeType {

    public var id: UUID = UUID()

    public var type: String = "Developer Certificates"

    public var description: String {
        String(children?.count ?? 0)
    }

    public var children: [SemanticNode]?

    public init(children: [SemanticNode]?) {
        self.children = children
    }
}
