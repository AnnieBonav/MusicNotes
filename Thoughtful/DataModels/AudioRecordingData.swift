import Foundation
import AVFAudio
import SwiftData

// AudioRecordingData is a type of Note that can have a title, details, and saves the urlString of the recorded Audio. The urlString is the name of the file, the rest is currently retrieved in every run, since each build generates a different path.
@Model
final class AudioRecordingData {
    var noteData: NoteData? // For inverse relationship to NoteData
    
    var dateCreated: Date
    var title: String?
    var details: String?
    var urlString: String
    
    init(
        dateCreated: Date = Date.now,
        title: String? = nil,
        details: String? = nil,
        urlString: String
    ) {
        self.dateCreated = dateCreated
        self.title = title
        self.details = details
        self.urlString = urlString
    }
}
