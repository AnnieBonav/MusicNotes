//
//  PageView.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/19/24.
//

import SwiftUI
import SwiftData

struct PageView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \TextData.dateCreated) private var textsData: [TextData]
    
    var body: some View {
        VStack {
            Text("A very cool note")
                .font(.title).padding(.top)
        }
        .padding(.horizontal).background(.appBackground)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack {
            NotesList()
            Button(action: addTextData) {
                Label("", systemImage: "plus.circle.fill")
                     .foregroundColor(.accentA)
                    // TODO: Look for not font (built-in) way to do it
                     .font(.system(size: 40))
            }
            
            RecordAudioView()
            
        }
        .padding(.horizontal).background(.appBackground)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer()
    }
    
    // TODO: Check if handling CRUD here is best
    private func addTextData() {
        withAnimation {
            let newTextData = TextData()
            context.insert(newTextData)
        }
    }
    
    private func deleteTextData(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(textsData[index])
            }
        }
    }
}

#Preview {
    let preview = Preview(TextData.self, AudioRecordingData.self, NoteData.self)
    
    let textsData = TextData.sampleTextData
    let audioRecordingsData = AudioRecordingData.sampleAudioData
    
    var mockNotes: [NoteData] = [NoteData]()
    mockNotes.append(NoteData(notePosition: 0, textData: textsData[4]))
    mockNotes.append(NoteData(notePosition: 2, textData: textsData[1]))
    mockNotes.append(NoteData(notePosition: 1, audioRecordingData: audioRecordingsData[4]))
    
    preview.addExamples(textsData)
    preview.addExamples(audioRecordingsData)
    preview.addExamples(mockNotes)
    
    return PageView()
        .modelContainer(preview.container)
}
