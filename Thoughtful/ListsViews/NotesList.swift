import SwiftUI
import SwiftData

// Is the overall render of all NotesTypes. Serves as body of a single app Page.
struct NotesList: View {
    @Environment(\.modelContext) var context
    let notesData: [NoteData]
    
    init(notesData: [NoteData]) {
        self.notesData = notesData
    }
    let columnLayout = Array(repeating: GridItem(), count: 1)
    
    var body: some View {
        VStack{
            List{
                Section(content: {
                    ForEach(notesData, id: \.self) { noteData in
                        NoteView(noteData: noteData, textData: noteData.textData!, audioRecordingData: noteData.audioRecordingData!)
                    }
                    .onDelete { indexSet in
                        withAnimation {
                            for index in indexSet {
                                context.delete(notesData[index])
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(NoteBackground())
                })
            }
            .listRowSpacing(10)
            .scrollContentBackground(.hidden)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    let preview = Preview(PageData.self)
    let mockPageData = PageData.mockPageData[0]
    let pageId = mockPageData.pageId
    
    let mockNotes =
        [
            NoteData(pageId: pageId, notePosition: 0, noteType: NoteType.text, textData: TextData()),
            NoteData(pageId: pageId, notePosition: 2, noteType: NoteType.audioRecording, audioRecordingData: AudioRecordingData(urlString: "")),
            NoteData(pageId: pageId, notePosition: 1, noteType: NoteType.text, textData: TextData()),
            NoteData(pageId: pageId, notePosition: 3, noteType: NoteType.text, textData: TextData()),
            NoteData(pageId: pageId, notePosition: 4, noteType: NoteType.audioRecording, audioRecordingData: AudioRecordingData(urlString: ""))
        ]
    mockPageData.notesData = mockNotes
    preview.addExamples([mockPageData])
    
    return NotesList(pageId: mockPageData.pageId)
        .modelContainer(preview.container)
}
