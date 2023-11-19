import Foundation

public struct DeveloperCertificateNode: NodeType {

    public var id: UUID = UUID()

    public var type: String = "Developer Certificate"

    public var description: String {
        certificate.name
    }

    public var children: [Node]?

    public let certificate: DeveloperCertificate

    public init(data: Data) {
        self.children = nil
        self.certificate = DeveloperCertificate(data: data)
    }
}
