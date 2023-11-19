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
        guard let sequence0 = nodes.first?.node as? DERSequence else {
            return "Unknown"
        }
        guard let sequence1 = sequence0[0, as: DERSequence.self] else {
            return "Unknown"
        }
        guard let sequence2 = sequence1[5, as: DERSequence.self] else {
            return "Unknown"
        }
        guard let set = sequence2[1, as: DERSet.self] else {
            return "Unknown"
        }
        guard let sequence3 = set[0, as: DERSequence.self] else {
            return "Unknown"
        }
        let commonNameID = DERObjectID("2.5.4.3", name: "Attribute Type: Common Name")
        guard sequence3.isObject(commonNameID) else {
            return "Unknown"
        }
        guard let string = sequence3[1, as: DERUTF8String.self] else {
            return "Unknown"
        }
        let value = string.value
        return value
    }
}
