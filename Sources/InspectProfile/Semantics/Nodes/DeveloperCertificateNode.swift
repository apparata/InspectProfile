import Foundation

public struct DeveloperCertificateNode: NodeType {

    public var id: UUID = UUID()

    public var type: String = "Developer Certificates"

    public var description: String {
        ""
    }

    public var children: [Node]?

    public let certificate: DeveloperCertificate

    public init(data: Data) {
        self.children = nil
        self.certificate = DeveloperCertificate(data: data)
    }
}
