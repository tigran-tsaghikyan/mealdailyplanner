import SwiftUI

struct PaywallView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager

    private let privacyPolicyURL = URL(string: "https://tigran-tsaghikyan.github.io/mealdailyplanner/privacy-policy.html")!
    private let termsOfUseURL = URL(string: "https://tigran-tsaghikyan.github.io/mealdailyplanner/terms-of-use.html")!

    private let features = [
        "Daily breakfast, lunch & dinner plans",
        "One combined cooking flow per day",
        "Portions scaled to your family"
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Palette.accentSoft)
                        .frame(width: 76, height: 76)
                    Image(systemName: "fork.knife")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(Palette.accent)
                }
                .padding(.bottom, 20)

                Text("Keep your meals planned")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .tracking(-0.5)
                    .foregroundColor(Palette.text)
                    .multilineTextAlignment(.center)

                Text("Your free trial has ended. Subscribe to keep generating a fresh daily plan for the whole family.")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(Palette.textSecondary)
                    .lineSpacing(3)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
                    .padding(.top, 10)

                // Subscription details (required by App Store 3.1.2c)
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Premium")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Palette.text)
                        Text("Auto-renews monthly · cancel anytime")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Palette.textSecondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(subscriptionManager.product?.displayPrice ?? "$3.99")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Palette.text)
                        Text("per month")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(Palette.textSecondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .softCard(
                    Palette.paywallCard,
                    shadow: Palette.highlightShadow,
                    shadowRadius: 11,
                    shadowY: 6
                )
                .padding(.top, 28)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(features, id: \.self) { feature in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Palette.accent)
                            Text(feature)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(Palette.text)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 18)

                // Subscribe button
                Button {
                    Task { await subscriptionManager.purchase() }
                } label: {
                    Text("Subscribe")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(Palette.ctaText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(
                            Capsule()
                                .fill(Palette.cta)
                                .shadow(color: Palette.accent.opacity(0.22), radius: 12, y: 10)
                        )
                }
                .buttonStyle(.plain)
                .disabled(subscriptionManager.isLoading)
                .padding(.top, 28)

                // Restore purchases
                Button {
                    Task { await subscriptionManager.restorePurchases() }
                } label: {
                    Text("Restore Purchases")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(Palette.textSecondary)
                }
                .padding(.top, 14)

                // Subscription terms text (required by App Store 3.1.2c)
                Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period.")
                    .font(.system(size: 10.5, design: .rounded))
                    .foregroundColor(Palette.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)

                // Legal links (required by App Store 3.1.2c)
                HStack(spacing: 14) {
                    Link("Privacy Policy", destination: privacyPolicyURL)
                    Text("·")
                        .foregroundColor(Palette.textTertiary)
                    Link("Terms of Use", destination: termsOfUseURL)
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Palette.accentText)
                .tint(Palette.accentText)
                .padding(.top, 8)
            }
            .padding(.horizontal, 24)
            .padding(.top, 50)
            .padding(.bottom, 40)
        }
        .background(Palette.background.ignoresSafeArea())
    }
}
