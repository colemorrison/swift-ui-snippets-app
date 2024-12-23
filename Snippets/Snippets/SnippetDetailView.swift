//
//  SnippetDetailView.swift
//  Snippets
//
//  Created by Cole Morrison on 10/21/24.
//

import SwiftUI
import SwiftData

struct SnippetDetailView: View {
    @Bindable var snippet: Snippet
    @State private var showingEditView = false
    
    var body: some View {
        //MARK: NavigationStack
        NavigationStack {
            VStack(alignment: .leading) {
                Text(snippet.content)
                    .padding()
                Spacer()
            }
            .navigationTitle(snippet.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") {
                        showingEditView = true
                    }
                }
            }
            .sheet(isPresented: $showingEditView) {
                FormSnippetView(title: "Edit Form", snippet: snippet)
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
    
    return SnippetDetailView(snippet: example)
        .modelContainer(container)
}
