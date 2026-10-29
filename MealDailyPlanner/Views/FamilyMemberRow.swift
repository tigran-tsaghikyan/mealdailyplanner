import SwiftUI

struct FamilyMemberRow: View {
    let member: FamilyMember
    let onSetChild: (Bool) -> Void
    let onRename: (String) -> Void
    let onUpdateNutrition: (NutritionMetrics, BodyMetrics) -> Void
    let onClearNutrition: () -> Void
    /// nil when the member can't be removed (family minimum reached).
    var onDelete: (() -> Void)? = nil

    @State private var isEditing = false
    @State private var editText = ""
    @State private var showCalculator = false

    private var initials: String {
        let words = member.name.split(separator: " ")
        guard let first = words.first?.first else { return "?" }
        if words.count > 1, let second = words[1].first {
            return String(first).uppercased() + String(second).uppercased()
        }
        return String(first).uppercased()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: Main row
            HStack(spacing: 12) {
                Text(initials)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(member.isChild ? Palette.accentStrong : Palette.text)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(member.isChild ? Palette.accentSoft : Palette.fill))

                VStack(alignment: .leading, spacing: 1) {
                    if isEditing {
                        TextField("Name", text: $editText, onCommit: {
                            onRename(editText)
                            isEditing = false
                        })
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .textFieldStyle(.plain)
                    } else {
                        Text(member.name)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(Palette.text)
                            .onTapGesture {
                                editText = member.name
                                isEditing = true
                            }
                    }

                    // Portion + nutrition targets (tap to open calculator)
                    Button {
                        showCalculator = true
                    } label: {
                        HStack(spacing: 4) {
                            Text(member.isChild ? "0.5 portion" : "1.0 portion")
                                .foregroundColor(Palette.textSecondary)
                            Text("·")
                                .foregroundColor(Palette.textTertiary)
                            Text(member.nutritionTargets.map { "\(Int($0.calories)) kcal" } ?? "Set targets")
                                .fontWeight(.medium)
                                .foregroundColor(Palette.accentStrong)
                        }
                        .font(.system(size: 12, design: .rounded))
                    }
                    .buttonStyle(.plain)
                }

                Spacer(minLength: 4)

                PillSegment(
                    options: [
                        .init(value: false, title: "Adult"),
                        .init(value: true, title: "Child", selectedFill: Palette.badge, selectedText: Palette.accentStrong)
                    ],
                    selection: member.isChild,
                    onSelect: onSetChild
                )
            }

            // MARK: Nutrition summary strip (visible when targets are set)
            if let targets = member.nutritionTargets {
                HStack(spacing: 12) {
                    NutritionPill(label: "P", value: Int(targets.protein), unit: "g")
                    NutritionPill(label: "F", value: Int(targets.fat), unit: "g")
                    NutritionPill(label: "C", value: Int(targets.carbs), unit: "g")

                    Spacer()

                    Button {
                        onClearNutrition()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 13))
                            .foregroundColor(Palette.textTertiary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.leading, 48)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .contextMenu {
            Button {
                editText = member.name
                isEditing = true
            } label: {
                Label("Rename", systemImage: "pencil")
            }
            Button {
                showCalculator = true
            } label: {
                Label("Nutrition targets", systemImage: "chart.bar")
            }
            if let onDelete {
                Button(role: .destructive, action: onDelete) {
                    Label("Remove", systemImage: "trash")
                }
            }
        }
        .sheet(isPresented: $showCalculator) {
            MetricsCalculatorView(member: member) { nutrition, bodyMetrics in
                onUpdateNutrition(nutrition, bodyMetrics)
            }
        }
    }
}

// MARK: - Nutrition Pill

private struct NutritionPill: View {
    let label: String
    let value: Int
    let unit: String

    var body: some View {
        HStack(spacing: 2) {
            Text(label)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(Palette.accentStrong)
            Text("\(value)\(unit)")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(Palette.textSecondary)
        }
    }
}
