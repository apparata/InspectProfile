import Foundation

public enum DERTagClass: String, Codable, Hashable, CustomStringConvertible {
    case universal = "Universal"
    case application = "Application"
    case contextDefined = "Context Defined"
    case `private` = "Private"

    public var description: String {
        rawValue
    }
}

public struct DERTag: Codable, Hashable, Equatable, CustomStringConvertible {

    public let value: Int

    /// True if tag has child tags, like FORM or LIST in the IFF format.
    public let isConstructed: Bool

    public let tagClass: DERTagClass

    public var description: String {
        if isConstructed {
            return "Tag: \(value) - Constructed, \(tagClass)"
        } else {
            return "Tag: \(value) - Primitive, \(tagClass)"
        }
    }

    public init(_ value: UInt8) {
        self.value = Int(value & 0x1F)
        isConstructed = value & 0x20 > 0
        switch (value & 0x80 > 1, value & 0x40 > 1) {
        case (false, false): tagClass = .universal
        case (false, true): tagClass = .application
        case (true, false): tagClass = .contextDefined
        case (true, true): tagClass = .private
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }

    public static let implicit = Self(0x00)
    public static let boolean = Self(0x01)
    public static let integer = Self(0x02)
    public static let bitString = Self(0x03)
    public static let octetString = Self(0x04)
    public static let null = Self(0x05)
    public static let objectIdentifier = Self(0x06)
    public static let utf8String = Self(0x0c) // 12
    public static let sequence = Self(0x10) // 16
    public static let set = Self(0x11) // 17
    public static let printableString = Self(0x13) // 19
    public static let t61String = Self(0x14) // 20
    public static let ia5String = Self(0x16) // 22
    public static let utcTime = Self(0x17) // 23
    public static let generalizedTime = Self(0x18) // 24
}

