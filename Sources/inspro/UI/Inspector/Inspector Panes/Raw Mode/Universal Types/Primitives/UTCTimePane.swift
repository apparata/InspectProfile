import SwiftUI
import InspectProfile

struct UTCTimePane: View {

    let node: Node

    let utcTime: DERUTCTime

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
