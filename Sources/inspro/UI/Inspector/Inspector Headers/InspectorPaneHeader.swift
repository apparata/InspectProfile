import SwiftUI

struct InspectorPaneHeader: View {

    let inspectable: any Inspectable

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            ViewThatFits {

                HStack(spacing: 0) {
                    Image(systemName: inspectable.systemIcon)
                        .fontWeight(.medium)
                        .foregroundStyle(inspectable.iconColor)
                        .padding(.trailing, 4)
                    Text(inspectable.type)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .truncationMode(.tail)
                        .lineLimit(1)
                    Spacer()
                    Text(.init(inspectable.description))
                        .foregroundStyle(.secondary)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                .padding(.horizontal, 16)
                .padding(.vertical)

                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Image(systemName: inspectable.systemIcon)
                            .fontWeight(.medium)
                            .foregroundStyle(inspectable.iconColor)
                            .padding(.trailing, 4)
                        Text(inspectable.type)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .truncationMode(.tail)
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack {
                        Text(.init(inspectable.description))
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
