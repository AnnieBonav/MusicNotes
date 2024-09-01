import SwiftUI
import SwiftData

struct PageView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \NoteData.notePosition) private var notesData: [NoteData]
    @Query(sort: \TextData.dateCreated) private var textsData: [TextData]
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: .init(colors: [Color.pink.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                NotesList()
                Button(action: addTextData) {
                    Label("", systemImage: "plus.circle.fill")
                        .foregroundColor(.accentA)
                        .font(.system(size: 40))
                }
                RecordAudioView()
                Spacer()
            }
        }
    }
    
    private func addTextData() {
        withAnimation {
            let newTextData = TextData()
            let note = NoteData(notePosition: notesData.count, textData: newTextData)
            
            print("Note to add: \(note)")
            context.insert(note)
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
