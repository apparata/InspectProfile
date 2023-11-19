import SwiftUI
import InspectProfile

struct MobileProvisionOutline: View {

    let profile: Profile

    @Binding var selectedNode: Node?

    @Binding var selectedSemanticNode: Node?

    @Binding var outlineMode: OutlineMode

    @AppStorage(\AppSettings.textScale) private var textScale

    var body: some View {
        VStack {
            ZStack {
                VStack {
                    ContentUnavailableView(
                        "No Semantics",
                        systemImage: "exclamationmark.triangle",
                        description: Text("The DER structure of this file was not recognized.")
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
                .zIndex(outlineMode == .semantic && profile.semanticNodes.isEmpty ? 2 : 1)

                VStack {
                    List(profile.semanticNodes, children: \.children, selection: $selectedSemanticNode) { semanticNode in
                        entry(for: semanticNode)
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
                .zIndex(outlineMode == .semantic && !profile.semanticNodes.isEmpty ? 2 : 1)

                VStack {
                    List(profile.nodes, children: \.children, selection: $selectedNode) { node in
                        entry(for: node)
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
                .zIndex(outlineMode == .raw ? 2 : 0)
            }
        }
        .accentColor(.gray)
        .environment(\.dynamicTypeSize, .xxLarge)
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
                    Image(systemName: "list.bullet.indent")
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

    @ViewBuilder private func entry(for node: Node) -> some View {
        HStack(spacing: 0) {
            Image(systemName: node.systemIcon)
                .font(.system(size: round(13 * textScale)))
                .fontWeight(.medium)
                .foregroundStyle(node.iconColor)
                .padding(.leading, 2)
                .padding(.trailing, 4)
            Text(node.type)
                .font(.system(size: round(15 * textScale)))
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .padding(.trailing, 16)
            Text(.init(node.description))
                .font(.system(size: round(13 * textScale)))
                .foregroundStyle(.secondary)
                .opacity(0.6)
        }
        .tag(node)
    }
}

enum OutlineMode: Identifiable, Hashable {
    case raw
    case semantic

    var id: Self { self }
}
