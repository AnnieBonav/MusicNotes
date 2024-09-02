import SwiftUI
import SwiftData
import AVFAudio

struct PageView: View {
    @Environment(\.modelContext) private var context
    
    let pageData: PageData
    let columnLayout: Array = Array(repeating: GridItem(), count: 1)
    @State var pageTitle: String = ""
    
    init(pageData: PageData){
        self.pageData = pageData
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(gradient: .init(colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    NotesList(pageId: pageData.pageId)
                    HStack{
                        Spacer()
                        Button(action: addTextData) {
                            Label("", systemImage: "plus.circle.fill")
                                .foregroundColor(.appBackground)
                                .font(.largeTitle)
                        }
                        RecordAudioView(pageData: pageData)
                        Spacer()
                    }
                    .padding(.top)
                    .background(Color.accentColor)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                }
            }
            .navigationTitle($pageTitle) // $ States it can be edited
            .navigationBarTitleDisplayMode(.inline)
            .tint(Color.accentColor)
        }
        .onAppear(){
            pageTitle = pageData.title
        }
        .onDisappear(){
            pageData.title = pageTitle
        }
        .tint(Color.accentColor)
    }
    
    private func addTextData() {
        withAnimation {
            let newTextData = TextData()
            let note = NoteData(pageId: pageData.pageId, notePosition: pageData.notesData!.count, noteType: NoteType.text, textData: newTextData)
            
            context.insert(note)
        }
    }
}

#Preview {
    let preview = Preview(PageData.self)
    
    let pageData = PageData(title: "Mock New Page")
    var mockNotes: [NoteData] = [
        NoteData(pageId: pageData.pageId, notePosition: 0, noteType: NoteType.text, textData: TextData(userText: "Hello! I am a Text")),
        NoteData(pageId: pageData.pageId, notePosition: 2, noteType: NoteType.text, textData: TextData(userText: "I am another text :))")),
        NoteData(pageId: pageData.pageId, notePosition: 1, noteType: NoteType.audioRecording, audioRecordingData: AudioRecordingData(title: "Title", details: "We are details!", urlString: ""))
    ]
    pageData.notesData = mockNotes
    preview.addExamples([pageData])
    
    return PageView(pageData: pageData)
        .modelContainer(preview.container)
}
