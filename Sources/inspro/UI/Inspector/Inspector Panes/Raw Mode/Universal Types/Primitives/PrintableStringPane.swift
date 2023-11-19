import SwiftUI
import InspectProfile

struct PrintableStringPane: View {

    let node: Node

    let printableString: DERPrintableString

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
