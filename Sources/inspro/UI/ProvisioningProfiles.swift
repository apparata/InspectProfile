import SwiftUI
import InspectProfile

struct ProvisioningProfiles: View {

    @State private var profilesModel = ProfilesModel()

    @State private var selectedProfile: Profile?

    @State private var selectedNode: DERNode?

    @State private var selectedSemanticNode: SemanticNode?

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
                        } else if inspectorMode == .data, let profile = selectedProfile {
                            inspectData(of: node, data: profile.dataForNode(node))
                        }
                    }
                } else if outlineMode == .semantic {
                    if let node = selectedSemanticNode {
                        inspectSemanticProperties(of: node)
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

    @ViewBuilder private func inspectProperties(of node: DERNode) -> some View {
        switch node {
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
            UnknownPane(node: node)
        }
    }

    @ViewBuilder private func inspectData(of node: DERNode, data: Data) -> some View {
        RawDataPane(node: node, data: data)
    }

    @ViewBuilder private func inspectSemanticProperties(of node: SemanticNode) -> some View {
        Text(node.type)
    }
}

struct NodePaneHeader: View {

    let node: DERNode

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            ViewThatFits {

                HStack(spacing: 0) {
                    Image(systemName: node.systemIcon)
                        .fontWeight(.medium)
                        .foregroundStyle(node.iconColor)
                        .padding(.trailing, 4)
                    Text(node.type)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .truncationMode(.tail)
                        .lineLimit(1)
                    Spacer()
                    Text(.init(node.description))
                        .foregroundStyle(.secondary)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                .padding(.horizontal, 16)
                .padding(.vertical)

                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Image(systemName: node.systemIcon)
                            .fontWeight(.medium)
                            .foregroundStyle(node.iconColor)
                            .padding(.trailing, 4)
                        Text(node.type)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .truncationMode(.tail)
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack {
                        Text(.init(node.description))
                            .foregroundStyle(.secondary)
                            .opacity(0.6)
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                .padding(.vertical)
            }

            Divider()
        }
    }
}

// MARK: - Inspector Mode

enum InspectorMode: Identifiable, Hashable {
    case properties
    case data

    var id: Self { self }
}
