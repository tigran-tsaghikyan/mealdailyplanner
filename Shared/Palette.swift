import SwiftUI
import UIKit

// Soft redesign palette, shared by the app and the widget.
// Each token resolves to its light or dark value from the current trait collection.
enum Palette {
    static let background = dynamic(0xF6F5F2, 0x141311)
    static let card = dynamic(0xFFFFFF, 0x1F1E1B)
    static let fill = dynamic(0xF6F5F2, 0x2A2825)
    static let border = dynamic(0xECEAE5, 0x2A2825)
    static let divider = dynamic(0xF4F1EC, 0x2A2825)

    static let text = dynamic(0x1A1917, 0xF5F4F2)
    static let textSecondary = dynamic(0x8A8782, 0x98948D)
    static let textTertiary = dynamic(0xB8B4AD, 0x5E5B54)

    static let accent = Color(hex: 0xFF9F5A)
    static let accentStrong = dynamic(0xC2570E, 0xFF9F5A)
    static let accentText = dynamic(0xC2570E, 0xFFC59A)
    static let accentSoft = dynamic(light: UIColor(hex: 0xFFEBDC), dark: UIColor(hex: 0xFF9F5A, alpha: 0.16))
    static let highlight = dynamic(0xFFF4EA, 0x2A2119)
    static let paywallCard = dynamic(0xFFFFFF, 0x2A2119)
    static let chipOnHighlight = dynamic(0xFFFFFF, 0x2A2825)
    static let badge = dynamic(light: UIColor(hex: 0xFFE2CC), dark: UIColor(hex: 0xFF9F5A, alpha: 0.22))
    static let badgeText = dynamic(0xB4530A, 0xFFC59A)
    static let timeline = dynamic(light: UIColor(hex: 0xF6DCC6), dark: UIColor(hex: 0xFF9F5A, alpha: 0.22))
    static let dotInactive = dynamic(0xDEDCD6, 0x3A3835)

    static let cta = Color(hex: 0xFFB27A)
    static let ctaText = Color(hex: 0x3A1F0A)

    static let cardShadow = dynamic(light: UIColor(red: 60 / 255, green: 45 / 255, blue: 30 / 255, alpha: 0.05), dark: .clear)
    static let highlightShadow = dynamic(light: UIColor(red: 1, green: 140 / 255, blue: 66 / 255, alpha: 0.10), dark: UIColor(white: 0, alpha: 0.25))

    private static func dynamic(_ light: UInt32, _ dark: UInt32) -> Color {
        dynamic(light: UIColor(hex: light), dark: UIColor(hex: dark))
    }

    private static func dynamic(light: UIColor, dark: UIColor) -> Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? dark : light })
    }
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha
        )
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(UIColor(hex: hex))
    }
}
