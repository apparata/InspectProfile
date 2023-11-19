import SwiftUI

struct ProfilesWindow: Scene {

    var body: some Scene {
        WindowGroup {
            ProvisioningProfiles()
                .frame(minWidth: 400, maxWidth: .infinity,
                       minHeight: 300, maxHeight: .infinity)
        }
        .windowResizability(.automatic)
        .commands {
            AppCommands()
        }
    }
}
