//
//  TagView.swift
//  Snippets
//
//  Created by Cole Morrison on 12/1/24.
//

import SwiftUI
import SwiftData


struct TagView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var tags: [Tag]
    @State private var showingAddTag = false
    @State private var newTagName = ""
    @State private var showingEditTag = false
    @State private var editTag: Tag =  Tag(name: "Default Tag")
    @State private var editTagName = ""
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tags) { tag in
                    HStack {
                        Image(systemName: "tag")
                        Text(tag.name)
                        Spacer()
                        Button("Edit") {
                            showingEditTag = true
                            editTag = tag
                            editTagName = tag.name
                            
                        }
                    }
                    
                }
                .onDelete(perform: deleteTag)
                
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {showingAddTag = true}) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Tag", isPresented: $showingAddTag, actions: {
                TextField("Tag name", text: $newTagName)
                Button("Create") {
                    modelContext.insert( Tag(name: newTagName))
                }
                Button("Cancel", role: .cancel) {
                    newTagName = ""
                }
            })
            .alert("Edit Tag", isPresented: $showingEditTag, actions: {
                TextField("Edit Tag name", text: $editTagName)
                Button("Save") {
                    editTag.name = editTagName
                    do { try modelContext.save()} catch {}
                }
                Button("Cancel", role: .cancel) {
                    newTagName = ""
                }
                
            })
        }
        
        
        
    }
    
    func deleteTag(at offsets: IndexSet) {
        for index in offsets {
            let tag = tags[index]
            modelContext.delete(tag)
            do { try modelContext.save()} catch {}
        }
    }
}

#Preview {
    TagView()
        .modelContainer(for: [Snippet.self, Folder.self, Tag.self])
}

