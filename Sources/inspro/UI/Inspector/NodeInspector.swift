import SwiftUI
import InspectProfile

struct NodeInspector: View {

    let node: Node

    let profile: Profile

    let outlineMode: OutlineMode

    @State private var inspectorMode: InspectorMode = .properties

    var body: some View {
        VStack(spacing: 0) {
            if outlineMode == .raw {
                if inspectorMode == .properties {
                    inspectProperties(of: node)
                } else if inspectorMode == .data, let data = profile.dataForNode(node) {
                    inspectData(of: node, data: data)
                }
            } else if outlineMode == .semantic {
                inspectProperties(of: node)
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
        case .derProfile(let profile):
            DERProfilePane(inspectable: node, data: profile.data)
        case .entitlements(let entitlements):
            EntitlementsPane(node: node, entitlements: entitlements.entitlements)
        case .provisionedDevices(let devices):
            ProvisionedDevicesPane(node: node, devices: devices.devices)
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
