import SwiftUI

struct ScalingInfoView: View {
    let profile: UserProfile

    @State private var showInfo = false

    private var adultCount: Int {
        profile.familyMembers.filter { !$0.isChild }.count
    }

    private var childCount: Int {
        profile.familyMembers.filter { $0.isChild }.count
    }

    var body: some View {
        Button {
            showInfo.toggle()
        } label: {
            Image(systemName: "info.circle")
                .font(.caption)
                .foregroundColor(AppTheme.secondary)
        }
        .popover(isPresented: $showInfo) {
            VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                Text("Scaling Formula")
                    .font(AppTheme.headlineFont)

                Text("Base portion = 1 person")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondary)

                Text("Adults: \(adultCount) x 1.0 = \(String(format: "%.1f", Double(adultCount)))")
                    .font(AppTheme.bodyFont)

                if childCount > 0 {
                    Text("Children: \(childCount) x 0.5 = \(String(format: "%.1f", Double(childCount) * 0.5))")
                        .font(AppTheme.bodyFont)
                }

                Divider()

                Text("Multiplier: \(String(format: "%.1f", profile.scalingMultiplier))x")
                    .font(AppTheme.headlineFont)
            }
            .padding()
            .presentationCompactAdaptation(.popover)
        }
    }
}
