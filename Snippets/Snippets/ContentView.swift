//
//  ContentView.swift
//  Snippets
//
//  Created by Cole Morrison on 10/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        
        TabView {
            SnippetView()
                .tabItem {
                    Label("Snippets", systemImage: "house")
                }
            FolderView()
                .tabItem {
                    Label("Folders", systemImage: "folder")
                }
            
            TagView()
                .tabItem {
                    Label("Tags", systemImage: "tag")
                }
            
        }
//        .onAppear{addSampleSnippets()}
        
    
    }
    
    
    func addSampleSnippets() {
        let first = Snippet(title: "Hello, World!", content: "Swift is awesome!", language: "Swift", folder: Folder(name: "Swift"))
        first.tags.append(Tag(name: "Swift"))
        modelContext.insert(first)

        let second = Snippet(title: "SwiftUI", content: "SwiftUI is a great framework for building user interfaces.", language: "Swift", folder: Folder(name: "SwiftUI"))
        second.tags.append(Tag(name: "SwiftUI"))
        modelContext.insert(second)

        do {
            try modelContext.save()
        } catch {
            fatalError("Could not save sample snippets: \(error)")
        }
    }
    
}

//MARK: Preview
#Preview {
    ContentView()
        .modelContainer(for: [Snippet.self, Folder.self, Tag.self])
    
}
