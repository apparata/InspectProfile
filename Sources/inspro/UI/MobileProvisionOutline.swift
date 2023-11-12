import SwiftUI
import InspectProfile

struct MobileProvisionOutline: View {

    let profile: Profile

    @Binding var selectedNode: DERNode?

    var body: some View {
        List(profile.nodes, children: \.children, selection: $selectedNode) { node in
            HStack(spacing: 0) {
                Image(systemName: node.systemIcon)
                    .fontWeight(.medium)
                    .foregroundStyle(node.iconColor)
                    .padding(.leading, 2)
                    .padding(.trailing, 4)
                Text(node.type)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .padding(.trailing, 16)
                Text(.init(node.description))
                    .foregroundStyle(.secondary)
                    .opacity(0.6)
            }
            .tag(node)
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .navigationTitle(profile.name)
    }
}

#Preview {
    MobileProvisionOutline(profile: Profile(), selectedNode: .constant(nil))
}

extension DERNode {
    var systemIcon: String {
        switch self {
        case .contextDefinedConstructed: return "questionmark.folder"
        case .contextDefinedPrimitive: return "questionmark.square.dashed"

        case .sequence: return "square.stack.3d.down.right"
        case .set: return "folder"

        case .bitString: return "01.square"
        case .boolean: return "circle.grid.2x1.left.filled"
        case .integer: return "number"
        case .null: return "circle.dashed"
        case .objectIdentifier: return "person.text.rectangle"
        case .octetString: return "8.square"
        case .printableString: return "text.alignleft"
        case .utcTime: return "clock"
        case .utf8String: return "text.alignleft"

        case .unknown: return "questionmark"
        }
    }

    var iconColor: Color {
        switch self {
        case .contextDefinedConstructed: return .blue
        case .contextDefinedPrimitive: return .cyan

        case .sequence: return .blue
        case .set: return .blue

        case .bitString: return .purple
        case .boolean: return .yellow
        case .integer: return .yellow
        case .null: return .secondary
        case .objectIdentifier: return .green
        case .octetString: return .purple
        case .printableString: return .orange
        case .utcTime: return .mint
        case .utf8String: return .orange

        case .unknown: return .red
        }
    }
}
