import SwiftUI
import InspectProfile

extension Node: Inspectable {
    var systemIcon: String {
        switch self {

        // --------------------------------------------------------------------
        // MARK: DER Nodes
        // --------------------------------------------------------------------

        case .contextDefinedConstructed: "questionmark.folder"
        case .contextDefinedPrimitive: "questionmark.square.dashed"

        case .sequence: "square.stack.3d.down.right"
        case .set: "folder"

        case .bitString: "01.square"
        case .boolean: "circle.grid.2x1.left.filled"
        case .integer: "number"
        case .null: "circle.dashed"
        case .objectIdentifier: "person.text.rectangle"
        case .octetString: "8.square"
        case .printableString: "text.alignleft"
        case .utcTime: "clock"
        case .utf8String: "text.alignleft"

        case .unknown: "questionmark"

        // --------------------------------------------------------------------
        // MARK: Semantic Nodes
        // --------------------------------------------------------------------

        case .pkcs7SignedData: "checkmark.shield"
        case .pkcs7Data: "8.square"
        case .profilePlist: "list.bullet"
        case .derProfile: "8.square"
        case .entitlements: "wallet.pass"
        case .provisionedDevices: "apps.iphone"
        case .developerCertificates: "person.2.badge.key"
        case .developerCertificate: "checkmark.seal"
        }
    }

    var iconColor: Color {
        switch self {

        // --------------------------------------------------------------------
        // MARK: DER Nodes
        // --------------------------------------------------------------------

        case .contextDefinedConstructed: .blue
        case .contextDefinedPrimitive: .cyan

        case .sequence: .blue
        case .set: .blue

        case .bitString: .purple
        case .boolean: .yellow
        case .integer: .yellow
        case .null: .secondary
        case .objectIdentifier: .green
        case .octetString: .purple
        case .printableString: .orange
        case .utcTime: .mint
        case .utf8String: .orange

        case .unknown: .red

        // --------------------------------------------------------------------
        // MARK: Semantic Nodes
        // --------------------------------------------------------------------

        case .pkcs7SignedData: .green
        case .pkcs7Data: .blue
        case .profilePlist: .purple
        case .derProfile: .blue
        case .entitlements: .orange
        case .provisionedDevices: .green
        case .developerCertificates: .cyan
        case .developerCertificate: .blue
        }
    }
}
