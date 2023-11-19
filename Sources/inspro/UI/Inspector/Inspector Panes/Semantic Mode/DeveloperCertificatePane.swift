import SwiftUI
import InspectProfile

struct DeveloperCertificatePane: View {

    let inspectable: any Inspectable

    let certificate: DeveloperCertificate

    var body: some View {
        InspectorPaneHeader(inspectable: inspectable)
        InspectorHexDump(data: certificate.data)
    }
}
