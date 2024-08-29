//
//  NotesList.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/27/24.
//

import SwiftUI
import SwiftData

struct NotesList: View {
    @Query(sort: \NoteData.notePosition) var notesData: [NoteData]
    
    var body: some View {
        ScrollView{
            Grid{
                ForEach(notesData){noteData in
                    GridRow{
                        NoteView(noteData: noteData)
                    }
                }
            }
        }
    }
}

#Preview {
    let preview = Preview(NoteData.self)
    let textsData = TextData.sampleTextData
    let audioRecordingsData = AudioRecordingData.sampleAudioData
    
    preview.addExamples(textsData)
    preview.addExamples(audioRecordingsData)
    
    var mockNotes: [NoteData] = [NoteData]()
    mockNotes.append(NoteData(notePosition: 0, textData: textsData[4]))
    mockNotes.append(NoteData(notePosition: 2, textData: textsData[1]))
    mockNotes.append(NoteData(notePosition: 1, audioRecordingData: audioRecordingsData[4]))
    
    preview.addExamples(mockNotes)
    return NotesList()
        .modelContainer(preview.container)
    return TextView(textData: textsData[4])
}
