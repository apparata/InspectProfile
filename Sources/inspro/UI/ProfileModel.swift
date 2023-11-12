import SwiftUI
import InspectProfile

@Observable class ProfilesModel {

    var profiles: Profiles?

    init() {
    }

    func parseProfiles(at urls: [URL]) throws {
        let profiles = try urls.map { url in
            try InspectProfile.inspectProfile(at: url)
        }
        self.profiles = Profiles(profiles)
    }
}
