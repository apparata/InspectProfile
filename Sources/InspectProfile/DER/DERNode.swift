import Foundation

// MARK: - DERNode

public protocol DERNodeType: Identifiable, CustomStringConvertible, Codable, Hashable {
    var id: UUID { get }
    var tag: DERTag { get }
    var type: String { get }
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

    public func child<T: DERNodeType>(at index: Int, as type: T.Type) -> T? {
        guard let child = children.node(at: index) else {
            return nil
        }
        return child.node as? T
    }

    public subscript<T: DERNodeType>(_ index: Int, as type: T.Type) -> T? {
        child(at: index, as: type)
    }
}

// MARK: - [DERNode]

extension [DERNode] {
    var second: DERNode? { node(at: 2) }
    var third: DERNode? { node(at: 3) }
    var fourth: DERNode? { node(at: 4) }
    var fifth: DERNode? { node(at: 5) }
    var sixth: DERNode? { node(at: 6) }

    func node(at index: Int) -> DERNode? {
        guard count > index else {
            return nil
        }
        return self[index]
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
            self = .unknown(DERUnknown(tag: tag, range: node.range))
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

    public var range: Range<Int> {
        node.range
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
