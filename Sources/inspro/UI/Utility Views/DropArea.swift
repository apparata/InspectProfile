import SwiftUI
import InspectProfile

struct DropArea: View {

    @Bindable var model: ProfilesModel

    @State var isTargeted: Bool = false

    @State var isShowingError: Bool = false
    @State var error: Error?

    var body: some View {
        VStack {
            dropArea("Drop .mobileprovision\nfiles here.")
                .frame(height: 140)
                .frame(minWidth: 220, maxWidth: .infinity)
                .dropDestination(for: URL.self) { urls, location in
                    _ = location
                    guard !urls.isEmpty else {
                        return true
                    }
                    Task {
                        do {
                            try model.parseProfiles(at: urls)
                        } catch {
                            dump(error)
                            self.error = error
                            isShowingError = true
                        }
                    }
                    return true
                } isTargeted: { isTargeted in
                    self.isTargeted = isTargeted
                }
            HStack {
                AlwaysOnTopCheckbox()
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding()
        .background(AlwaysOnTop())
        .alert(error?.localizedDescription ?? "Error: Something went wrong.", isPresented: $isShowingError) {
            Button("OK", role: .cancel) { }
        }
    }

    @ViewBuilder func dropArea(_ title: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isTargeted ? Color.white.opacity(0.8) : Color.white.opacity(0.2), style: StrokeStyle(lineWidth: 2, dash: [8, 4], dashPhase: 0))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text(title)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}
