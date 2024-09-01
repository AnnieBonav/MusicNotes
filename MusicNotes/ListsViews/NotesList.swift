import SwiftUI
import SwiftData

// Is the overall render of all NotesTypes. Serves as body of a single app Page.
struct NotesList: View {
    @Query(sort: \NoteData.notePosition) var notesData: [NoteData]
    @State var pageId: UUID
    
    let columnLayout = Array(repeating: GridItem(), count: 1)
    
    var body: some View {
        VStack{
            List{
                Section(content: {
                    ForEach(notesData){noteData in
                        if(noteData.pageId == pageId){
                            NoteView(noteData: noteData, textData: noteData.textData, audioRecordingData: noteData.audioRecordingData)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        print("Deleting")
                    })
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
    var preview = Preview(PageData.self)
    var mockPageData = PageData.mockPageData[0]
    let pageId = mockPageData.pageId
    var mockNotes =
        [
            NoteData(pageId: pageId, notePosition: 0, textData: TextData(), audioRecordingData: AudioRecordingData(urlString: "")),
            NoteData(pageId: pageId, notePosition: 2, textData: nil, audioRecordingData: AudioRecordingData(urlString: "")),
            NoteData(pageId: pageId, notePosition: 1, textData: TextData(), audioRecordingData: AudioRecordingData(urlString: "")),
            NoteData(pageId: pageId, notePosition: 3, textData: TextData(), audioRecordingData: AudioRecordingData(urlString: "")),
            NoteData(pageId: pageId, notePosition: 4, textData: nil, audioRecordingData: AudioRecordingData(urlString: ""))
        ]
    mockPageData.notesData = mockNotes
    preview.addExamples([mockPageData])
    
    return NotesList(pageId: mockPageData.pageId)
        .modelContainer(preview.container)
//    return NotesList(notesData: [NoteData(notePosition: 0, textData: TextData()), NoteData(notePosition: 1, audioRecordingData: AudioRecordingData(urlString: ""))])
}
