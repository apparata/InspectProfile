import SwiftUI
import InspectProfile

struct ProvisioningProfiles: View {

    @State private var profilesModel = ProfilesModel()

    @State private var selectedProfile: Profile?

    @State private var selectedNode: DERNode?

    @State private var selectedInspectorPane: Int = 0

    init() {
        //
    }

    var body: some View {
        NavigationSplitView {
            if let profiles = profilesModel.profiles?.profiles {
                List(selection: $selectedProfile) {
                    Section("Profiles") {
                        ForEach(profiles) { profile in
                            HStack(spacing: 0) {
                                Image(systemName: "doc.badge.gearshape")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 4)
                                    .padding(.trailing, 8)
                                Text(profile.name)
                            }
                            .tag(profile)
                        }
                    }
                }
                .listStyle(.sidebar)
                .safeAreaInset(edge: .bottom) {
                    DropView(model: profilesModel)
                }
            } else {
                VStack {
                    Spacer()
                    Text("No profiles")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .safeAreaInset(edge: .bottom) {
                    DropView(model: profilesModel)
                }
            }
        } detail: {
            if let profile = selectedProfile {
                MobileProvisionOutline(profile: profile, selectedNode: $selectedNode)
            }
        }
        .inspector(isPresented: .constant(true)) {
            VStack(spacing: 0) {
                if let node = selectedNode {
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
            }
            .inspectorColumnWidth(min: 324, ideal: 324, max: 324)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    HStack {
                        Button {
                            selectedInspectorPane = 0
                        } label: {
                            Label("Details", systemImage: "rectangle.and.text.magnifyingglass")
                                .foregroundStyle(
                                    selectedInspectorPane == 0 ? Color.blue : Color.secondary
                                )
                        }
                        Button {
                            selectedInspectorPane = 1
                        } label: {
                            Label("Changes", systemImage: "clock")
                                .foregroundStyle(
                                    selectedInspectorPane == 1 ? Color.blue : Color.secondary
                                )
                        }
                    }
                }
                ToolbarItem {
                    Spacer()
                }
            }
        }
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

#Preview {
    ProvisioningProfiles()
}
