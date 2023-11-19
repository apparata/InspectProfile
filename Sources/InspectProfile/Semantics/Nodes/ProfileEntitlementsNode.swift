import Foundation

public struct ProfileEntitlementsNode: NodeType {

    public var id: UUID = UUID()

    public var type: String = "Entitlements"

    public var description: String {
        String(entitlements.count)
    }

    public var children: [Node]? = nil

    public let entitlements: [String: String]

    public init(entitlements: [String: Any]) {
        self.entitlements = entitlements.mapValues { anyValue in
            switch anyValue {
            case let value as Bool: String(value)
            case let value as Int: String(value)
            case let value as Double: String(value)
            case let value as String: value
            case let value as Date: value.formatted()
            case let value as [String]: value.joined(separator: ", ")
            default: "\(anyValue)"
            }
        }
    }
}
