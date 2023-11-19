import SwiftUI
import InspectProfile

struct EntitlementsPane: View {

    let node: Node

    let entitlements: [String: String]

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(entitlements.keys), id: \.self) { key in
                    if let value = entitlements[key] {
                        InspectorLabel(key)
                            .padding(.trailing, 8)
                        InspectorTextField(value)
                            .padding(.leading, 8)
                        InspectorDivider()
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
