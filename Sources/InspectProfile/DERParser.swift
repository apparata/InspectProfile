import Foundation
import BinaryDataKit

// https://letsencrypt.org/sv/docs/a-warm-welcome-to-asn1-and-der/
// https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-sequence

// MARK: - DERError

public enum DERError: Error {
    case notImplemented
    case failedToParseBase128
    case failedToParseBoolean
}

// MARK: - DERTag

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

// MARK: - DERObjectIdentifier

public struct DERObjectID: Codable, Hashable, Equatable, CustomStringConvertible {

    public var name: String? {
        Self.knownIDs[string]
    }
    
    public let string: String

    public var description: String {
        if let name {
            return name
        } else {
            return string
        }
    }
        
    public init(_ values: Int...) {
        self.string = values.map { String($0) }.joined(separator: ".")

    }

    public init(_ values: [Int]) {
        self.string = values.map { String($0) }.joined(separator: ".")
    }
    
    public init(_ string: String) {
        self.string = string
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.string == rhs.string
    }
    
    private static let knownIDs: [String: String] = [
        "0.9.2342.19200300.100.1.1": "\"uid\" LDAP attribute type: User shortname or userid",
        "1.2.840.113549.1.1.1": "PKCS#1: RSA Encryption",
        "1.2.840.113549.1.1.5": "PKCS#1: SHA-1 with RSA Signature",
        "1.2.840.113549.1.1.11": "PKCS#1: SHA-256 with RSA Encryption",
        "1.2.840.113549.1.7.1": "PKCS#7: Data",
        "1.2.840.113549.1.7.2": "PKCS#7: Signed Data",
        "1.2.840.113549.1.9.3": "PKCS#9: Content Type",
        "1.2.840.113549.1.9.4": "PKCS#9: Message Digest",
        "1.2.840.113549.1.9.5": "PKCS#9: Signing Time",
        "1.2.840.113549.1.9.15": "PKCS#9: S/MIME Capabilities",
        "1.2.840.113549.1.9.52": "PKCS#9: CMS Algorithm Protection",
        "1.2.840.113549.3.2": "Rivest Cipher (RC2)-compatible (56 bit) or RC2-compatible in Cipher Block Chaining (CBC)",
        "1.2.840.113549.3.7": "Triple Data Encryption Standard (DES) algorithm coupled with a cipher-block chaining mode of operation",
        "1.2.840.113635.100.6.58": "Apple Certificate Extension: 58",
        "1.2.840.113635.100.6.1.2": "Apple Certificate Extension: iPhone Software Development Signing",
        "1.2.840.113635.100.6.1.12": "Apple Certificate Extension: Mac Application Software Development Signing",
        "1.2.840.113635.100.6.2.18": "Apple Certificate Extension: devid_kernel",
        "1.3.6.1.5.5.7.1.1": "Public-Key Infrastructure X.509 (PKIX): Certificate Authority Information Access",
        "1.3.6.1.5.5.7.48.1": "Access method: Location of On-line Certificate Status Protocol responder",
        "1.3.6.1.5.5.7.48.2": "Access method used in a public key certificate when the additional information lists certificates that were issued to the Certificate Authority (CA) that issued the certificate containing this extension",
        "1.3.14.3.2.7": "56-bit Data Encryption Standard (DES) in Cipher Block Chaining (CBC)",
        "1.3.14.3.2.26": "Secure Hash Algorithm, SHA-1",
        "2.5.4.3": "Attribute Type: Common Name",
        "2.5.4.6": "Attribute Type: Country Name",
        "2.5.4.10": "Attribute Type: Organization Name",
        "2.5.4.11": "Attribute Type: Organization Unit Name",
        "2.5.29.14": "Certificate Extension: Subject Key Identifier",
        "2.5.29.15": "Certificate Extension: Key Usage",
        "2.5.29.19": "Certificate Extension: Basic Constraints",
        "2.5.29.31": "Certificate Extension: Certificate Revocation List Distribution Points",
        "2.5.29.32": "Certificate Extension: Certificate Policies",
        "2.5.29.35": "Certificate Extension: Authority key identifier",
        "2.5.29.37": "Certificate Extension: Extended Key Usage",
    ]
}

// MARK: - DERParser

public class DERParser {
    
    public let data: Data

    private let scanner: DataScanner
    
    private var level: Int = -1
    
    private var indent: String {
        return String(repeating: "  ", count: level)
    }
    
    public init(data: Data) {
        self.data = data
        self.scanner = DataScanner(data: data, endianness: .big)
    }
    
    // MARK: Parse
    
    public func parse() throws -> [DERNode] {
        print("Parsing...")
        var nodes: [DERNode] = []
        while scanner.position < data.count {
            let node = try parseType()
            nodes.append(node)
        }
        print("Parsed to end of file.")
        return nodes
    }
    
