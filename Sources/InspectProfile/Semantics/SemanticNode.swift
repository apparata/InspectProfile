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

    case signedData(SignedDataNode)

    public var node: any SemanticNodeType {
        switch self {
        case .signedData(let node): return node
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
        case let node as SignedDataNode: self = .signedData(node)
        default:
            throw SemanticsError.unknownSemanticNode
        }
    }
}
