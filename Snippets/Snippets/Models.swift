//
//  Models.swift
//  Snippets
//
//  Created by Cole Morrison on 10/21/24.
//


import SwiftData

@Model
class Snippet {
    var title: String
    var content: String
    var language: String
    var folder: Folder?
    var tags: [Tag] = []
    
    init(title: String = "", content: String = "", language: String = "", folder: Folder? = Folder()) {
        self.title = title
        self.content = content
        self.language = language
        self.folder = folder
    }
}

@Model
class Folder {
    var name: String
    var snippets: [Snippet] = []
    
    init(name: String = "") {
        self.name = name
    }
}

@Model
class Tag {
    @Attribute(.unique) var name: String
    var snippets: [Snippet] = []
    
    init(name: String = "") {
        self.name = name
    }
}
