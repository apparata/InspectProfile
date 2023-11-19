import Foundation

enum SemanticsError: Error {
    case formatNotRecognized
    case unknownSemanticNode
}

class Semantics {

    func processNodes(_ nodes: [Node]) throws -> [Node] {
        let semanticNodes = nodes.compactMap { node in
            do {
                let semanticNode = try processNode(node)
                return semanticNode
            } catch {
                dump(error)
                return nil
            }
        }
        return semanticNodes
    }

    private func processNode(_ node: Node) throws -> Node {
        guard let signedDataNode = processPKCS7SignedDataNode(node) else {
            throw SemanticsError.formatNotRecognized
        }
        return signedDataNode
    }

    private func processPKCS7SignedDataNode(_ node: Node) -> Node? {
        guard node.isObject(PKCS7SignedDataNode.objectID) else {
            return nil
        }

        guard let constructed = node[1, as: DERContextDefinedConstructed.self] else {
            return nil
        }

        guard let sequence = constructed[0, as: DERSequence.self] else {
            return nil
        }

        guard let dataSequence = sequence[2, as: DERSequence.self] else {
            return nil
        }

        guard let dataNode = processPKCS7DataNode(.sequence(dataSequence)) else {
            return nil
        }

        let signedDataNode = PKCS7SignedDataNode(children: [dataNode])

        return .pkcs7SignedData(signedDataNode)
    }

    private func processPKCS7DataNode(_ node: Node) -> Node? {
        guard node.isObject(PKCS7DataNode.objectID) else {
            return nil
        }

        guard let constructed = node[1, as: DERContextDefinedConstructed.self] else {
            return nil
        }

        guard let octetString = constructed[0, as: DEROctetString.self] else {
            return nil
        }

        var dataNode = PKCS7DataNode(children: [])

        if let plistNode = processPlistNode(octetString.value) {
            dataNode.children?.append(plistNode)
        }

        return .pkcs7Data(dataNode)
    }

    private func processPlistNode(_ data: Data) -> Node? {
        guard let plistNode = ProfilePlistNode(data: data) else {
            return nil
        }
        return .profilePlist(plistNode)
    }
}
