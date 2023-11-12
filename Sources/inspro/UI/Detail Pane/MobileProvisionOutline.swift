import SwiftUI
import InspectProfile

struct MobileProvisionOutline: View {

    let profile: Profile

    @Binding var selectedNode: DERNode?

    @Binding var selectedSemanticNode: SemanticNode?

    @State private var outlineMode: OutlineMode = .raw

    var body: some View {
        VStack {
            switch outlineMode {
            case .raw:
                List(profile.nodes, children: \.children, selection: $selectedNode) { node in
                    entry(for: node)
                }
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
            case .semantic where profile.semanticNodes.isEmpty:
                ContentUnavailableView(
                    "No Semantics",
                    systemImage: "exclamationmark.triangle",
                    description: Text("The DER structure of this file was not recognized.")
                )
            case .semantic:
                List(profile.semanticNodes, children: \.children, selection: $selectedSemanticNode) { semanticNode in
                    entry(for: semanticNode)
                }
                .listStyle(.sidebar)
                .scrollContentBackground(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(profile.url?.lastPathComponent ?? profile.name)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if let url = profile.url {
                    Button {
                        NSWorkspace.shared.open(url.deletingLastPathComponent())
                    } label: {
                        Label("Open in Finder", systemImage: "folder")
                    }
                } else {
                    Image(systemName: "doc.badge.gearshape")
                }
            }
            ToolbarItem {
                Picker("", selection: $outlineMode) {
                    Label("Raw", systemImage: "doc.questionmark").tag(OutlineMode.raw)
                    Label("Semantic", systemImage: "doc.text.magnifyingglass").tag(OutlineMode.semantic)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
        }
    }

    @ViewBuilder private func entry(for node: DERNode) -> some View {
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

    @ViewBuilder private func entry(for node: SemanticNode) -> some View {
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

}

private enum OutlineMode: Identifiable, Hashable {
    case raw
    case semantic

    var id: Self { self }
}

#Preview {
    MobileProvisionOutline(
        profile: Profile(),
        selectedNode: .constant(nil),
        selectedSemanticNode: .constant(nil)
    )
}
