import SwiftUI
import InspectProfile

struct ProvisioningProfiles: View {

    @State private var profilesModel = ProfilesModel()

    @State private var selectedProfile: Profile?

    @State private var selectedNode: Node?

    @State private var selectedSemanticNode: Node?

    @State private var inspectorMode: InspectorMode = .properties

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
            VStack(spacing: 0) {
                if outlineMode == .raw {
                    if let node = selectedNode {
                        if inspectorMode == .properties {
                            inspectProperties(of: node)
                        } else if inspectorMode == .data, let profile = selectedProfile, let data = profile.dataForNode(node) {
                            inspectData(of: node, data: data)
                        }
                    }
                } else if outlineMode == .semantic {
                    if let node = selectedSemanticNode {
                        inspectProperties(of: node)
                    }
                }
            }
            .inspectorColumnWidth(min: 324, ideal: 324, max: 324)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    if outlineMode == .raw {
                        HStack {
                            Button {
                                inspectorMode = .properties
                            } label: {
                                Label("Properties", systemImage: "list.bullet")
                                    .foregroundStyle(
                                        inspectorMode == .properties ? Color.blue : Color.secondary
                                    )
                            }
                            Button {
                                inspectorMode = .data
                            } label: {
                                Label("Data", systemImage: "number")
                                    .foregroundStyle(
                                        inspectorMode == .data ? Color.blue : Color.secondary
                                    )
                            }
                        }
                    }
                }
                ToolbarItem {
                    Spacer()
                }
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

    @ViewBuilder private func inspectProperties(of node: Node) -> some View {
        switch node {

        // --------------------------------------------------------------------
        // MARK: DER Nodes
        // --------------------------------------------------------------------

        case .contextDefinedConstructed(let constructed):
            ContextDefinedConstructedPane(
                node: node,
                contextDefinedConstructed: constructed
            )
        case .contextDefinedPrimitive(let primitive):
            ContextDefinedPrimitivePane(
                node: node,
                contextDefinedPrimitive: primitive
            )

        case .sequence(let sequence):
            SequencePane(node: node, sequence: sequence)
        case .set(let set):
            SetPane(node: node, set: set)

        case .bitString(let bitString):
            BitStringPane(node: node, bitString: bitString)
        case .boolean(let value):
            BooleanPane(node: node, boolean: value)
        case .integer(let value):
            IntegerPane(node: node, integer: value)
        case .null(let null):
            NullPane(node: node, null: null)
        case .objectIdentifier(let objectIdentifier):
            ObjectIdentifierPane(node: node, objectIdentifier: objectIdentifier)
        case .octetString(let octetString):
            OctetStringPane(node: node, octetString: octetString)
        case .printableString(let printableString):
            PrintableStringPane(node: node, printableString: printableString)
        case .utcTime(let utcTime):
            UTCTimePane(node: node, utcTime: utcTime)
        case .utf8String(let utf8String):
            UTF8StringPane(node: node, utf8String: utf8String)

        case .unknown:
            UnknownPane(inspectable: node)

        // --------------------------------------------------------------------
        // MARK: Semantic Nodes
        // --------------------------------------------------------------------

        case .pkcs7SignedData:
            UnknownPane(inspectable: node)
        case .pkcs7Data:
            UnknownPane(inspectable: node)
        case .profilePlist(let plist):
            ProfilePlistPane(node: node, plist: plist.profilePlist)
        case .entitlements(let entitlements):
            EntitlementsPane(node: node, entitlements: entitlements.entitlements)
        case .developerCertificates(_):
            UnknownPane(inspectable: node)
        case .developerCertificate(let certificate):
            DeveloperCertificatePane(inspectable: node, certificate: certificate.certificate)
        }
    }

    @ViewBuilder private func inspectData(of node: Node, data: Data) -> some View {
        RawDataPane(inspectable: node, data: data)
    }
}

// MARK: - Inspector Mode

enum InspectorMode: Identifiable, Hashable {
    case properties
    case data

    var id: Self { self }
}
