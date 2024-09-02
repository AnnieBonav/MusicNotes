import SwiftUI

// Shows NoteData and handles calling either TextView or AudioRecordingView according to the noteData. If noteData is nil, it currenly shows an Text for debugging.
struct NoteView: View {
    @State var noteData: NoteData
    @State var textData: TextData
    @State var audioRecordingData: AudioRecordingData
    
    var body: some View {
        VStack{
            switch noteData.noteType {
                case .text:
                TextView(textData: textData)
                case .audioRecording:
                AudioRecordingView(audioRecordingData: audioRecordingData)
            }
        }
    }
}

    // TODO: Fix Persistent Identifier
#Preview {
    // MAKE SURE to set the noteType of the note that is being set: NoteType.text for textData and NoteType.audio for audioRecordingData
    let textData = TextData()
    let audioRecordingData = AudioRecordingData(urlString: "")
    let mockNote = NoteData(pageId: UUID(), noteType: NoteType.text, textData: textData, audioRecordingData: audioRecordingData)
                            
    return NoteView(noteData: mockNote, textData: mockNote.textData, audioRecordingData: mockNote.audioRecordingData)
}
