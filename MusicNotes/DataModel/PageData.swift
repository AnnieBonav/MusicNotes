//
//  PageData.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/27/24.
//

import Foundation
import SwiftData

@Model
final class PageData{
    var title: String
    var dateCreated: Date
    var lastModified: Date
    var notesData: [NoteData]
    
    init(title: String,
         dateCreated: Date, lastModified: Date,
         notesData: [NoteData] = [NoteData]()) {
        self.title = title
        self.dateCreated = dateCreated
        self.lastModified = lastModified
        self.notesData = notesData
    }
}
