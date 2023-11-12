import SwiftUI
import InspectProfile

extension SemanticNode {

    var systemIcon: String {
        switch self {
        case .signedData: "checkmark.shield"
        }
    }

    var iconColor: Color {
        switch self {
        case .signedData: .green
        }
    }
}
