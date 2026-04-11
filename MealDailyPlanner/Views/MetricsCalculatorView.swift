import SwiftUI

struct MetricsCalculatorView: View {
    let member: FamilyMember
    let onApply: (NutritionMetrics, BodyMetrics) -> Void

    @Environment(\.dismiss) private var dismiss

    // MARK: - Input State

    @State private var weightKg: Double = 70
    @State private var heightCm: Double = 170
    @State private var age: Int = 30
    @State private var sex: BiologicalSex = .notSpecified
    @State private var activityLevel: ActivityLevel = .light
    @State private var goal: WeightGoal = .maintain

    // Unit toggles
    @State private var useImperialWeight = false
    @State private var useImperialHeight = false

    // Text field bindings
    @State private var weightText  = "70"
    @State private var heightText  = "170"
    @State private var feetText    = "5"
    @State private var inchesText  = "7"
    @State private var ageText     = "30"

    // Result
    @State private var calculatedResult: NutritionMetrics? = nil
    @State private var showResult = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.spacingLG) {
                    headerView

                    VStack(spacing: AppTheme.spacingMD) {
                        weightSection
                        heightSection
                        ageSection
                        sexSection
                        activitySection
                        goalSection
                    }
                    .padding(.horizontal, AppTheme.spacingMD)

                    calculateButton
                        .padding(.horizontal, AppTheme.spacingMD)

                    if showResult, let result = calculatedResult {
                        resultsView(result)
                            .padding(.horizontal, AppTheme.spacingMD)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    Spacer(minLength: AppTheme.spacingXL)
                }
                .padding(.top, AppTheme.spacingMD)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Nutrition Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .onAppear { loadExistingMetrics() }
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: AppTheme.spacingSM) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 32))
                .foregroundColor(AppTheme.primary)
            Text("Set targets for \(member.name)")
                .font(AppTheme.headlineFont)
            Text("Enter body metrics to auto-calculate daily nutrition targets.")
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, AppTheme.spacingLG)
    }

    // MARK: - Weight

    private var weightSection: some View {
        inputCard {
            HStack {
                Label("Weight", systemImage: "scalemass")
                    .font(AppTheme.headlineFont)
                Spacer()
                Text(useImperialWeight ? "lbs" : "kg")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondary)
                Toggle("", isOn: $useImperialWeight)
                    .labelsHidden()
                    .onChange(of: useImperialWeight) { _, imperial in
                        weightText = imperial
                            ? String(format: "%.1f", MetricsCalculator.kgToLbs(weightKg))
                            : String(format: "%.1f", weightKg)
                    }
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                TextField(useImperialWeight ? "154" : "70", text: $weightText)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .onChange(of: weightText) { _, val in
                        if let v = Double(val) {
                            weightKg = useImperialWeight ? MetricsCalculator.lbsToKg(v) : v
                        }
                    }
                Text(useImperialWeight ? "lbs" : "kg")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.secondary)
            }
        }
    }

    // MARK: - Height

    private var heightSection: some View {
        inputCard {
            HStack {
                Label("Height", systemImage: "ruler")
                    .font(AppTheme.headlineFont)
                Spacer()
                Text(useImperialHeight ? "ft / in" : "cm")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondary)
                Toggle("", isOn: $useImperialHeight)
                    .labelsHidden()
                    .onChange(of: useImperialHeight) { _, imperial in
                        if imperial {
                            let (ft, inches) = MetricsCalculator.cmToFeetInches(heightCm)
                            feetText   = "\(ft)"
                            inchesText = "\(inches)"
                        } else {
                            heightText = String(format: "%.0f", heightCm)
                        }
                    }
            }

            if useImperialHeight {
                HStack(spacing: AppTheme.spacingMD) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        TextField("5", text: $feetText)
                            .keyboardType(.numberPad)
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                            .frame(maxWidth: 60)
                            .onChange(of: feetText) { _, _ in syncFromFeetInches() }
                        Text("ft")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.secondary)
                    }
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        TextField("7", text: $inchesText)
                            .keyboardType(.numberPad)
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                            .frame(maxWidth: 60)
                            .onChange(of: inchesText) { _, _ in syncFromFeetInches() }
                        Text("in")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.secondary)
                    }
                }
            } else {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    TextField("170", text: $heightText)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .onChange(of: heightText) { _, val in
                            if let v = Double(val) { heightCm = v }
                        }
                    Text("cm")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.secondary)
                }
            }
        }
    }

    // MARK: - Age

    private var ageSection: some View {
        inputCard {
            Label("Age", systemImage: "person")
                .font(AppTheme.headlineFont)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                TextField("30", text: $ageText)
                    .keyboardType(.numberPad)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .onChange(of: ageText) { _, val in
                        if let v = Int(val), v > 0 { age = v }
                    }
                Text("years")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.secondary)
            }
        }
    }

    // MARK: - Biological Sex

    private var sexSection: some View {
        inputCard {
            Label("Biological Sex", systemImage: "person.2")
                .font(AppTheme.headlineFont)

            HStack(spacing: AppTheme.spacingSM) {
                ForEach(BiologicalSex.allCases) { option in
                    Button {
                        sex = option
                    } label: {
                        Text(option == .notSpecified ? "Other" : option.rawValue)
                            .font(AppTheme.bodyFont)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(sex == option ? AppTheme.primary : Color(.tertiarySystemFill))
                            .foregroundColor(sex == option ? Color(.systemBackground) : AppTheme.primary)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Activity Level

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
            Label("Activity Level", systemImage: "flame")
                .font(AppTheme.headlineFont)
                .padding(.horizontal, AppTheme.spacingMD)

            VStack(spacing: AppTheme.spacingXS) {
                ForEach(ActivityLevel.allCases) { level in
                    Button {
                        activityLevel = level
                    } label: {
                        HStack(spacing: AppTheme.spacingMD) {
                            Text(level.icon)
                                .font(.system(size: 22))
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(level.rawValue)
                                    .font(AppTheme.bodyFont)
                                    .fontWeight(.semibold)
                                    .foregroundColor(activityLevel == level ? Color(.systemBackground) : AppTheme.primary)
                                Text(level.description)
                                    .font(AppTheme.captionFont)
                                    .foregroundColor(activityLevel == level ? Color(.systemBackground).opacity(0.7) : AppTheme.secondary)
                            }

                            Spacer()

                            if activityLevel == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(.systemBackground))
                            }
                        }
                        .padding(AppTheme.spacingMD)
                        .background(activityLevel == level ? AppTheme.primary : Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppTheme.spacingMD)
        }
    }

    // MARK: - Goal

    private var goalSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
            Label("Goal", systemImage: "target")
                .font(AppTheme.headlineFont)
                .padding(.horizontal, AppTheme.spacingMD)

            VStack(spacing: AppTheme.spacingXS) {
                ForEach(WeightGoal.allCases) { option in
                    Button {
                        goal = option
                    } label: {
                        HStack(spacing: AppTheme.spacingMD) {
                            Text(option.icon)
                                .font(.system(size: 22))
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(option.rawValue)
                                    .font(AppTheme.bodyFont)
                                    .fontWeight(.semibold)
                                    .foregroundColor(goal == option ? Color(.systemBackground) : AppTheme.primary)
                                Text(option.description)
                                    .font(AppTheme.captionFont)
                                    .foregroundColor(goal == option ? Color(.systemBackground).opacity(0.7) : AppTheme.secondary)
                            }

                            Spacer()

                            if goal == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(.systemBackground))
                            }
                        }
                        .padding(AppTheme.spacingMD)
                        .background(goal == option ? AppTheme.primary : Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppTheme.spacingMD)
        }
    }

    // MARK: - Calculate Button

    private var calculateButton: some View {
        Button {
            withAnimation(.spring(response: 0.4)) {
                calculatedResult = MetricsCalculator.calculate(from: currentBodyMetrics)
                showResult = true
            }
        } label: {
            HStack {
                Image(systemName: "function")
                Text("Calculate Targets")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isInputValid ? AppTheme.primary : Color(.tertiarySystemFill))
            .foregroundColor(isInputValid ? Color(.systemBackground) : AppTheme.secondary)
            .cornerRadius(14)
        }
        .disabled(!isInputValid)
    }

    private var isInputValid: Bool {
        weightKg > 0 && heightCm > 0 && age > 0
    }

    // MARK: - Results

    private func resultsView(_ result: NutritionMetrics) -> some View {
        VStack(spacing: AppTheme.spacingMD) {
            // Title
            HStack(spacing: AppTheme.spacingSM) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Daily Targets for \(member.name)")
                    .font(AppTheme.headlineFont)
            }

            // Calories
            VStack(spacing: 4) {
                Text("\(Int(result.calories))")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.primary)
                Text("kcal / day")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.spacingLG)
            .background(Color(.systemBackground))
            .cornerRadius(16)

            // Macros
            HStack(spacing: AppTheme.spacingSM) {
                MacroResultCard(label: "Protein", value: Int(result.protein), unit: "g", color: .blue)
                MacroResultCard(label: "Fat",     value: Int(result.fat),     unit: "g", color: .orange)
                MacroResultCard(label: "Carbs",   value: Int(result.carbs),   unit: "g", color: .green)
            }

            // Formula note
            Text("Mifflin-St Jeor · \(activityLevel.rawValue) activity · \(goal.rawValue) goal (\(Int(goal.tdeeMultiplier * 100))% of TDEE)")
                .font(.system(size: 11))
                .foregroundColor(AppTheme.secondary)
                .multilineTextAlignment(.center)

            // Apply button
            Button {
                onApply(result, currentBodyMetrics)
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Apply to \(member.name)")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(14)
            }
        }
        .padding(AppTheme.spacingMD)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }

    // MARK: - Helpers

    private var currentBodyMetrics: BodyMetrics {
        BodyMetrics(
            weightKg: weightKg,
            heightCm: heightCm,
            age: age,
            sex: sex,
            activityLevel: activityLevel,
            goal: goal
        )
    }

    private func syncFromFeetInches() {
        let ft = Int(feetText) ?? 5
        let inches = Int(inchesText) ?? 7
        heightCm = MetricsCalculator.feetInchesToCm(feet: ft, inches: inches)
    }

    private func loadExistingMetrics() {
        guard let metrics = member.bodyMetrics else { return }
        weightKg      = metrics.weightKg
        heightCm      = metrics.heightCm
        age           = metrics.age
        sex           = metrics.sex
        activityLevel = metrics.activityLevel
        goal          = metrics.goal
        weightText    = String(format: "%.1f", weightKg)
        heightText    = String(format: "%.0f", heightCm)
        ageText       = "\(age)"
        let (ft, inches) = MetricsCalculator.cmToFeetInches(heightCm)
        feetText   = "\(ft)"
        inchesText = "\(inches)"

        // Show existing result immediately if targets already set
        if let existing = member.nutritionTargets {
            calculatedResult = existing
            showResult = true
        }
    }

    // MARK: - Input Card Helper

    @ViewBuilder
    private func inputCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.spacingSM) {
            content()
        }
        .padding(AppTheme.spacingMD)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .padding(.horizontal, AppTheme.spacingMD)
    }
}

// MARK: - Macro Result Card

struct MacroResultCard: View {
    let label: String
    let value: Int
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)\(unit)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.spacingMD)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}
