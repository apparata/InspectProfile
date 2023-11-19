import Foundation

// MARK: - Node

public protocol NodeType: Identifiable, Hashable, Codable, CustomStringConvertible {
    var id: UUID { get }
    var type: String { get }
    var description: String { get }
    var hasChildren: Bool { get }
    var children: [Node]? { get }
}

extension NodeType {
    public var hasChildren: Bool {
        if let children {
            return !children.isEmpty
        } else {
            return false
        }
    }
}

// MARK: - DERNode

public protocol DERNodeType: NodeType {
    var tag: DERTag { get }
    var range: Range<Int> { get }
}

extension DERNodeType {
    public var description: String {
        return tag.description
    }
}

// MARK: - DERPrimitive

public protocol DERPrimitive: DERNodeType {
}

extension DERPrimitive {
    public var children: [Node]? {
        return nil
    }
}

// MARK: - DERConstructed

public protocol DERConstructed: DERNodeType, CastableElement {
}

extension DERConstructed {

    public func node<T: DERNodeType>(at index: Int, as type: T.Type) -> T? {
        guard let child = children?.node(at: index) else {
            return nil
        }
        return child.node as? T
    }

    public subscript<T: DERNodeType>(_ index: Int, as type: T.Type) -> T? {
        node(at: index, as: type)
    }
}

// MARK: - NodeCaster

struct NodeCaster {

    var cast: (Node) -> (any NodeType)?

    init<T: NodeType>(_ type: T.Type) {
        cast = { value in
            value.node as? T
        }
    }
}

// MARK: - NodeAt

public struct NodeAt {
    let index: Int
    let caster: NodeCaster
    let validate: (any NodeType) -> Bool

    public init<T: NodeType>(_ index: Int, as type: T.Type, validate: ((T) -> Bool)? = nil) {
        self.index = index
        self.caster = NodeCaster(type)
        self.validate = { nodeType in
            guard let castType = nodeType as? T else {
                return false
            }
            return validate?(castType) ?? true
        }
    }
}

// MARK: - [Node]

extension [Node]: CastableElement {

    var second: Node? { node(at: 1) }
    var third: Node? { node(at: 2) }
    var fourth: Node? { node(at: 3) }
    var fifth: Node? { node(at: 4) }
    var sixth: Node? { node(at: 5) }
    var seventh: Node? { node(at: 6) }
    var eighth: Node? { node(at: 7) }
    var ninth: Node? { node(at: 8) }
    var tenth: Node? { node(at: 9) }

    func node(at index: Int) -> Node? {
        guard count > index else {
            return nil
        }
        return self[index]
    }

    public func node<T: DERNodeType>(at index: Int, as type: T.Type) -> T? {
        guard let child = node(at: index) else {
            return nil
        }
        return child.node as? T
    }

    public subscript<T: DERNodeType>(_ index: Int, as type: T.Type) -> T? {
        node(at: index, as: type)
    }

    public func extract<T: NodeType>(at path: [NodeAt], as resultType: T.Type) -> T? {
        var path = path
        var array: [Node] = self
        while !path.isEmpty {
            let level = path.removeFirst()
            guard let levelNode = array.node(at: level.index) else {
                return nil
            }
            guard let nodeType = level.caster.cast(levelNode) else {
                return nil
            }
            if path.isEmpty {
                guard let result = nodeType as? T else {
                    return nil
                }
                guard level.validate(result) else {
                    return nil
                }
                return result
            }
            guard let children = nodeType.children else {
                return nil
            }
            array = children
        }
        return nil
    }
}

// MARK: - CastableElement

public protocol CastableElement {
    func node<T: DERNodeType>(at index: Int, as type: T.Type) -> T?
    subscript<T: DERNodeType>(_ index: Int, as type: T.Type) -> T? { get }
}

// MARK: Node

public enum Node: Identifiable, CustomStringConvertible, Codable, Hashable {

    // MARK: - DER Nodes

    // Context Defined
    case contextDefinedConstructed(DERContextDefinedConstructed)
    case contextDefinedPrimitive(DERContextDefinedPrimitive)

