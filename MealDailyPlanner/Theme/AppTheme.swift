import SwiftUI

enum AppTheme {
    // MARK: - Colors
    static let primary = Color.primary
    static let background = Color(UIColor.systemBackground)
    static let secondary = Color(UIColor.secondaryLabel)
    static let separator = Color(UIColor.separator)

    // MARK: - Typography
    static let largeTitleFont = Font.system(size: 28, weight: .bold)
    static let titleFont = Font.system(size: 22, weight: .bold)
    static let headlineFont = Font.system(size: 17, weight: .semibold)
    static let bodyFont = Font.system(size: 15, weight: .regular)
    static let captionFont = Font.system(size: 13, weight: .regular)

    // MARK: - Spacing
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 24
    static let spacingXL: CGFloat = 32
}
