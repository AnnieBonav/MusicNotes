import SwiftUI
import SwiftData

struct NoteBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(.clear)
            .background(.clear)
    }
}

// Is the overall render of all NotesTypes. Serves as body of a single app Page.
struct NotesList: View {
    @Environment(\.modelContext) var context
    let notesData: [NoteData] // Adding state makes it not update anymore
    
    let addTextDataFunc: () -> Void
    let addAudioRecordingDataFunc: () -> Void
    
    let columnLayout = Array(repeating: GridItem(), count: 1)
    
    var body: some View {
        VStack {
            List {
                Section(content: {
                    ForEach(notesData, id: \.self) { noteData in
                        NoteView(noteData: noteData, textData: noteData.textData, audioRecordingData: noteData.audioRecordingData)
                    }
                    .onMove(perform: { indices, newOffset in
                        var tempNotesData = notesData.sorted(by: { $0.notePosition < $1.notePosition })
                        tempNotesData.move(fromOffsets: indices, toOffset: newOffset)
                        for (index, noteData) in tempNotesData.enumerated() {
                            noteData.notePosition = index
                        }
                     })
                    // Handles delete directly on notes Views to make sure all binded values get reset (textData.userText)
                    .listRowSeparator(.hidden)
                    HStack{
                        Spacer()
                        Button(action: {
                            addTextDataFunc()
                        }) {
                            Image(systemName: "square.and.pencil.circle")
                                .foregroundColor(.accentColor)
                                .font(.largeTitle)
                        }
                        .buttonStyle(BorderedButtonStyle())
                        .buttonBorderShape(.circle)
                        .tint(.accentColor.opacity(0.6))
                        .foregroundColor(.accentColor)
                        
                        Button(action: {
                            addAudioRecordingDataFunc()
                        }) {
                            Image(systemName: "waveform.circle")
                                .foregroundColor(.accentColor)
                                .font(.largeTitle)
                        }
                        .buttonStyle(BorderedButtonStyle())
                        .buttonBorderShape(.circle)
                        .tint(.accentColor.opacity(0.6))
                        .foregroundColor(.accentColor)
                        Spacer()
                    }
                    .listRowBackground(NoteBackground())
                })
            }
            .listRowSpacing(10)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview {
//    let preview = Preview(PageData.self)
//    let mockPageData = PageData.mockPageData[0]
//    let pageId = mockPageData.pageId
//    
//    let mockNotes =
//        [
//            NoteData(pageId: pageId, notePosition: 0, noteType: NoteType.text, textData: TextData()),
//            NoteData(pageId: pageId, notePosition: 2, noteType: NoteType.audioRecording, audioRecordingData: AudioRecordingData(urlString: "")),
//            NoteData(pageId: pageId, notePosition: 1, noteType: NoteType.text, textData: TextData()),
//            NoteData(pageId: pageId, notePosition: 3, noteType: NoteType.text, textData: TextData()),
//            NoteData(pageId: pageId, notePosition: 4, noteType: NoteType.audioRecording, audioRecordingData: AudioRecordingData(urlString: ""))
//        ]
//    mockPageData.notesData = mockNotes
//    preview.addExamples([mockPageData])
//    
//    return NotesList(notesData: mockPageData.notesData!, addTextDataFunc: {
//        print("Added Text")
//    }, addAudioRecordingDataFunc: {
//        print("Added Audio")
//    })
//        .modelContainer(preview.container)
//}
