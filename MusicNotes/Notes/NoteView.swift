//
//  NoteView.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/27/24.
//

import SwiftUI

struct NoteView: View {
    var noteData: NoteData
    
    var body: some View {
        switch noteData.noteType {
            case .text:
                TextView(textData: noteData.textData!)
            case .audioRecording:
                AudioRecordingView(audioRecordingData: noteData.audioRecordingData!)
            case .notDefined:
                Text("Not defined")
        }
    }
}

#Preview {
    let preview = Preview(TextData.self, AudioRecordingData.self)
    let textsData = TextData.sampleTextData
    let audioRecordingsData = AudioRecordingData.sampleAudioData
    
    preview.addExamples(textsData)
    preview.addExamples(audioRecordingsData)
    
    // Only the last not nil value of NoteData init() will be rendered(either textData or audioRecordingData with current implementation)
    return NoteView(noteData: NoteData(notePosition: 0, textData: textsData[4], audioRecordingData: audioRecordingsData[4]))
        .modelContainer(preview.container)
}
