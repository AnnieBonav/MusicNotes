import SwiftData

enum NoteType: String, CaseIterable, Codable {
    case text
    case audioRecording
}

// NoteData is used as an abstraction layer for the different types of Notes, since SwiftData is not expected to work with inheritance. This makes rendering the list of notes simple (using NoteView), as well as keeping the index of the note stored for rendering (and leaving the TextData and AudioRecordingData agnostic to their position on the list and which page they belong in).
@Model
final class NoteData {
    var notePosition: Int
    var noteType: NoteType?
    
    var textData: TextData?
    var audioRecordingData: AudioRecordingData?
    
    init(notePosition: Int = Int.min,
         textData: TextData? = nil,
         audioRecordingData: AudioRecordingData? = nil) {
        
        self.noteType = nil
        self.notePosition = notePosition
        
        // Initializing with either textData or audioRecordingData will store it and assign the corresponding noteType.
        // Assignment goes as folows: textData >> audioRecordingData (based on the next if-else statement)
        // No assignment will lead to noteType being nil, which can be checked before trying to render
        if(textData != nil){
            noteType = NoteType.text
            self.textData = textData
        }else if (audioRecordingData != nil){
            noteType = NoteType.audioRecording
            self.audioRecordingData = audioRecordingData
        }
    }
}
