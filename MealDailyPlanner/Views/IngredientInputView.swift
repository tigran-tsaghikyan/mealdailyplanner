import SwiftUI

struct IngredientInputView: View {
    let placeholder: String
    @Binding var text: String
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: AppTheme.spacingSM) {
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .onSubmit { onAdd() }

            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(AppTheme.primary)
                    .font(.title3)
            }
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
}
