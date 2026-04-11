import SwiftUI

struct FamilyMemberRow: View {
    let member: FamilyMember
    let onToggle: () -> Void
    let onRename: (String) -> Void
    let onUpdateNutrition: (NutritionMetrics, BodyMetrics) -> Void
    let onClearNutrition: () -> Void

    @State private var isEditing = false
    @State private var editText = ""
    @State private var showCalculator = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingXS) {
            // MARK: Main row
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    if isEditing {
                        TextField("Name", text: $editText, onCommit: {
                            onRename(editText)
                            isEditing = false
                        })
                        .font(AppTheme.bodyFont)
                        .textFieldStyle(.plain)
                    } else {
                        Text(member.name)
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.primary)
                            .onTapGesture {
                                editText = member.name
                                isEditing = true
                            }
                    }
                    Text(member.isChild ? "Child (×0.5)" : "Adult (×1.0)")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.secondary)
                }

                Spacer()

                // Nutrition badge
                Button {
                    showCalculator = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: member.hasNutritionTargets ? "chart.bar.fill" : "chart.bar")
                            .font(.system(size: 11))
                        Text(member.hasNutritionTargets
                             ? "\(Int(member.nutritionTargets!.calories)) kcal"
                             : "Set targets")
                            .font(AppTheme.captionFont)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(member.hasNutritionTargets
                                ? Color.green.opacity(0.12)
                                : Color(.tertiarySystemFill))
                    .foregroundColor(member.hasNutritionTargets ? .green : AppTheme.secondary)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)

                // Adult / Child toggle
                Button(action: onToggle) {
                    Text(member.isChild ? "Child" : "Adult")
                        .font(AppTheme.captionFont)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(member.isChild ? Color.gray.opacity(0.15) : Color.primary.opacity(0.1))
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }

            // MARK: Nutrition summary strip (visible when targets are set)
            if let targets = member.nutritionTargets {
                HStack(spacing: AppTheme.spacingMD) {
                    NutritionPill(label: "P", value: Int(targets.protein), unit: "g", color: .blue)
                    NutritionPill(label: "F", value: Int(targets.fat),     unit: "g", color: .orange)
                    NutritionPill(label: "C", value: Int(targets.carbs),   unit: "g", color: .green)

                    Spacer()

                    Button {
                        onClearNutrition()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 2)
            }
        }
        .padding(.vertical, AppTheme.spacingXS)
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
    let color: Color

    var body: some View {
        HStack(spacing: 2) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
            Text("\(value)\(unit)")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(AppTheme.secondary)
        }
    }
}
