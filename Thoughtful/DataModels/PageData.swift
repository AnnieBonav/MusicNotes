import Foundation
import SwiftData

// PageData is used to store the page's notesData array, as well as its own information. The app can have multiple pages, and each page multiple notes of different types (at the moment, TextData and AudioRecordingData).
@Model
final class PageData{
    var pageId: UUID
    var title: String
    var dateCreated: Date
    var lastModified: Date
    @Relationship(deleteRule: .cascade)
    var notesData: [NoteData]? 
    
    init(pageId: UUID = UUID(),
         title: String = "New Page",
         dateCreated: Date = Date.now,
         lastModified: Date = Date.now,
         notesData: [NoteData] = []) {
        self.pageId = pageId
        self.title = title
        self.dateCreated = dateCreated
        self.lastModified = lastModified
        self.notesData = notesData
    }
}
