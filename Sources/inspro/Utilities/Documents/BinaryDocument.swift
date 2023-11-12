import SwiftUI
import UniformTypeIdentifiers

struct ArbitraryFile: FileDocument {

    static var readableContentTypes = [UTType.data]

    var data = Data()

    init(initialData: Data = Data()) {
        data = initialData
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.data = data
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: data)
    }
}
