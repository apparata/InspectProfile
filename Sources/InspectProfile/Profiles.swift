import Foundation

public struct Profiles: Codable, Hashable {
    public let profiles: [Profile]

    public init(_ profiles: [Profile]) {
        self.profiles = profiles.sorted(by: { a, b in a.name < b.name })
    }
}
