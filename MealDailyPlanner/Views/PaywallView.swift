import SwiftUI

struct PaywallView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager

    var body: some View {
        VStack(spacing: AppTheme.spacingLG) {
            Spacer()

            Image(systemName: "fork.knife.circle")
                .font(.system(size: 64))
                .foregroundColor(AppTheme.primary)

            Text("Meal Daily Planner")
                .font(AppTheme.largeTitleFont)

            Text("Your free trial has ended.\nSubscribe to continue generating daily meal plans.")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.spacingLG)

            VStack(spacing: AppTheme.spacingSM) {
                if let product = subscriptionManager.product {
                    Text("\(product.displayPrice) / month")
                        .font(AppTheme.titleFont)
                } else {
                    Text("$3.99 / month")
                        .font(AppTheme.titleFont)
                }

                Text("Cancel anytime")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondary)
            }

            Button {
                Task { await subscriptionManager.purchase() }
            } label: {
                Text("Subscribe")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.primary)
                    .cornerRadius(12)
            }
            .disabled(subscriptionManager.isLoading)
            .padding(.horizontal, AppTheme.spacingLG)

            Button {
                Task { await subscriptionManager.restorePurchases() }
            } label: {
                Text("Restore Purchases")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondary)
            }

            Spacer()
        }
    }
}
