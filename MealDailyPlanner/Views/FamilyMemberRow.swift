import SwiftUI

struct FamilyMemberRow: View {
    let member: FamilyMember
    let onToggle: () -> Void
    let onRename: (String) -> Void

    @State private var isEditing = false
    @State private var editText = ""

    var body: some View {
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
                Text(member.isChild ? "Child (x0.5)" : "Adult (x1.0)")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondary)
            }

            Spacer()

            Button(action: onToggle) {
                Text(member.isChild ? "Child" : "Adult")
                    .font(AppTheme.captionFont)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(member.isChild ? Color.gray.opacity(0.2) : Color.primary.opacity(0.1))
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, AppTheme.spacingXS)
    }
}
