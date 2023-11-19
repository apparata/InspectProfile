import SwiftUI
import InspectProfile

struct RawDataPane: View {

    let inspectable: any Inspectable

    let data: Data

    var body: some View {
        InspectorPaneHeader(inspectable: inspectable)
        InspectorHexDump(title: inspectable.type, data: data)
    }
}
