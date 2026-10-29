import SwiftUI

struct CookingFlowView: View {
    let cookingFlow: [CookingStep]
    let totalTime: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.iconRadius, style: .continuous)
                        .fill(Palette.card)
                        .frame(width: 34, height: 34)
                    Image(systemName: "flame")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Palette.accent)
                }

                Text("Cooking plan")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(Palette.textSecondary)

                Spacer()

                Text("\(totalTime) min total")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Palette.badgeText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Palette.card))
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.top, AppTheme.spacingMD)
            .padding(.bottom, 4)

            Text("Cook all three meals in one session — longest first.")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(Palette.textSecondary)
                .padding(.horizontal, AppTheme.spacingMD)
                .padding(.top, 6)
                .padding(.bottom, 10)

            // Steps timeline
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(cookingFlow.enumerated()), id: \.element.id) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        // Timeline dot + line
                        VStack(spacing: 0) {
                            Circle()
                                .fill(Palette.accent)
                                .frame(width: 8, height: 8)
                                .padding(.top, 5)
                            if index < cookingFlow.count - 1 {
                                Rectangle()
                                    .fill(Palette.timeline)
                                    .frame(width: 1)
                                    .frame(maxHeight: .infinity)
                            }
                        }
                        .frame(width: 8)

                        // Content
                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.description)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(Palette.text)
                                .fixedSize(horizontal: false, vertical: true)

                            Text("\(step.durationMinutes) min")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Palette.textSecondary)
                        }
                        .padding(.bottom, index < cookingFlow.count - 1 ? 14 : 0)

                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, AppTheme.spacingMD)
            .padding(.top, 4)
            .padding(.bottom, 18)
        }
        .softCard(Palette.highlight, shadow: .clear)
    }
}
