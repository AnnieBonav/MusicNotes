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
        
    var backgroundColor = Color(.appBackground)
    
    var body: some View {
        VStack {
            Text("A very cool note")
                .font(.title).padding(.top)
        }
        .padding(.horizontal).background(backgroundColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack {
            ScrollView {
                Grid(alignment: .top) {
                    ForEach(textsData) { textData in
                        GridRow{
                            TextView(textData: textData)
                        }
                        // TODO: Fix bug so it can automatically be resized (and does not start without showing text)
                        .frame(minHeight: 100)
                    }
                }
            }.frame(maxHeight: .infinity)
            Button(action: addTextData) {
                Label("", systemImage: "plus.circle.fill")
                     .foregroundColor(.accentA)
            }
            
        }
        .padding(.horizontal).background(backgroundColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear(){
            // TODO: See practices on best place
            requestRecordPermission()
        }
        
    }
    
    func requestRecordPermission() {
        Task { @MainActor in
            AVAudioApplication.requestRecordPermission() { wasCompleted in
                if wasCompleted {
                    print("Granted")
                } else {
                    print("Denied")
                }
            }
        }
    }
    
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

struct AddNewCardLabel: View {
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.appBackground)
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.accentA)
        }
        .padding(.vertical)
    }
}

#Preview {
    let preview = Preview(TextData.self)
    preview.addExamples(TextData.sampleTextData)
    return PageView()
        .modelContainer(preview.container)
}
