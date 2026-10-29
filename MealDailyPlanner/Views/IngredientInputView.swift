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
        HStack(spacing: 10) {
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Palette.textTertiary))
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(Palette.text)
                .textFieldStyle(.plain)
                .disabled(isDisabled)
                .onSubmit {
                    if !buttonDisabled { onAdd() }
                }

            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(buttonDisabled ? Palette.textTertiary : Palette.accent)
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(Palette.accentSoft))
            }
            .buttonStyle(.plain)
            .disabled(buttonDisabled)
        }
    }
}
