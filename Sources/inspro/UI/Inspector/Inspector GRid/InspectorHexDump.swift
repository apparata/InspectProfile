import SwiftUI
import InspectProfile

struct InspectorHexDump: View {

    private let data: Data

    @State private var string: String = ""

    @Environment(\.openWindow) private var openWindow

    @State private var isPresentingExporter: Bool = false

    init(data: Data) {
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
                        openWindow(value: data)
                    } label: {
                        VStack {
                            Image(systemName: "pip.enter")
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
