import SwiftUI

struct CookingFlowView: View {
    let cookingFlow: [CookingStep]
    let totalTime: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.secondary)

                Text("Cooking Plan")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.secondary)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .font(.system(size: 11))
                    Text("\(totalTime) min total")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(AppTheme.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(6)
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.top, AppTheme.spacingMD)
            .padding(.bottom, 14)

            // Steps timeline
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(cookingFlow.enumerated()), id: \.element.id) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        // Timeline dot + line
                        VStack(spacing: 0) {
                            Circle()
                                .fill(AppTheme.primary)
                                .frame(width: 8, height: 8)
                                .padding(.top, 5)
                            if index < cookingFlow.count - 1 {
                                Rectangle()
                                    .fill(Color(.separator))
                                    .frame(width: 1)
                                    .frame(maxHeight: .infinity)
                            }
                        }
                        .frame(width: 8)

                        // Content
                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.description)
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.primary)
                                .fixedSize(horizontal: false, vertical: true)

                            Text("\(step.durationMinutes) min")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.secondary)
                        }
                        .padding(.bottom, index < cookingFlow.count - 1 ? 14 : 0)

                        Spacer()
                    }
                }
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.bottom, AppTheme.spacingMD)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}
