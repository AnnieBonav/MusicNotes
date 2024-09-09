import SwiftData
import Foundation

enum NoteType: String, CaseIterable, Codable {
    case text
    case audioRecording
}

// NoteData is used as an abstraction layer for the different types of Notes, since SwiftData is not expected to work with inheritance. This makes rendering the list of notes simple (using NoteView), as well as keeping the index of the note stored for rendering (and leaving the TextData and AudioRecordingData agnostic to their position on the list and which page they belong in).
@Model
final class NoteData {
    var notePosition: Int
    var noteType: NoteType
    var pageId: UUID
    
    @Relationship(deleteRule: .cascade, inverse: \TextData.noteData)
    var textData: TextData?
    
    @Relationship(deleteRule: .cascade, inverse: \AudioRecordingData.noteData)
    var audioRecordingData: AudioRecordingData?
    
    init(
        pageId: UUID,
        notePosition: Int = Int.min,
        noteType: NoteType,
        textData: TextData? = nil,
        audioRecordingData: AudioRecordingData? = nil) {
        
            self.pageId = pageId
            self.notePosition = notePosition
            self.noteType = noteType
            
            self.textData = textData
            self.audioRecordingData = audioRecordingData
    }
    
    @Relationship(deleteRule: .nullify)
    var pageData: PageData?
}
