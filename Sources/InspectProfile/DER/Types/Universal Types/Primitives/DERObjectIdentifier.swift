import Foundation

public struct DERObjectIdentifier: DERPrimitive {
    public let id: UUID
    public let tag: DERTag
    public let type: String
    public let objectID: DERObjectID
    public let description: String

    public init(tag: DERTag, objectID: DERObjectID) {
        self.id = UUID()
        self.tag = tag
        self.type = "Object Identifier"
        self.objectID = objectID
        self.description = "`\(objectID.description)`"
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(tag)
        hasher.combine(type)
        hasher.combine(objectID)
    }
}
