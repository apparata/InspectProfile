import SwiftUI
import InspectProfile

struct UTCTimePane: View {

    let node: DERNode

    let utcTime: DERUTCTime

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
