import Foundation

public struct DeveloperCertificate: Codable, Hashable {

    public let data: Data

    public let nodes: [Node]

    public let name: String

    public init(data: Data) {
        self.data = data
        let parser = DERParser(data: data)
        do {
            let nodes = try parser.parse()
            self.nodes = nodes
            self.name = Self.extractName(from: nodes)
        } catch {
            self.name = "Invalid certificate"
            self.nodes = []
        }
    }

    private static func extractName(from nodes: [Node]) -> String {

        let name = nodes.extract(at: [
            NodeAt(0, as: DERSequence.self),
            NodeAt(0, as: DERSequence.self),
            NodeAt(5, as: DERSequence.self),
            NodeAt(1, as: DERSet.self),
            NodeAt(0, as: DERSequence.self) { sequence in
                sequence.isObject(.AttributeType.commonName)
            },
            NodeAt(1, as: DERUTF8String.self)
        ], as: DERUTF8String.self)?.value

        return name ?? "N/A"
    }
}