    // Constructed
    case sequence(DERSequence)
    case set(DERSet)

    // Primitives
    case bitString(DERBitString)
    case boolean(DERBoolean)
    case integer(DERInteger)
    case null(DERNull)
    case objectIdentifier(DERObjectIdentifier)
    case octetString(DEROctetString)
    case printableString(DERPrintableString)
    case utcTime(DERUTCTime)
    case utf8String(DERUTF8String)

    case unknown(DERUnknown)

    // MARK: - Semantic Nodes

    case pkcs7SignedData(PKCS7SignedDataNode)
    case pkcs7Data(PKCS7DataNode)
    case profilePlist(ProfilePlistNode)
    case entitlements(ProfileEntitlementsNode)
    case developerCertificates(DeveloperCertificatesNode)
    case developerCertificate(DeveloperCertificateNode)

    // MARK: - Init

    init(node: any NodeType) {
        switch node {

        // --------------------------------------------------------------------
        // MARK: DER Nodes
        // --------------------------------------------------------------------

        case let node as DERContextDefinedConstructed: self = .contextDefinedConstructed(node)
        case let node as DERContextDefinedPrimitive: self = .contextDefinedPrimitive(node)

        case let node as DERSequence: self = .sequence(node)
        case let node as DERSet: self = .set(node)

        case let node as DERBitString: self = .bitString(node)
        case let node as DERBoolean: self = .boolean(node)
        case let node as DERInteger: self = .integer(node)
        case let node as DERNull: self = .null(node)
        case let node as DERObjectIdentifier: self = .objectIdentifier(node)
        case let node as DEROctetString: self = .octetString(node)
        case let node as DERPrintableString: self = .printableString(node)
        case let node as DERUTCTime: self = .utcTime(node)
        case let node as DERUTF8String: self = .utf8String(node)

        // --------------------------------------------------------------------
        // MARK: Semantic Nodes
        // --------------------------------------------------------------------

        case let node as PKCS7SignedDataNode: self = .pkcs7SignedData(node)
        case let node as PKCS7DataNode: self = .pkcs7Data(node)
        case let node as ProfilePlistNode: self = .profilePlist(node)
        case let node as ProfileEntitlementsNode: self = .entitlements(node)
        case let node as DeveloperCertificatesNode: self = .developerCertificates(node)
        case let node as DeveloperCertificateNode: self = .developerCertificate(node)

        // --------------------------------------------------------------------
        // MARK: Unknown node
        // --------------------------------------------------------------------

        default:
            self = .unknown(DERUnknown(tag: DERTag(0), range: 0..<1))
        }
    }

    public var node: any NodeType {
        switch self {
        case .contextDefinedConstructed(let node): return node
        case .contextDefinedPrimitive(let node): return node

        case .sequence(let node): return node
        case .set(let node): return node

        case .bitString(let node): return node
        case .boolean(let node): return node
        case .integer(let node): return node
        case .null(let node): return node
        case .objectIdentifier(let node): return node
        case .octetString(let node): return node
        case .printableString(let node): return node
        case .utcTime(let node): return node
        case .utf8String(let node): return node

        case .unknown(let node): return node

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

    public var tag: DERTag? {
        if let derNode = node as? (any DERNodeType) {
            return derNode.tag
        }
        return nil
    }

    public var type: String {
        node.type
    }

    public var range: Range<Int>? {
        if let derNode = node as? (any DERNodeType) {
            return derNode.range
        }
        return nil
    }

    public var description: String {
        node.description
    }

    public var hasChildren: Bool {
        if let children {
            return !children.isEmpty
        } else {
            return false
        }
    }

    public var children: [Node]? {
        node.children
    }

    public func isObject(_ objectID: DERObjectID) -> Bool {
        guard case .sequence(let sequence) = self else {
            return false
        }
        return sequence.isObject(objectID)
    }

    public subscript<T: DERNodeType>(_ index: Int, as type: T.Type) -> T? {
        guard let children else {
            return nil
        }
        guard let child = children.node(at: index) else {
            return nil
        }
        guard let node = child.node as? T else {
            return nil
        }
        return node
    }
}
