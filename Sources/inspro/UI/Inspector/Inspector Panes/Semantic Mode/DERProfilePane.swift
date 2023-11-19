import SwiftUI
import InspectProfile

struct DERProfilePane: View {

    let inspectable: any Inspectable

    let data: Data

    var body: some View {
        InspectorPaneHeader(inspectable: inspectable)
        InspectorHexDump(title: "DER Profile", data: data)
    }
}
