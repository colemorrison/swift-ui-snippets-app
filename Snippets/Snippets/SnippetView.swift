//
//  ContentView.swift
//  Snippets
//
//  Created by Cole Morrison on 10/21/24.
//

import SwiftUI
import SwiftData

struct SnippetView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var snippets: [Snippet]
    @State private var showingAddSnippet = false
    
    var body: some View {
        NavigationStack {
            //MARK: List
            List {
                ForEach(snippets) { snippet in
                    NavigationLink(destination: SnippetDetailView(snippet: snippet)) {
                        Text(snippet.title)
                    }
                }
                .onDelete(perform: deleteSnippet)
                
                
            }
            .navigationTitle("Snippets")
            //MARK: ToolbarItems
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSnippet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSnippet) {
                FormSnippetView(title: "Create Form", snippet: Snippet())
            }
        }
    }
    
    //MARK: deleteSnippet
    func deleteSnippet(at offsets: IndexSet) {
        for index in offsets {
            let snippet = snippets[index]
            modelContext.delete(snippet)
            do { try modelContext.save()} catch {}
        }
    }
}

//MARK: Preview
#Preview {
    SnippetView()
        .modelContainer(for: [Snippet.self, Folder.self, Tag.self])
}

