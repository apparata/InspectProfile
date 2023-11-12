import SwiftUI
import InspectProfile

@Observable class ProfilesModel {

    private(set) var profiles: Profiles?

    init() {
        profiles = nil
    }

    func parseProfiles(at urls: [URL]) throws {

        var profilesByURL = self.profiles?.profilesByURL ?? [:]

        for url in urls {
            let profile = try InspectProfile.inspectProfile(at: url)
            profilesByURL[url] = profile
        }

        self.profiles = Profiles(profilesByURL)
    }

    func deleteProfile(_ profile: Profile) {
        guard var profilesByURL = self.profiles?.profilesByURL else {
            return
        }

        profilesByURL = profilesByURL.filter { url, existingProfile in
            existingProfile.id != profile.id
        }

        self.profiles = Profiles(profilesByURL)
    }

    func deleteAllProfiles() {
        self.profiles = nil
    }
}
