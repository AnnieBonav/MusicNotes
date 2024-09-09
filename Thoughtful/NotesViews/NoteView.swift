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
                TextView(textData: textData!) // Can force unwrap since .noteType defines which info it will have
                case .audioRecording:
                AudioRecordingView(audioRecordingData: audioRecordingData!)
            }
        }
    }
}
