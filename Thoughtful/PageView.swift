import SwiftUI
import SwiftData
import AVFAudio

struct PageView: View {
    @Environment(\.modelContext) private var context
    @Bindable var pageData: PageData
    
    let columnLayout = Array(repeating: GridItem(), count: 1)

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
            .navigationTitle($pageData.title)
            .navigationBarTitleDisplayMode(.inline)
            .tint(Color.accentColor)
        }.tint(Color.accentColor)
    }
    
    private func addTextData() {
        withAnimation {
            let newTextData = TextData()
            let note = NoteData(pageId: pageData.pageId, notePosition: pageData.notesData.count, noteType: NoteType.text, textData: newTextData)
            
            pageData.notesData.append(note)
        }
    }
}

#Preview {
    let preview = Preview(TextData.self, AudioRecordingData.self, NoteData.self)
    
    let pageData = PageData(title: "Mock New Page")
    let textsData = TextData.sampleTextData
    let audioRecordingsData = AudioRecordingData.sampleAudioData
    
    var mockNotes: [NoteData] = [NoteData]()
    mockNotes.append(NoteData(pageId: pageData.pageId, notePosition: 0, noteType: NoteType.text, textData: textsData[4]))
    mockNotes.append(NoteData(pageId: pageData.pageId, notePosition: 2, noteType: NoteType.text, textData: textsData[1]))
    mockNotes.append(NoteData(pageId: pageData.pageId, notePosition: 1, noteType: NoteType.audioRecording, audioRecordingData: audioRecordingsData[4]))
    
    preview.addExamples(textsData)
    preview.addExamples(audioRecordingsData)
    preview.addExamples(mockNotes)
    
    return PageView(pageData: pageData)
        .modelContainer(preview.container)
}
