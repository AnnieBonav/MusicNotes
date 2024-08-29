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
//            TextsList()
            AudioRecordingsList()
            Button(action: addTextData) {
                Label("", systemImage: "plus.circle.fill")
                     .foregroundColor(.accentA)
                    // TODO: Look for not font (built-in) way to do it
                     .font(.system(size: 40))
            }
            
            AudioView()
            
        }
        .padding(.horizontal).background(.appBackground)
        .frame(maxWidth: .infinity, alignment: .leading)
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
    let preview = Preview(TextData.self, AudioRecordingData.self)
    preview.addExamples(TextData.sampleTextData)
    preview.addExamples(AudioRecordingData.sampleAudioData)
    return PageView()
        .modelContainer(preview.container)
}
