import SwiftUI
import InspectProfile

struct IntegerPane: View {

    let node: DERNode

    let integer: DERInteger

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            InspectorSectionHeader("Values")
            GridRow {
                InspectorLabel("Decimal")
                InspectorNumericField("\(integer)")
            }
            GridRow {
                InspectorLabel("Hexadecimal")
                InspectorNumericField("0x\(String(format:"%02X", integer.value))")
            }
            InspectorDivider()
        }
    }
}
