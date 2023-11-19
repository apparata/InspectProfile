import SwiftUI
import InspectProfile

struct ProvisionedDevicesPane: View {

    let node: Node

    let devices: [String]

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(devices, id: \.self) { device in
                    Text(device)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical)
            .padding(.leading, 8)
        }
    }
}
