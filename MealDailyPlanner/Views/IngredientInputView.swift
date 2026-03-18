import SwiftUI

struct IngredientInputView: View {
    let placeholder: String
    @Binding var text: String
    let onAdd: () -> Void
    var isDisabled: Bool = false

    private var buttonDisabled: Bool {
        isDisabled || text.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        HStack(spacing: AppTheme.spacingSM) {
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .disabled(isDisabled)
                .onSubmit {
                    if !buttonDisabled { onAdd() }
                }

            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(buttonDisabled ? AppTheme.secondary : AppTheme.primary)
                    .font(.title3)
            }
            .disabled(buttonDisabled)
        }
    }
}
