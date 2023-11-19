import Foundation

public struct ProfilePlistNode: NodeType {

    public var id: UUID = UUID()

    public var type: String = "Profile Plist"

    public var description: String {
        profilePlist.name
    }

    public let profilePlist: ProfilePlist

    public var children: [Node]?

    public let dataHash: Int

    public init?(data: Data) {

        guard let docType = #"<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">"#.data(using: .utf8) else {
            return nil
        }

        guard data.contains(docType) else {
            return nil
        }

        var profilePlist: ProfilePlist
        do {
            profilePlist = try PropertyListDecoder().decode(ProfilePlist.self, from: data)
            if let root = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
                if let entitlements = root["Entitlements"] as? [String: Any] {
                    profilePlist.entitlements = entitlements
                }
            }
        } catch {
            dump(error)
            return nil
        }

        self.profilePlist = profilePlist

        var children: [Node] = []
        if !profilePlist.entitlements.isEmpty {
            children.append(
                .entitlements(ProfileEntitlementsNode(entitlements: profilePlist.entitlements))
            )
        }

        let developerCertificates: [Node] = profilePlist.developerCertificates.map { data in
            .developerCertificate(DeveloperCertificateNode(data: data))
        }

        children.append(.developerCertificates(DeveloperCertificatesNode(children: developerCertificates)))

        self.children = children

        dataHash = data.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dataHash)
    }

    public static func == (lhs: ProfilePlistNode, rhs: ProfilePlistNode) -> Bool {
        lhs.id == rhs.id
        && lhs.dataHash == rhs.dataHash
    }
}

public struct ProfilePlist {
    public let appIDName: String
    public let applicationIdentifierPrefix: [String]
    public let creationDate: Date
    public let platform: [String]
    public let isXcodeManaged: Bool
    public let developerCertificates: [Data]
    public let DEREncodedProfile: Data
    public fileprivate(set) var entitlements: [String: Any]
    public let expirationDate: Date
    public let name: String
    public let teamIdentifier: [String]
    public let teamName: String
    public let timeToLive: Int
    public let uuid: String
    public let version: Int
}

extension ProfilePlist: Codable {

    enum CodingKeys: String, CodingKey {
        case appIDName = "AppIDName"
        case applicationIdentifierPrefix = "ApplicationIdentifierPrefix"
        case creationDate = "CreationDate"
        case platform = "Platform"
        case isXcodeManaged = "IsXcodeManaged"
        case developerCertificates = "DeveloperCertificates"
        case DEREncodedProfile = "DER-Encoded-Profile"
        case expirationDate = "ExpirationDate"
        case name = "Name"
        case teamIdentifier = "TeamIdentifier"
        case teamName = "TeamName"
        case timeToLive = "TimeToLive"
        case uuid = "UUID"
        case version = "Version"
    }

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        appIDName = try container.decode(String.self, forKey: .appIDName)
        applicationIdentifierPrefix = try container.decode([String].self, forKey: .applicationIdentifierPrefix)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        platform = try container.decode([String].self, forKey: .platform)
        isXcodeManaged = try container.decode(Bool.self, forKey: .isXcodeManaged)
        developerCertificates = try container.decode([Data].self, forKey: .developerCertificates)
        DEREncodedProfile = try container.decode(Data.self, forKey: .DEREncodedProfile)
        expirationDate = try container.decode(Date.self, forKey: .expirationDate)
        name = try container.decode(String.self, forKey: .name)
        teamIdentifier = try container.decode([String].self, forKey: .teamIdentifier)
        teamName = try container.decode(String.self, forKey: .teamName)
        timeToLive = try container.decode(Int.self, forKey: .timeToLive)
        uuid = try container.decode(String.self, forKey: .uuid)
        version = try container.decode(Int.self, forKey: .version)
        entitlements = [:]
    }
}
