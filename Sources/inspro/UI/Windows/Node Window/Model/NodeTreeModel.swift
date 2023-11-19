import SwiftUI
import InspectProfile

@Observable class NodeTreeModel {

    private(set) var profile: Profile?

    init() {
        profile = nil
    }

    func parseProfile(name: String, data: Data) throws {
        let profile = try InspectProfile.inspectProfile(name: name, data: data)
        self.profile = profile
    }
}
