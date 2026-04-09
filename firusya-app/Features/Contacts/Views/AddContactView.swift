//
//  AddContactView.swift
//  firusia
//
//  Created by Рева Георгий Александрович on 09.03.2026.
//

import SwiftUI
import SwiftData

struct AddContactView: View {

    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel = AddContactViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact") {
                    TextField("Display name", text: $viewModel.form.displayName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()

                    TextField("Username / subtitle", text: $viewModel.form.subtitle)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("New Contact")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        router.dismissSheet()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSaveTapped()
                    }
                    .disabled(viewModel.canSave == false)
                }
            }
        }
    }
}

private extension AddContactView {

    func onSaveTapped() {
        let newContact = Contact(
            id: UUID().uuidString,
            displayName: viewModel.normalizedDisplayName,
            subtitle: viewModel.optionalNormalizedSubtitle
        )
        modelContext.insert(newContact)

        do {
            try modelContext.save()
            router.dismissSheet()
        } catch {
            assertionFailure("Failed to save new contact: \(error)")
        }
    }
}

#Preview {
    AddContactView()
        .environment(Router())
        .modelContainer(AppModel.makePreviewContainer())
}
