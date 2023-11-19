import Foundation
import BinaryDataKit

// https://letsencrypt.org/sv/docs/a-warm-welcome-to-asn1-and-der/
// https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-sequence

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
    
    public func parse() throws -> [Node] {
        print("Parsing...")
        var nodes: [Node] = []
        while scanner.position < data.count {
            let node = try parseType()
            nodes.append(node)
        }
        print("Parsed to end of file.")
        return nodes
    }
    
    // MARK: Parse Type
    
    private func parseType() throws -> Node {

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
    
    private func parseUniversalType(tag: DERTag, length: Int) throws -> Node {
        level += 1
        defer { level -= 1}

        let range = scanner.position..<(scanner.position + length)

        switch tag {
            //case .implicit:
        case .boolean:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-boolean
            let value = try parseBoolean(length: length)
            print("\(indent)- BOOLEAN (\(value))")
            return .boolean(DERBoolean(tag: tag, value: value, range: range))
        case .integer:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-integer
            let value = try parseInteger(length: length)
            print("\(indent)- INTEGER (value: \(value))")
            return .integer(DERInteger(tag: tag, value: value, range: range))
        case .bitString:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-bit-string
            let (bitCount, data) = try parseBitString(length: length)
            _ = data
            print("\(indent)- BIT STRING (\(bitCount) bits)")
            return .bitString(DERBitString(tag: tag, bitCount: bitCount, value: data, range: range))
        case .octetString:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-octet-string
            let data = try parseOctetString(length: length)
            print("\(indent)- OCTET STRING (\(data.count) bytes)")
            return .octetString(DEROctetString(tag: tag, value: data, range: range))
        case .null:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-null
            print("\(indent)- NULL")
            scanner.position += length // should be length = 0
            return .null(DERNull(tag: tag, range: range))
        case .objectIdentifier:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-object-identifier
            let id = try parseObjectIdentifier(length: length)
            print("\(indent)- OBJECT IDENTIFIER (\(id.description))")
            return .objectIdentifier(DERObjectIdentifier(tag: tag, objectID: id, range: range))
        case .utf8String:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-utf8string
            let string = try parseUTF8String(length: length)
            if string.contains("\n") || string.contains("\r") {
                print("\(indent)- UTF-8 STRING (\"\"\"\n\(string)\n\"\"\")")
            } else {
                print("\(indent)- UTF-8 STRING (\"\(string)\")")
            }
            return .utf8String(DERUTF8String(tag: tag, value: string, range: range))
        case .sequence:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-sequence
            print("\(indent)- SEQUENCE (\(length) bytes)")
            let children = try parseSequence(length: length)
            return .sequence(DERSequence(tag: tag, children: children, range: range))
        case .set:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-set
            print("\(indent)- SET (\(length) bytes)")
            let children = try parseSet(length: length)
            return .set(DERSet(tag: tag, children: children, range: range))
        case .printableString:
            // https://learn.microsoft.com/en-us/windows/win32/seccertenroll/about-printablestring
            let string = try parsePrintableString(length: length)
            if string.contains("\n") || string.contains("\r") {
                print("\(indent)- PRINTABLE STRING (\"\"\"\n\(string)\n\"\"\")")
            } else {
                print("\(indent)- PRINTABLE STRING (\"\(string)\")")
            }
            return .printableString(DERPrintableString(tag: tag, value: string, range: range))
            //case .t61String:
            //case .ia5String:
        case .utcTime:
            let utcTime = try parseUTCTime(length: length)
            print("\(indent)- UTC TIME (\(utcTime))")
            return .utcTime(DERUTCTime(tag: tag, value: utcTime, range: range))
            //case .generalizedTime:
        default:
            print("\(indent)- \(tag) (\(length) bytes)")
            scanner.position += length
            return .unknown(DERUnknown(tag: tag, range: range))
        }
    }
    
    // MARK: Parse Context Defined Type
    
    private func parseContextDefinedType(tag: DERTag, length: Int) throws -> Node {
        level += 1
        defer { level -= 1}

        let range = scanner.position..<(scanner.position + length)

        if tag.isConstructed {
            print("\(indent)- Context Defined Constructed: \(tag) (\(length))")
            let endPosition = scanner.position + length
            var children: [Node] = []
            while scanner.position < endPosition {
                let node = try parseType()
                children.append(node)
            }
            return .contextDefinedConstructed(DERContextDefinedConstructed(tag: tag, children: children, range: range))
        } else {
            print("\(indent)- Context Defined Primitive: \(tag) (\(length))")
            let primitive = try scanner.scanData(length: length)
            return .contextDefinedPrimitive(DERContextDefinedPrimitive(tag: tag, primitive: primitive, range: range))
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
    
    private func parseSequence(length: Int) throws -> [Node] {
        let endPosition = scanner.position + length
        var children: [Node] = []
        while scanner.position < endPosition {
            let node = try parseType()
            children.append(node)
        }
        return children
    }
    
    // MARK: Parse Set
    
    private func parseSet(length: Int) throws -> [Node]  {
        let endPosition = scanner.position + length
        var children: [Node] = []
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
