//
//  FolderView.swift
//  Snippets
//
//  Created by Cole Morrison on 12/1/24.
//

import SwiftUI
import SwiftData


struct FolderView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var folders: [Folder]
    @State private var showingAddFolder = false
    @State private var newFolderName = ""
    @State private var showingEditFolder = false
    @State private var editFolder: Folder =  Folder(name: "Default Folder")
    @State private var editFolderName = ""
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(folders) { folder in
                    HStack {
                        Image(systemName: "folder")
                        Text(folder.name)
                        Spacer()
                        Button("Edit") {
                            showingEditFolder = true
                            editFolder = folder
                            editFolderName = folder.name
                            
                        }
                    }
                    
                }
                .onDelete(perform: deleteFolder)
                
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {showingAddFolder = true}) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Folder", isPresented: $showingAddFolder, actions: {
                TextField("Folder name", text: $newFolderName)
                Button("Create") {
                    modelContext.insert( Folder(name: newFolderName))
                }
                Button("Cancel", role: .cancel) {
                    newFolderName = ""
                }
            })
            .alert("Edit Folder", isPresented: $showingEditFolder, actions: {
                TextField("Edit Folder name", text: $editFolderName)
                Button("Save") {
                    editFolder.name = editFolderName
                    do { try modelContext.save()} catch {}
                }
                Button("Cancel", role: .cancel) {
                    newFolderName = ""
                }
                
            })
        }
        
        
        
    }
    
    func deleteFolder(at offsets: IndexSet) {
        for index in offsets {
            let folder = folders[index]
            modelContext.delete(folder)
            do { try modelContext.save()} catch {}
        }
    }
}

#Preview {
    FolderView()
        .modelContainer(for: [Snippet.self, Folder.self, Tag.self])
}
