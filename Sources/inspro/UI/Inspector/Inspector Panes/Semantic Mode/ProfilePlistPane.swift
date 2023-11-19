import SwiftUI
import InspectProfile

struct ProfilePlistPane: View {

    let node: Node

    let plist: ProfilePlist

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            InspectorSectionHeader("Info")
            GridRow {
                InspectorLabel("Name")
                InspectorTextField(plist.name)
            }
            GridRow {
                InspectorLabel("App ID Name")
                InspectorTextField(plist.appIDName)
            }
            GridRow {
                InspectorLabel("App ID Prefix")
                InspectorTextField(plist.applicationIdentifierPrefix.joined(separator: ", "))
            }
            InspectorDivider()
            GridRow {
                InspectorLabel("Team Name")
                InspectorTextField(plist.teamName)
            }
            GridRow {
                InspectorLabel("Team ID")
                InspectorTextField(plist.teamIdentifier.joined(separator: ", "))
            }
            InspectorDivider()
            GridRow {
                InspectorLabel("Created at")
                InspectorDateField(plist.creationDate)
            }
            GridRow {
                InspectorLabel("Expires at")
                InspectorDateField(plist.expirationDate)
            }
            GridRow {
                InspectorLabel("Time to Live")
                InspectorNumericField(plist.timeToLive)
            }
            InspectorDivider()
            GridRow {
                InspectorLabel("Platform")
                InspectorTextField(plist.platform.joined(separator: ", "))
            }
            GridRow {
                InspectorLabel("Xcode Managed")
                InspectorTextField(plist.isXcodeManaged ? "Yes" : "No")
            }
            GridRow {
                InspectorLabel("Version")
                InspectorNumericField(plist.version)
            }
            GridRow {
                InspectorLabel("UUID")
                InspectorTextField(plist.uuid)
            }
        }
    }
}
/*
let developerCertificates: [Data]
let DEREncodedProfile: Data
*/