    // MARK: Parse Type
    
    private func parseType() throws -> DERNode {

        let tag = try parseTag()
        let length = try parseLength()
        
        return switch tag.tagClass {
        case .universal:
            try parseUniversalType(tag: tag, length: length)
        case .application:
            throw DERError.notImplemented
        case .contextDefined:
            try parseContextDefinedType(tag: tag, length: length)
        case .private:
            throw DERError.notImplemented
        }
    }
    
    // MARK: Parse Universal Type
    
    private func parseUniversalType(tag: DERTag, length: Int) throws -> DERNode {
        level += 1
        defer { level -= 1}
        
        switch tag {
            //case .implicit:
        case .boolean:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-boolean
            let value = try parseBoolean(length: length)
            print("\(indent)- BOOLEAN (\(value))")
            return .boolean(DERBoolean(tag: tag, value: value))
        case .integer:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-integer
            let value = try parseInteger(length: length)
            print("\(indent)- INTEGER (value: \(value))")
            return .integer(DERInteger(tag: tag, value: value))
        case .bitString:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-bit-string
            let (bitCount, data) = try parseBitString(length: length)
            _ = data
            print("\(indent)- BIT STRING (\(bitCount) bits)")
            return .bitString(DERBitString(tag: tag, bitCount: bitCount, value: data))
        case .octetString:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-octet-string
            let data = try parseOctetString(length: length)
            print("\(indent)- OCTET STRING (\(data.count) bytes)")
            return .octetString(DEROctetString(tag: tag, value: data))
        case .null:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-null
            print("\(indent)- NULL")
            scanner.position += length // should be length = 0
            return .null(DERNull(tag: tag))
        case .objectIdentifier:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-object-identifier
            let id = try parseObjectIdentifier(length: length)
            print("\(indent)- OBJECT IDENTIFIER (\(id.description))")
            return .objectIdentifier(DERObjectIdentifier(tag: tag, objectID: id))
        case .utf8String:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-utf8string
            let string = try parseUTF8String(length: length)
            if string.contains("\n") || string.contains("\r") {
                print("\(indent)- UTF-8 STRING (\"\"\"\n\(string)\n\"\"\")")
            } else {
                print("\(indent)- UTF-8 STRING (\"\(string)\")")
            }
            return .utf8String(DERUTF8String(tag: tag, value: string))
        case .sequence:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-sequence
            print("\(indent)- SEQUENCE (\(length) bytes)")
            let children = try parseSequence(length: length)
            return .sequence(DERSequence(tag: tag, children: children))
        case .set:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-set
            print("\(indent)- SET (\(length) bytes)")
            let children = try parseSet(length: length)
            return .set(DERSet(tag: tag, children: children))
        case .printableString:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-printablestring
            let string = try parsePrintableString(length: length)
            if string.contains("\n") || string.contains("\r") {
                print("\(indent)- PRINTABLE STRING (\"\"\"\n\(string)\n\"\"\")")
            } else {
                print("\(indent)- PRINTABLE STRING (\"\(string)\")")
            }
            return .printableString(DERPrintableString(tag: tag, value: string))
            //case .t61String:
            //case .ia5String:
        case .utcTime:
            let utcTime = try parseUTCTime(length: length)
            print("\(indent)- UTC TIME (\(utcTime))")
            return .utcTime(DERUTCTime(tag: tag, value: utcTime))
            //case .generalizedTime:
        default:
            print("\(indent)- \(tag) (\(length) bytes)")
            scanner.position += length
            return .unknown(DERUnknown(tag: tag))
        }
    }
    
    // MARK: Parse Context Defined Type
    
    private func parseContextDefinedType(tag: DERTag, length: Int) throws -> DERNode {
        level += 1
        defer { level -= 1}
        
        if tag.isConstructed {
            print("\(indent)- Context Defined Constructed: \(tag) (\(length))")
            let endPosition = scanner.position + length
            var children: [DERNode] = []
            while scanner.position < endPosition {
                let node = try parseType()
                children.append(node)
            }
            return .contextDefinedConstructed(DERContextDefinedConstructed(tag: tag, children: children))
        } else {
            print("\(indent)- Context Defined Primitive: \(tag) (\(length))")
            let primitive = try scanner.scanData(length: length)
            return .contextDefinedPrimitive(DERContextDefinedPrimitive(tag: tag, primitive: primitive))
        }
        
    }
    
    // MARK: Parse Tag
    
    private func parseTag() throws -> DERTag {
        let tag = try scanner.scanUInt8()
        return DERTag(tag)
    }
    
    // MARK: Parse Length
    
