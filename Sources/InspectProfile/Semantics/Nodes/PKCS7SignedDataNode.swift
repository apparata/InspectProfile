import Foundation

/// `SignedData`
///
/// [RFC5652 Section 5.1](https://www.rfc-editor.org/rfc/rfc5652.html#section-5.1)
///
/// ```
/// SignedData ::= SEQUENCE {
///     version CMSVersion,
///     digestAlgorithms DigestAlgorithmIdentifiers,
///     encapContentInfo EncapsulatedContentInfo,
///     certificates [0] IMPLICIT CertificateSet OPTIONAL,
///     crls [1] IMPLICIT RevocationInfoChoices OPTIONAL,
///     signerInfos SignerInfos }
///
/// DigestAlgorithmIdentifiers ::= SET OF DigestAlgorithmIdentifier
///
/// SignerInfos ::= SET OF SignerInfo
/// ```
public struct PKCS7SignedDataNode: NodeType {

    public static let objectID = DERObjectID(
        "1.2.840.113549.1.7.2",
        name: "PKCS#7: Signed Data"
    )

    public var id: UUID = UUID()

    public var type: String {
        Self.objectID.name ?? "\(self.type)"
    }

    public var description: String {
        Self.objectID.string
    }

    public var children: [Node]?

    public init(children: [Node]?) {
        self.children = children
    }
}
