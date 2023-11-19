import SwiftUI
import InspectProfile

struct EntitlementsPane: View {

    let node: Node

    let entitlements: [String: String]

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        ScrollView {
            VStack {
                ForEach(Array(entitlements.keys), id: \.self) { key in
                    if let value = entitlements[key] {
                        InspectorLabel(key)
                        InspectorLabel(value)
                    }
                }
            }
        }

        InspectorGrid {
            EmptyView()
        }
    }
}
