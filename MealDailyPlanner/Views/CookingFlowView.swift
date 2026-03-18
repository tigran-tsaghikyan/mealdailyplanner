import SwiftUI

struct CookingFlowView: View {
    let cookingFlow: [CookingStep]
    let totalTime: Int

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
            HStack {
                Text("COOKING PLAN")
                    .font(AppTheme.largeTitleFont)
                    .foregroundColor(AppTheme.primary)
                Spacer()
            }

            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption)
                Text("Total: \(totalTime) min")
                    .font(AppTheme.headlineFont)
            }
            .foregroundColor(AppTheme.secondary)

            VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
                ForEach(cookingFlow) { step in
                    HStack(alignment: .top, spacing: AppTheme.spacingSM) {
                        Text("\(step.stepNumber).")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.secondary)
                            .frame(width: 24, alignment: .trailing)
                        Text(step.description)
                            .font(AppTheme.bodyFont)
                        Spacer()
                        Text("\(step.durationMinutes)m")
                            .font(AppTheme.captionFont)
                            .foregroundColor(AppTheme.secondary)
                    }
                }
            }
            .padding(.top, AppTheme.spacingXS)
        }
    }
}
