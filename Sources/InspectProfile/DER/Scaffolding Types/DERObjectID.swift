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

        .PilotAttributeType.uid,

        .Signature.ecdsaWithSHA256,
        .Signature.ecdsaWithSHA384,

        .PKCS1.rsaEncryption,
        .PKCS1.sha1WithRSASignature,
        .PKCS1.sha256WithRSASignature,

        .PKCS7.data,
        .PKCS7.signedData,

        .PKCS9.contentType,
        .PKCS9.messageDigest,
        .PKCS9.signingTime,
        .PKCS9.smimeCapabilities,
        .PKCS9.cmsAlgorithmProtection,

        .EncryptionAlgorithm.rc2CBC,
        .EncryptionAlgorithm.desEDE3CBC,

        .AppleCertificateExtension.iPhoneSoftwareDevelopmentSigning,
        .AppleCertificateExtension.iPhoneSoftwareSubmissionSigning,
        .AppleCertificateExtension.macApplicationSoftwareSubmissionSigning,
        .AppleCertificateExtension.macApplicationSoftwareDevelopmentSigning,
        .AppleCertificateExtension.developerIDSigningIntermediateCertificate,
        .AppleCertificateExtension.unknownDevidKernel,
        .AppleCertificateExtension.unknown58,
        .AppleCertificateExtension.unknown12_19,

        .PKIX.CertificateExtension.authorityInfoAccess,

        .PKIX.AccessDescriptor.ocsp,
        .PKIX.AccessDescriptor.caIssuers,

        .Algorithm.desCBC,
        .Algorithm.sha1,
        .Algorithm.sha256,

        .Curve.ansip384r1,

        .AttributeType.commonName,
        .AttributeType.countryName,
        .AttributeType.organizationName,
        .AttributeType.organizationUnitName,

        .CertificateExtension.subjectKeyIdentifier,
        .CertificateExtension.keyUsage,
        .CertificateExtension.basicConstraints,
        .CertificateExtension.certificateRevocationListDistributionPoints,
        .CertificateExtension.certificatePolicies,
        .CertificateExtension.authoriyKeyIdentifier,
        .CertificateExtension.extendedKeyUsage

    ].dictionary(keyedBy: \DERObjectID.string)

    // MARK: - PilotAttributeType

    public struct PilotAttributeType {
        public static let uid = DERObjectID("0.9.2342.19200300.100.1.1", name: "\"uid\" LDAP attribute type: User shortname or userid")
    }

    // MARK: - Key Type

    public struct KeyType {
        public static let ecPublicKey = DERObjectID("1.2.840.10045.2.1", name: "Elliptic curve public key")
    }

    // MARK: - Signature

    public struct Signature {
        public static let ecdsaWithSHA256 = DERObjectID("1.2.840.10045.4.3.2", name: "Signature: Elliptic Curve Digital Signature Algorithm (DSA) coupled with the Secure Hash Algorithm 256 (SHA256) algorithm")
        public static let ecdsaWithSHA384 = DERObjectID("1.2.840.10045.4.3.3", name: "Elliptic curve Digital Signature Algorithm (DSA) coupled with the Secure Hash Algorithm 384 (SHA384) algorithm")
    }

    // MARK: - PKCS#1

    public struct PKCS1 {
        public static let rsaEncryption = DERObjectID("1.2.840.113549.1.1.1", name: "PKCS#1: RSA Encryption")
        public static let sha1WithRSASignature = DERObjectID("1.2.840.113549.1.1.5", name: "PKCS#1: SHA-1 with RSA Signature")
        public static let sha256WithRSASignature = DERObjectID("1.2.840.113549.1.1.11", name: "PKCS#1: SHA-256 with RSA Signature")
    }

    // MARK: - PKCS#7

    public struct PKCS7 {
        public static let data = DERObjectID("1.2.840.113549.1.7.1", name: "PKCS#7: Data")
        public static let signedData = DERObjectID("1.2.840.113549.1.7.2", name: "PKCS#7: Signed Data")
    }

    // MARK: - PKCS#9

    public struct PKCS9 {
        public static let contentType = DERObjectID("1.2.840.113549.1.9.3", name: "PKCS#9: Content Type")
        public static let messageDigest = DERObjectID("1.2.840.113549.1.9.4", name: "PKCS#9: Message Digest")
        public static let signingTime = DERObjectID("1.2.840.113549.1.9.5", name: "PKCS#9: Signing Time")
        public static let smimeCapabilities = DERObjectID("1.2.840.113549.1.9.15", name: "PKCS#9: S/MIME Capabilities")
        public static let cmsAlgorithmProtection = DERObjectID("1.2.840.113549.1.9.52", name: "PKCS#9: CMS Algorithm Protection")
    }

    // MARK: - EncryptionAlgorithm

    public struct EncryptionAlgorithm {
        public static let rc2CBC = DERObjectID("1.2.840.113549.3.2", name: "Rivest Cipher (RC2)-compatible (56 bit) or RC2-compatible in Cipher Block Chaining (CBC)")
        public static let desEDE3CBC = DERObjectID("1.2.840.113549.3.7", name: "Triple Data Encryption Standard (DES) algorithm coupled with a cipher-block chaining mode of operation")
    }

    // MARK: - AppleCertificateExtension

    public struct AppleCertificateExtension {
        public static let iPhoneSoftwareDevelopmentSigning = DERObjectID("1.2.840.113635.100.6.1.2", name: "Apple Certificate Extension: iPhone Software Development Signing")
        public static let iPhoneSoftwareSubmissionSigning = DERObjectID("1.2.840.113635.100.6.1.4", name: "iPhone Software Submission Signing")
        public static let macApplicationSoftwareSubmissionSigning = DERObjectID("1.2.840.113635.100.6.1.7", name: "Mac Application Software Submission Signing")
        public static let macApplicationSoftwareDevelopmentSigning = DERObjectID("1.2.840.113635.100.6.1.12", name: "Apple Certificate Extension: Mac Application Software Development Signing")
        public static let developerIDSigningIntermediateCertificate = DERObjectID("1.2.840.113635.100.6.2.17", name: "Apple Intermediate Certificate: Apple System Integration CA 4")
        public static let unknownDevidKernel = DERObjectID("1.2.840.113635.100.6.2.18", name: "Apple Certificate Extension: devid_kernel")
        public static let unknown58 = DERObjectID("1.2.840.113635.100.6.58", name: "Apple Certificate Extension: 58")
        public static let unknown12_19 = DERObjectID("1.2.840.113635.100.12.19", name: "Apple: Unknown ???")
    }

    // MARK: - PKIX

    public struct PKIX {
        
        public struct CertificateExtension {
            public static let authorityInfoAccess = DERObjectID("1.3.6.1.5.5.7.1.1", name: "Public-Key Infrastructure X.509 (PKIX): Certificate Authority Information Access")
        }

        public struct AccessDescriptor {
            public static let ocsp = DERObjectID("1.3.6.1.5.5.7.48.1", name: "Access method: Location of On-line Certificate Status Protocol responder")
            public static let caIssuers = DERObjectID("1.3.6.1.5.5.7.48.2", name: "Access method used in a public key certificate when the additional information lists certificates that were issued to the Certificate Authority (CA) that issued the certificate containing this extension")
        }
    }

    // MARK: - Algorithm

    public struct Algorithm {
        public static let desCBC = DERObjectID("1.3.14.3.2.7", name: "56-bit Data Encryption Standard (DES) in Cipher Block Chaining (CBC)")
        public static let sha1 = DERObjectID("1.3.14.3.2.26", name: "Secure Hash Algorithm, SHA-1")
        public static let sha256 = DERObjectID("2.16.840.1.101.3.4.2.1", name: "Secure Hash Algorithm, SHA-256")
    }

    // MARK: - Curve

    public struct Curve {
        public static let ansip384r1 = DERObjectID("1.3.132.0.34", name: "NIST 384-bit elliptic curve")
        public static let secp256r1 = DERObjectID("1.2.840.10045.3.1.7", name: "256-bit Elliptic Curve Cryptography (ECC)")
    }

    // MARK: - AttributeType

    public struct AttributeType {
        public static let commonName = DERObjectID("2.5.4.3", name: "Attribute Type: Common Name")
        public static let countryName = DERObjectID("2.5.4.6", name: "Attribute Type: Country Name")
        public static let organizationName = DERObjectID("2.5.4.10", name: "Attribute Type: Organization Name")
        public static let organizationUnitName = DERObjectID("2.5.4.11", name: "Attribute Type: Organization Unit Name")
    }

    // MARK: - CertificateExtension

    public struct CertificateExtension {
        public static let subjectKeyIdentifier = DERObjectID("2.5.29.14", name: "Certificate Extension: Subject Key Identifier")
        public static let keyUsage = DERObjectID("2.5.29.15", name: "Certificate Extension: Key Usage")
        public static let basicConstraints = DERObjectID("2.5.29.19", name: "Certificate Extension: Basic Constraints")
        public static let certificateRevocationListDistributionPoints = DERObjectID("2.5.29.31", name: "Certificate Extension: Certificate Revocation List Distribution Points")
        public static let certificatePolicies = DERObjectID("2.5.29.32", name: "Certificate Extension: Certificate Policies")
        public static let authoriyKeyIdentifier = DERObjectID("2.5.29.35", name: "Certificate Extension: Authority key identifier")
        public static let extendedKeyUsage = DERObjectID("2.5.29.37", name: "Certificate Extension: Extended Key Usage")
    }
}
