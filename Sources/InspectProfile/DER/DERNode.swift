import Foundation

// MARK: - DERNode

public protocol DERNodeType: Identifiable, CustomStringConvertible, Codable, Hashable {
    var id: UUID { get }
    var tag: DERTag { get }
    var type: String { get }
}

extension DERNodeType {
    public var description: String {
        return tag.description
    }
}

// MARK: - DERPrimitive

public protocol DERPrimitive: DERNodeType {
}

// MARK: - DERConstructed

public protocol DERConstructed: DERNodeType {
    var hasChildren: Bool { get }
    var children: [DERNode] { get }
}

extension DERConstructed {
    public var hasChildren: Bool {
        !children.isEmpty
    }

    public var children: [DERNode] {
        return []
    }
}

// MARK: DERNodeTag

public enum DERNode: Identifiable, CustomStringConvertible, Codable, Hashable {

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

    init(node: any DERNodeType) {
        switch node {
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

        default:
            let tag = node.tag
            self = .unknown(DERUnknown(tag: tag))
        }
    }

    public var node: any DERNodeType {
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
        }
    }

    public var id: UUID {
        node.id
    }

    public var tag: DERTag {
        node.tag
    }

    public var type: String {
        node.type
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

    public var children: [DERNode]? {
        if let constructed = node as? (any DERConstructed) {
            return constructed.children
        } else {
            return nil
        }
    }
}
