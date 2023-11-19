import SwiftUI
import InspectProfile

extension SemanticNode: Inspectable {

    var systemIcon: String {
        switch self {
        case .pkcs7SignedData: "checkmark.shield"
        case .pkcs7Data: "8.square"
        case .profilePlist: "list.bullet"
        case .entitlements: "wallet.pass"
        case .developerCertificates: "person.2.badge.key"
        case .developerCertificate: "checkmark.seal"
        }
    }

    var iconColor: Color {
        switch self {
        case .pkcs7SignedData: .green
        case .pkcs7Data: .blue
        case .profilePlist: .purple
        case .entitlements: .orange
        case .developerCertificates: .cyan
        case .developerCertificate: .blue
        }
    }
}
