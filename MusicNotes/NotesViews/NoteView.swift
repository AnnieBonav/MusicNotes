import SwiftUI

// Shows NoteData and handles calling either TextView or AudioRecordingView according to the noteData. If noteData is nil, it currenly shows an Text for debugging.
struct NoteView: View {
    @State var noteData: NoteData
    @State var textData: TextData?
    @State var audioRecordingData: AudioRecordingData?
    
    var body: some View {
        VStack{
            switch noteData.noteType {
                case .text:
                TextView(textData: textData!) // TextView(textData: noteData.textData!) fails
                case .audioRecording:
                AudioRecordingView(audioRecordingData: audioRecordingData!)
                case .none:
                    Text("Debugging Text")
            }
        }
    }
}

// Preview fails but rendering in app works. Probably related with accessing data through SwiftData (note calls textData / audioRecordingData accordingly).
//#Preview {
//    let preview = Preview(NoteData.self)
//    let notesData = NoteData.sampleMockData
//    preview.addExamples(notesData)
//    
//    // Only the last not nil value of NoteData init() will be rendered(either textData or audioRecordingData with current implementation)
//    return NoteView(noteData: notesData[0])
//        .modelContainer(preview.container)
//}