    private func parseLength() throws -> Int {
        var length: Int = Int(try scanner.scanUInt8())
        if length & 0x80 > 0 {
            // If the SEQUENCE contains fewer than 128 bytes, the Length field
            // of the TLV triplet requires only one byte to specify the content
            // length. If it is more than 127 bytes, bit 7 of the Length field
            // is set to 1 and bits 6 through 0 specify the number of additional
            // bytes used to identify the content length.
            let byteCount = length & 0x1F
            // If byteCount == 0, it's variable length. We will not handle it.
            length = 0
            for _ in 1...byteCount {
                let byte = try scanner.scanUInt8()
                length = length << 8 + Int(byte)
            }
        }
        return length
    }
    
    // MARK: Parse Sequence
    
    private func parseSequence(length: Int) throws -> [DERNode] {
        let endPosition = scanner.position + length
        var children: [DERNode] = []
        while scanner.position < endPosition {
            let node = try parseType()
            children.append(node)
        }
        return children
    }
    
    // MARK: Parse Set
    
    private func parseSet(length: Int) throws -> [DERNode]  {
        let endPosition = scanner.position + length
        var children: [DERNode] = []
        while scanner.position < endPosition {
            let node = try parseType()
            children.append(node)
        }
        return children
    }
    
    // MARK: Parse Object Identifier
    
    private func parseObjectIdentifier(length: Int) throws -> DERObjectID {
        // The first two nodes of the OID are encoded onto a single byte.
        // The first node is multiplied by the decimal 40 and the result
        // is added to the value of the second node.
        
        // Node values less than or equal to 127 are encoded on one byte.
        
        // Node values greater than or equal to 128 are encoded on multiple
        // bytes. Bit 7 of the leftmost byte is set to one. Bits 0 through 6
        // of each byte contains the encoded value.
        
        var numbers: [Int] = []
        
        let firstByte = Int(try scanner.scanUInt8())
        numbers.append(firstByte / 40)
        numbers.append(firstByte % 40)
        
        var count = 1
        while count < length {
            let (size, number) = try parseBase128(length: length - count)
            count += size
            numbers.append(number)
        }
        
        return DERObjectID(numbers)
    }
    
    // MARK: Pase Base 128
    
    private func parseBase128(length: Int) throws -> (size: Int, value: Int) {
        var value = 0
        var size = 0
        while size < length {
            let byte = Int(try scanner.scanUInt8())
            size += 1
            value = (value << 7) | (byte & 0x7f)
            if byte < 0x80 {
                return (size, value)
            }
        }
        throw DERError.failedToParseBase128
    }
    
    // MARK: Parse Boolean
    
    private func parseBoolean(length: Int) throws -> Bool {
        if length != 1 {
            throw DERError.failedToParseBoolean
        }
        let value = try scanner.scanUInt8()
        return value != 0
    }
    
    // MARK: Parse Integer
    
    private func parseInteger(length: Int) throws -> Int {
        var value = Int(try scanner.scanUInt8())
        if value >= 0x80 {
            value -= 256
        }
        for _ in 1..<length {
            value = (value << 8) | Int(try scanner.scanUInt8())
        }
        return value
    }
    
    // MARK: Parse Bit String
    
    private func parseBitString(length: Int) throws -> (Int, Data) {
        // The number of unused bits that exist in the last content byte
        let unusedBitCount = Int(try scanner.scanUInt8())
        let data = try scanner.scanData(length: length - 1)
        let bitCount = (length - 1) * 8 - unusedBitCount
        return (bitCount, data)
    }
    
    // MARK: Parse Octet String
    
    private func parseOctetString(length: Int) throws -> Data {
        return try scanner.scanData(length: length)
    }
    
    // MARK: Parse UTF-8 String
    
    private func parseUTF8String(length: Int) throws -> String {
        let position = scanner.position
        do {
            return try scanner.scanString(length: length, encoding: .utf8)
        } catch {
            scanner.position = position
            return try scanner.scanString(length: length, encoding: .ascii)
        }
    }
    
    // MARK: Parse Printable String
    
    private func parsePrintableString(length: Int) throws -> String {
        try parseUTF8String(length: length)
    }
    
    // MARK: Parse UTC Time
    
    private func parseUTCTime(length: Int) throws -> String {
        var string = try parseUTF8String(length: length)
        let dash0 = string.index(string.startIndex, offsetBy: 2)
        string.insert("-", at: dash0)
        let dash1 = string.index(string.startIndex, offsetBy: 5)
        string.insert("-", at: dash1)
        let space0 = string.index(string.startIndex, offsetBy: 8)
        string.insert(" ", at: space0)
        let colon0 = string.index(string.startIndex, offsetBy: 11)
        string.insert(":", at: colon0)
        let colon1 = string.index(string.startIndex, offsetBy: 14)
        string.insert(":", at: colon1)
        let space1 = string.index(string.endIndex, offsetBy: -1)
        string.insert(" ", at: space1)
        string.insert(contentsOf: "20", at: string.startIndex)
        return string
    }
}
