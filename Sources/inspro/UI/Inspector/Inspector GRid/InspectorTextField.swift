import SwiftUI

struct InspectorTextField: View {

    private let string: String

    init(_ string: String) {
        self.string = string
    }

    var body: some View {
        Text(.init(string))
            .frame(minWidth: 100, maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(.white.opacity(0.1))
            .cornerRadius(4)
            .padding(.trailing, inspectorGridRowPadding)
            .contextMenu {
                Button {
                    copyToPasteboard(string)
                } label: {
                    Label("Copy", systemImage: "doc.on.clipboard")
                }
            }
    }
}
