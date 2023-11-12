import SwiftUI
import InspectProfile

struct ObjectIdentifierPane: View {

    let node: DERNode

    let objectIdentifier: DERObjectIdentifier

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            InspectorSectionHeader("Values")
            GridRow {
                InspectorLabel("ID")
                InspectorLinkField(
                    objectIdentifier.objectID.string,
                    url: URL(string: "http://oid-info.com/get/\(objectIdentifier.objectID.string)")
                )
            }
        }
    }
}
