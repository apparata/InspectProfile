import Foundation

enum SemanticsError: Error {
    case formatNotRecognized
    case unknownSemanticNode
}

class Semantics {

    func processNodes(_ nodes: [DERNode]) throws -> [SemanticNode] {
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

    private func processNode(_ node: DERNode) throws -> SemanticNode {
        if let signedDataNode = processSignedDataNode(node) {
            return try SemanticNode(signedDataNode)
        }
        throw SemanticsError.formatNotRecognized
    }

    private func processSignedDataNode(_ node: DERNode) -> SignedDataNode? {
        if case .sequence(let sequence) = node {
            if let firstNode = sequence.children.first?.node {
                if let objectIdentifier = firstNode as? DERObjectIdentifier {
                    if objectIdentifier.objectID == SignedDataNode.objectID {
                        let signedDataNode = SignedDataNode(
                            objectID: objectIdentifier.objectID,
                            children: nil
                        )

                        return signedDataNode
                    }
                }

            }
        }
        return nil
    }
}
