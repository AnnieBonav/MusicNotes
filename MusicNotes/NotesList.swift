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
    let columnLayout = Array(repeating: GridItem(), count: 1)
    
    var body: some View {
        VStack{
            List{
                Section(content: {
                    ForEach(notesData){noteData in
                    NoteView(noteData: noteData)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(NoteBackground())
                }, header: {
                    Text("I am a title")
                        .font(.title)
                })
            }
            .listRowSpacing(10)
            .scrollContentBackground(.hidden)
        }.frame(maxWidth: .infinity)
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
    mockNotes.append(NoteData(notePosition: 1, textData: textsData[1]))
    mockNotes.append(NoteData(notePosition: 2, audioRecordingData: audioRecordingsData[4]))
    
    preview.addExamples(mockNotes)
    return NotesList()
        .modelContainer(preview.container)
}
