import SwiftUI
import InspectProfile

struct InspectorHexDump: View {

    private let title: String

    private let data: Data

    @State private var string: String = ""

    @Environment(\.openWindow) private var openWindow

    @State private var isPresentingExporter: Bool = false

    init(title: String, data: Data) {
        self.title = title
        self.data = data
    }

    var body: some View {
        TextEditor(text: .constant(string))
            .font(.custom("Menlo", size: 12))
            .overlay(alignment: .bottomTrailing) {
                VStack {
                    Button {
                        isPresentingExporter = true
                    } label: {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .frame(width: 32, height: 32)
                        .background(.thickMaterial)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .fileExporter(
                        isPresented: $isPresentingExporter,
                        document: ArbitraryFile(initialData: data),
                        contentType: .data,
                        defaultFilename: "OctetString.data"
                    ) { result in
                        switch result {
                        case .success(let url):
                            print("Saved to \(url)")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }

                    Button {
                        let windowData = WindowData(
                            title: title,
                            data: data
                        )
                        openWindow(id: HexDumpWindow.windowID, value: windowData)
                    } label: {
                        VStack {
                            Image(systemName: "pip.enter")
                        }
                        .frame(width: 32, height: 32)
                        .background(.thickMaterial)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)

                    Button {
                        let windowData = WindowData(
                            title: title,
                            data: Data(data)
                        )
                        openWindow(id: NodeTreeWindow.windowID, value: windowData)
                    } label: {
                        VStack {
                            Image(systemName: "macwindow.badge.plus")
                        }
                        .frame(width: 32, height: 32)
                        .background(.thickMaterial)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)

                }
                .padding()
            }
            .overlay(alignment: .center) {
                if string == "" {
                    ProgressView()
                }
            }
            .task(id: data) {
                self.string = ""
                Task.detached {
                    let string = hexDump(data, bytesPerRow: 8)
                    await MainActor.run {
                        withAnimation {
                            self.string = string
                        }
                    }
                }
            }
    }
}
