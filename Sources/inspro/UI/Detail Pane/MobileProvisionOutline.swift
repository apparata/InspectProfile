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
        .navigationTitle(profile.url?.lastPathComponent ?? profile.name)
    }
}

#Preview {
    MobileProvisionOutline(profile: Profile(), selectedNode: .constant(nil))
}
