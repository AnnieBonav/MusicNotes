import SwiftUI
import SwiftData
import AVFAudio

struct ActionButton: View {
    let action: () -> Void
    let imageName: String
    
    var body: some View {
        Button (action: {
            action()
        }) { Image(systemName: "\(imageName)")
                .font(.largeTitle)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .controlSize(.large)
        .font(.title2)
        .tint(.accentColor.opacity(0.6))
        .foregroundColor(.accentColor)
    }
}

struct PageView: View {
    @Environment(\.modelContext) private var context
    @Query var notesData: [NoteData]
    
    let pageData: PageData
    
    let columnLayout: Array = Array(repeating: GridItem(), count: 1)
    @State var pageTitle: String = ""
    
    init(pageData: PageData, pageId: UUID){
        self.pageData = pageData
        
        let sortDescriptors: [SortDescriptor<NoteData>] = [SortDescriptor(\NoteData.notePosition)]
        
        let predicate = #Predicate<NoteData> { noteData in
            noteData.pageId == pageId
        }
        _notesData = Query(filter: predicate, sort: sortDescriptors)
    }
    
    @State private var settingsDetent = PresentationDetent.fraction(0.25)
    @State private var showRecordingSheet = false
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(gradient: .init(colors: [Color.accentColor.opacity(0.08), Color.accentColor.opacity(0.07)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    if(!notesData.isEmpty){
                        NotesList(notesData: notesData, addTextDataFunc: addTextData, addAudioRecordingDataFunc: toggleShowRecordingSheet)
                    } else {
                        ContentUnavailableView{
                            Label("You have no notes yet", systemImage: "note.text")
                                .imageScale(.large)
                        } description: {
                            Text("Add a text or audio!").font(.title)
                        } actions: {
                            HStack {
                                ActionButton(action: addTextData, imageName: "square.and.pencil.circle")
                                ActionButton(action: toggleShowRecordingSheet, imageName: "waveform.circle")
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    
                }
                .sheet(isPresented: $showRecordingSheet, content: {
                    NavigationStack {
                        RecordAudioView(pageData: pageData, showRecordingSheet: $showRecordingSheet)
                    }
                    .presentationDetents([.fraction(0.25)], selection: $settingsDetent)
                    .presentationBackgroundInteraction(.automatic)
                    .presentationDragIndicator(.visible)
                })
            }
            .navigationTitle($pageTitle) // $ States it can be edited
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(){
            setupAudioSession()
            pageTitle = pageData.title
        }
        .onDisappear(){
            pageData.title = pageTitle
        }
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("OOPS, something failed creating the audio Session")
        }
    }
    
    func addTextData() {
        withAnimation {
            let newTextData = TextData()
            context.insert(newTextData)
            
            let note = NoteData(pageId: pageData.pageId, notePosition: pageData.notesData!.count, noteType: NoteType.text, textData: newTextData)
            context.insert(note)
            
            newTextData.noteData = note
            note.pageData = pageData
        }
    }
    
    func toggleShowRecordingSheet(){
        if (showRecordingSheet) {
            showRecordingSheet = false
        }else{
            showRecordingSheet = true
        }
    }
}

#Preview {
    let preview = Preview(PageData.self)
    
    let pageData = PageData(title: "Mock New Page")
    var mockNotes: [NoteData] = [
//        NoteData(pageId: pageData.pageId, notePosition: 0, noteType: NoteType.text, textData: TextData(userText: "Hello! I am a Text")),
//        NoteData(pageId: pageData.pageId, notePosition: 2, noteType: NoteType.text, textData: TextData(userText: "I am another text :))")),
//        NoteData(pageId: pageData.pageId, notePosition: 1, noteType: NoteType.audioRecording, audioRecordingData: AudioRecordingData(title: "Title", details: "We are details!", urlString: ""))
    ]
    pageData.notesData = mockNotes
    preview.addExamples([pageData])
    
    return PageView(pageData: pageData, pageId: pageData.pageId)
        .modelContainer(preview.container)
}
