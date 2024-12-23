//
//  SnippetsApp.swift
//  Snippets
//
//  Created by Cole Morrison on 10/21/24.
//

import SwiftUI
import SwiftData

@main
struct SnippetsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Snippet.self, Folder.self, Tag.self])
    }
}
