import Foundation

public struct DeveloperCertificate: Codable, Hashable {

    public let data: Data

    public let nodes: [Node]

    public init(data: Data) {
        self.data = data
        let parser = DERParser(data: data)
        do {
            self.nodes = try parser.parse()
        } catch {
            self.nodes = []
        }
    }
}
