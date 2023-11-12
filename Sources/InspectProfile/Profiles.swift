import Foundation

public struct Profiles: Codable, Hashable {

    public let profiles: [Profile]

    public let profilesByURL: [URL: Profile]

    public init(_ profilesByURL: [URL: Profile] = [:]) {
        self.profilesByURL = profilesByURL
        self.profiles = profilesByURL.values.sorted(by: { a, b in a.name < b.name })
    }
}
