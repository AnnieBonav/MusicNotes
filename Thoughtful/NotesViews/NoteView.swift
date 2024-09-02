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
    // Only the first not nil value of NoteData init() will be rendered(either textData or audioRecordingData with current implementation). However, all possible data types need to be sent, as preview does not work otherwise (rendering in app does work, but it makes debugging hard).
    var textData = TextData()
    var audioRecordingData = AudioRecordingData(urlString: "")
    var mockNote = NoteData(pageId: UUID(), noteType: NoteType.text, textData: textData, audioRecordingData: audioRecordingData)
                            
    return NoteView(noteData: mockNote, textData: mockNote.textData, audioRecordingData: mockNote.audioRecordingData)
}
