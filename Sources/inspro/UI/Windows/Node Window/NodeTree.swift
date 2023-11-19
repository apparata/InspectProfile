import SwiftUI
import InspectProfile

struct NodeTree: View {

    @State private var nodeTreeModel = NodeTreeModel()

    @State private var selectedNode: Node?

    @State private var selectedSemanticNode: Node?

    @State private var outlineMode: OutlineMode = .raw

    init(title: String, data: Data) {
        do {
            try nodeTreeModel.parseProfile(name: title, data: data)
        } catch {
            dump(error)
        }
    }

    var body: some View {
        NavigationStack {
            if let profile = nodeTreeModel.profile {
                MobileProvisionOutline(
                    profile: profile,
                    selectedNode: $selectedNode,
                    selectedSemanticNode: $selectedSemanticNode,
                    outlineMode: $outlineMode
                )
            }
        }
        .inspector(isPresented: .constant(true)) {
            if let node = selectedNode ?? selectedSemanticNode, let profile = nodeTreeModel.profile {
                NodeInspector(
                    node: node,
                    profile: profile,
                    outlineMode: outlineMode
                )
            }
        }
    }
}
