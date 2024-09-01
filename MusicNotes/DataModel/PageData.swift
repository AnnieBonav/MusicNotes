import Foundation
import SwiftData

// PageData is used to store the page's notesData array, as well as its own information. The app can have multiple pages, and each page multiple notes of different types (at the moment, TextData and AudioRecordingData).
@Model
final class PageData{
    var title: String
    var dateCreated: Date
    var lastModified: Date
    var notesData: [NoteData]
    
    init(title: String,
         dateCreated: Date,
         lastModified: Date,
         notesData: [NoteData] = [NoteData]()) {
        self.title = title
        self.dateCreated = dateCreated
        self.lastModified = lastModified
        self.notesData = notesData
    }
}
