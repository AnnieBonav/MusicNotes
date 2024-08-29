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

// Preview does not work
/* #Preview {
    let preview = Preview(NoteData.self)
    let textsData = TextData.sampleTextData
    let audioRecordingsData = AudioRecordingData.sampleAudioData
    
    var mockNotes: [NoteData] = [NoteData]()
    mockNotes.append(NoteData(notePosition: 0, textData: textsData[4]))
    mockNotes.append(NoteData(notePosition: 2, textData: textsData[1]))
    mockNotes.append(NoteData(notePosition: 1, audioRecordingData: audioRecordingsData[4]))
    
    let mockNoteData = NoteData(notePosition: 0, textData: TextData())
    
    // Only the last not nil value of NoteData init() will be rendered(either textData or audioRecordingData with current implementation)
    return NoteView(noteData: mockNoteData)
        .modelContainer(preview.container)
}*/
