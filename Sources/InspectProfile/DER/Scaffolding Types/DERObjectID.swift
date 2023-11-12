import Foundation

public struct DERObjectID: Codable, Hashable, Equatable, CustomStringConvertible, ExpressibleByStringLiteral {

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

    public init(stringLiteral value: String) {
        self.string = value
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
