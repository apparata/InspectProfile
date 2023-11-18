import Foundation

public struct DERObjectID: Codable, Hashable, Equatable, CustomStringConvertible {

    public let name: String?

    public let string: String

    public var description: String {
        if let name {
            return name
        } else {
            return string
        }
    }

    public init(_ values: Int..., name: String? = nil) {
        let string = values.map { String($0) }.joined(separator: ".")
        self.string = string
        self.name = name ?? Self.knownIDs[string]?.name
    }

    public init(_ values: [Int], name: String? = nil) {
        let string = values.map { String($0) }.joined(separator: ".")
        self.string = string
        self.name = name ?? Self.knownIDs[string]?.name
    }

    public init(_ string: String, name: String? = nil) {
        self.string = string
        self.name = name ?? Self.knownIDs[string]?.name
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.string == rhs.string
    }

    private static let knownIDs: [String: DERObjectID] = [
        SignedDataNode.objectID,
        DERObjectID("0.9.2342.19200300.100.1.1", name: "\"uid\" LDAP attribute type: User shortname or userid"),
        DERObjectID("1.2.840.113549.1.1.1", name: "PKCS#1: RSA Encryption"),
        DERObjectID("1.2.840.113549.1.1.5", name: "PKCS#1: SHA-1 with RSA Signature"),
        DERObjectID("1.2.840.113549.1.1.11", name: "PKCS#1: SHA-256 with RSA Encryption"),
        DERObjectID("1.2.840.113549.1.7.1", name: "PKCS#7: Data"),
        DERObjectID("1.2.840.113549.1.7.2", name: "PKCS#7: Signed Data"),
        DERObjectID("1.2.840.113549.1.9.3", name: "PKCS#9: Content Type"),
        DERObjectID("1.2.840.113549.1.9.4", name: "PKCS#9: Message Digest"),
        DERObjectID("1.2.840.113549.1.9.5", name: "PKCS#9: Signing Time"),
        DERObjectID("1.2.840.113549.1.9.15", name: "PKCS#9: S/MIME Capabilities"),
        DERObjectID("1.2.840.113549.1.9.52", name: "PKCS#9: CMS Algorithm Protection"),
        DERObjectID("1.2.840.113549.3.2", name: "Rivest Cipher (RC2)-compatible (56 bit) or RC2-compatible in Cipher Block Chaining (CBC)"),
        DERObjectID("1.2.840.113549.3.7", name: "Triple Data Encryption Standard (DES) algorithm coupled with a cipher-block chaining mode of operation"),
        DERObjectID("1.2.840.113635.100.6.58", name: "Apple Certificate Extension: 58"),
        DERObjectID("1.2.840.113635.100.6.1.2", name: "Apple Certificate Extension: iPhone Software Development Signing"),
        DERObjectID("1.2.840.113635.100.6.1.12", name: "Apple Certificate Extension: Mac Application Software Development Signing"),
        DERObjectID("1.2.840.113635.100.6.2.18", name: "Apple Certificate Extension: devid_kernel"),
        DERObjectID("1.3.6.1.5.5.7.1.1", name: "Public-Key Infrastructure X.509 (PKIX): Certificate Authority Information Access"),
        DERObjectID("1.3.6.1.5.5.7.48.1", name: "Access method: Location of On-line Certificate Status Protocol responder"),
        DERObjectID("1.3.6.1.5.5.7.48.2", name: "Access method used in a public key certificate when the additional information lists certificates that were issued to the Certificate Authority (CA) that issued the certificate containing this extension"),
        DERObjectID("1.3.14.3.2.7", name: "56-bit Data Encryption Standard (DES) in Cipher Block Chaining (CBC)"),
        DERObjectID("1.3.14.3.2.26", name: "Secure Hash Algorithm, SHA-1"),
        DERObjectID("2.5.4.3", name: "Attribute Type: Common Name"),
        DERObjectID("2.5.4.6", name: "Attribute Type: Country Name"),
        DERObjectID("2.5.4.10", name: "Attribute Type: Organization Name"),
        DERObjectID("2.5.4.11", name: "Attribute Type: Organization Unit Name"),
        DERObjectID("2.5.29.14", name: "Certificate Extension: Subject Key Identifier"),
        DERObjectID("2.5.29.15", name: "Certificate Extension: Key Usage"),
        DERObjectID("2.5.29.19", name: "Certificate Extension: Basic Constraints"),
        DERObjectID("2.5.29.31", name: "Certificate Extension: Certificate Revocation List Distribution Points"),
        DERObjectID("2.5.29.32", name: "Certificate Extension: Certificate Policies"),
        DERObjectID("2.5.29.35", name: "Certificate Extension: Authority key identifier"),
        DERObjectID("2.5.29.37", name: "Certificate Extension: Extended Key Usage"),
    ].dictionary(keyedBy: \DERObjectID.string)
}
