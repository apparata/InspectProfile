import Foundation

public protocol SemanticNodeType: Identifiable, Hashable, Codable {
    var id: UUID { get }
    var type: String { get }
    var description: String { get }
    var hasChildren: Bool { get }
    var children: [SemanticNode]? { get }
}

extension SemanticNodeType {
    public var hasChildren: Bool {
        if let children {
            return !children.isEmpty
        } else {
            return false
        }
    }
}

public enum SemanticNode: Identifiable, Hashable, Codable {

    case pkcs7SignedData(PKCS7SignedDataNode)
    case pkcs7Data(PKCS7DataNode)
    case profilePlist(ProfilePlistNode)
    case entitlements(ProfileEntitlementsNode)
    case developerCertificates(DeveloperCertificatesNode)
    case developerCertificate(DeveloperCertificateNode)

    public var node: any SemanticNodeType {
        switch self {
        case .pkcs7SignedData(let node): return node
        case .pkcs7Data(let node): return node
        case .profilePlist(let node): return node
        case .entitlements(let node): return node
        case .developerCertificates(let node): return node
        case .developerCertificate(let node): return node
        }
    }

    public var id: UUID {
        node.id
    }

    public var type: String {
        node.type
    }

    public var description: String {
        node.description
    }

    public var children: [SemanticNode]? {
        node.children
    }

    public var hasChildren: Bool {
        node.hasChildren
    }

    public init(_ node: any SemanticNodeType) throws {
        switch node {
        case let node as PKCS7SignedDataNode: self = .pkcs7SignedData(node)
        case let node as PKCS7DataNode: self = .pkcs7Data(node)
        case let node as ProfilePlistNode: self = .profilePlist(node)
        default:
            throw SemanticsError.unknownSemanticNode
        }
    }
}
