import SwiftUI

struct InspectorLabel: View {

    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.leading, inspectorGridRowPadding)
            .gridColumnAlignment(.trailing)
    }
}
