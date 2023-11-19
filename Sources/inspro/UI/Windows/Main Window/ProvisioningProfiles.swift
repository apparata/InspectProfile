import SwiftUI
import InspectProfile

struct ProvisioningProfiles: View {

    @State private var profilesModel = ProfilesModel()

    @State private var selectedProfile: Profile?

    @State private var selectedNode: Node?

    @State private var selectedSemanticNode: Node?

    @State private var isPresentingImporter: Bool = false

    @State private var outlineMode: OutlineMode = .raw

    init() {
        //
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                if let profiles = profilesModel.profiles?.profiles {
                    List(selection: $selectedProfile) {
                        Section("Profiles") {
                            ForEach(profiles) { profile in
                                profileEntry(profile)
                            }
                        }
                    }
                    .listStyle(.sidebar)
                    .safeAreaInset(edge: .bottom) {
                        DropArea(model: profilesModel)
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("No profiles")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .safeAreaInset(edge: .bottom) {
                        DropArea(model: profilesModel)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: selectedProfile) { _, profile in
                selectedNode = nil
            }
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    Button {
                        profilesModel.deleteAllProfiles()
                        selectedProfile = nil
                        selectedNode = nil
                    } label: {
                        Label("Remove all", systemImage: "trash")
                    }
                }
                ToolbarItem {
                    Button {
                        isPresentingImporter = true
                    } label: {
                        Label("Import...", systemImage: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $isPresentingImporter,
                allowedContentTypes: [.data],
                allowsMultipleSelection: true) { result in
                    switch result {
                    case .success(let urls):
                        do {
                            try profilesModel.parseProfiles(at: urls)
                        } catch {
                            dump(error)
                        }
                    case .failure(let error):
                        dump(error)
                    }
                }

        } detail: {
            if let profile = selectedProfile {
                MobileProvisionOutline(
                    profile: profile,
                    selectedNode: $selectedNode,
                    selectedSemanticNode: $selectedSemanticNode,
                    outlineMode: $outlineMode
                )
            }
        }
        .inspector(isPresented: .constant(true)) {
            if let node = selectedNode ?? selectedSemanticNode, let profile = selectedProfile {
                NodeInspector(
                    node: node,
                    profile: profile,
                    outlineMode: outlineMode
                )
            }
        }
    }

    @ViewBuilder private func profileEntry(_ profile: Profile) -> some View {
        HStack(spacing: 0) {
            Image(systemName: profile.url?.pathExtension == "mobileprovision" ? "doc.badge.gearshape" : "doc")
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
                .padding(.trailing, 8)
            Text(profile.name)
        }
        .tag(profile)
        .contextMenu {
            Button {
                profilesModel.deleteProfile(profile)
                if profile == selectedProfile {
                    selectedProfile = nil
                    selectedNode = nil
                }
            } label: {
                Label("Remove", systemImage: "trash")
            }
        }
    }
}
