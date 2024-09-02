import SwiftData
import Foundation

enum NoteType: String, CaseIterable, Codable {
    case text
    case audioRecording
}

// NoteData is used as an abstraction layer for the different types of Notes, since SwiftData is not expected to work with inheritance. This makes rendering the list of notes simple (using NoteView), as well as keeping the index of the note stored for rendering (and leaving the TextData and AudioRecordingData agnostic to their position on the list and which page they belong in).
@Model
final class NoteData {
    var pageData: PageData? // For inverse relationship to PageData
    
    var pageId: UUID
    var notePosition: Int
    var noteType: NoteType
    
    var textData: TextData
    var audioRecordingData: AudioRecordingData
    
//    @Relationship(deleteRule: .cascade) var textData: TextData
//    @Relationship(deleteRule: .cascade) var audioRecordingData: AudioRecordingData
    
    init(
        pageId: UUID,
        notePosition: Int = Int.min,
        noteType: NoteType,
        textData: TextData = TextData(),
        audioRecordingData: AudioRecordingData = AudioRecordingData(urlString: "")) {
        
            self.pageId = pageId
            self.notePosition = notePosition
            self.noteType = noteType
            
            self.textData = textData
            self.audioRecordingData = audioRecordingData
    }
}
