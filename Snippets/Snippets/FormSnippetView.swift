//
//  EditSnippetView.swift
//  Snippets
//
//  Created by Cole Morrison on 10/21/24.
//

import SwiftUI
import SwiftData

struct FormSnippetView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    
    var title: String
    @Bindable var snippet: Snippet
    
    @State private var selectedFolder: Folder?
    @State private var selectedTags: [Tag] = []
    
    @Query(sort: \Folder.name) var folders: [Folder]
    @Query(sort: \Tag.name) var tags: [Tag]
    
    var body: some View {
        NavigationStack {
            //MARK: Form
            Form {
                Section(header: Text("Snippet Info")) {
                    TextField("Title", text: $snippet.title)
                    TextField("Language", text: $snippet.language)
                    TextEditor(text: $snippet.content)
                        .frame(height: 100)
                }
                
                Section(header: Text("Folder")) {
                    Picker("Folder", selection: $selectedFolder) {
                        Text("None").tag(Folder?.none)
                        ForEach(folders) { folder in
                            Text(folder.name).tag(Folder?.some(folder))
                        }
                    }
                }
                
                Section(header: Text("Tags")) {
                    ForEach(tags) { tag in
                        MultipleSelectionRow(tag: tag, isSelected: selectedTags.contains(tag)) {
                            if selectedTags.contains(tag) {
                                selectedTags.removeAll { $0 == tag }
                            } else {
                                selectedTags.append(tag)
                            }
                        }
                    }
                }
                
            }
            .navigationTitle(title)
            .onAppear {
                selectedFolder = snippet.folder
                selectedTags = snippet.tags
            }
            //MARK: Toolbar items
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        modelContext.insert(snippet)
                        do {
                            try modelContext.save()
                        } catch {
                            modelContext.rollback()
                            print("Failed to save changes: \(error.localizedDescription)")
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}


struct MultipleSelectionRow: View {
    var tag: Tag
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(tag.name)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

//MARK: Preview
#Preview {
    /*
     Since we added a property (@Bindable var snippet: Snippet) to this View, our preview struct won't work. To work around this, create an in-memory container so that any preview objects we create aren't saved, and instead are just temporary.
     */
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Snippet.self, Folder.self, Tag.self, configurations: config)
    
    let example = Snippet(
        title: "Example snippet (temporary)",
        content: "// This snippet should NOT be saved permanently to the database.",
        language: "TempSwift",
        folder: Folder(name: "TempSwift")
    )
    example.tags.append(Tag(name: "TempSwift"))
    
    // so the EditDetailView Queries can see the preview data
    container.mainContext.insert(example)
    
    
    return FormSnippetView(title: "test", snippet: example)
        .modelContainer(container)
}
