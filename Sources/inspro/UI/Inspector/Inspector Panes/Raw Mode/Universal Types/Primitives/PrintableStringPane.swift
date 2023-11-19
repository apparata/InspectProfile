import SwiftUI
import InspectProfile

struct PrintableStringPane: View {

    let node: DERNode

    let printableString: DERPrintableString

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
