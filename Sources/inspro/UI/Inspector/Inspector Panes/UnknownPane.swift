import SwiftUI
import InspectProfile

struct UnknownPane: View {

    let inspectable: any Inspectable

    var body: some View {
        InspectorPaneHeader(inspectable: inspectable)
        InspectorGrid {
            EmptyView()
        }
    }
}
