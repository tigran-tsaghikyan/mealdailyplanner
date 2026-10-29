import SwiftUI

enum AppTheme {
    // MARK: - Colors
    static let primary = Palette.text
    static let background = Palette.background
    static let secondary = Palette.textSecondary
    static let separator = Palette.divider

    // MARK: - Typography (rounded system font)
    static let largeTitleFont = Font.system(size: 30, weight: .bold, design: .rounded)
    static let titleFont = Font.system(size: 21, weight: .semibold, design: .rounded)
    static let headlineFont = Font.system(size: 16, weight: .semibold, design: .rounded)
    static let bodyFont = Font.system(size: 15, weight: .regular, design: .rounded)
    static let captionFont = Font.system(size: 13, weight: .regular, design: .rounded)

    // MARK: - Spacing
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 24
    static let spacingXL: CGFloat = 32

    // MARK: - Corners
    static let cardRadius: CGFloat = 28
    static let tileRadius: CGFloat = 22
    static let iconRadius: CGFloat = 14
}

// MARK: - Appearance

enum AppearanceMode: String, CaseIterable, Identifiable {
    case light, dark, auto

    static let storageKey = "appearanceMode"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .auto: return "Auto"
        }
    }

    var icon: String? {
        switch self {
        case .light: return "sun.max"
        case .dark: return "moon"
        case .auto: return nil
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .auto: return nil
        }
    }
}

// MARK: - Card Styling

extension View {
    /// Rounded card surface used throughout the soft redesign.
    func softCard(
        _ fill: Color = Palette.card,
        radius: CGFloat = AppTheme.cardRadius,
        shadow: Color = Palette.cardShadow,
        shadowRadius: CGFloat = 9,
        shadowY: CGFloat = 4
    ) -> some View {
        background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(fill)
                .shadow(color: shadow, radius: shadowRadius, x: 0, y: shadowY)
        )
    }

    /// Keeps scrolled content from showing through the status bar.
    func statusBarScrim() -> some View {
        safeAreaInset(edge: .top, spacing: 0) {
            Color.clear
                .frame(height: 0)
                .background(Palette.background.opacity(0.94))
        }
    }

    /// Small header label above a card ("Family", "Allergies", …) with an optional count.
    func sectionHeader(_ title: String, trailing: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Palette.textSecondary)
                Spacer()
                if let trailing {
                    Text(trailing)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Palette.textSecondary)
                }
            }
            .padding(.horizontal, 4)

            self
        }
    }
}

// MARK: - Pill segmented control

struct PillSegment<Value: Hashable>: View {
    struct Option {
        let value: Value
        let title: String
        var icon: String? = nil
        var selectedFill: Color = Palette.card
        var selectedText: Color = Palette.text
    }

    let options: [Option]
    let selection: Value
    let onSelect: (Value) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.value) { option in
                let isSelected = option.value == selection
                Button {
                    onSelect(option.value)
                } label: {
                    HStack(spacing: 5) {
                        if let icon = option.icon {
                            Image(systemName: icon)
                                .font(.system(size: 11, weight: .semibold))
                        }
                        Text(option.title)
                            .lineLimit(1)
                    }
                    .font(.system(size: 12, weight: isSelected ? .semibold : .medium, design: .rounded))
                    .foregroundColor(isSelected ? option.selectedText : Palette.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(isSelected ? option.selectedFill : .clear)
                            .shadow(color: isSelected ? Color.black.opacity(0.08) : .clear, radius: 1.5, y: 1)
                    )
                    .contentShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Capsule().fill(Palette.fill))
        .fixedSize()
    }
}

// MARK: - Flow layout (wrapping chips)

struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(subviews, width: proposal.width ?? .infinity)
        let height = rows.map(\.height).reduce(0, +) + spacing * CGFloat(max(rows.count - 1, 0))
        let width = rows.map(\.width).max() ?? 0
        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in arrange(subviews, width: bounds.width) {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }

    private struct Row {
        var indices: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func arrange(_ subviews: Subviews, width: CGFloat) -> [Row] {
        var rows: [Row] = [Row()]
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let extra = rows[rows.count - 1].indices.isEmpty ? size.width : size.width + spacing
            if rows[rows.count - 1].width + extra > width, !rows[rows.count - 1].indices.isEmpty {
                rows.append(Row())
            }
            let isFirst = rows[rows.count - 1].indices.isEmpty
            rows[rows.count - 1].indices.append(index)
            rows[rows.count - 1].width += isFirst ? size.width : size.width + spacing
            rows[rows.count - 1].height = max(rows[rows.count - 1].height, size.height)
        }
        return rows.filter { !$0.indices.isEmpty }
    }
}
