import SwiftUI
import SwiftData
import AVFAudio

struct PageView: View {
    @Environment(\.modelContext) private var context
    @Bindable var pageData: PageData
    
    let columnLayout = Array(repeating: GridItem(), count: 1)
    
    // -- AUDIO
    @State private var audioRecorder: AVAudioRecorder?
    @State private var recordingSettings: [String: Any] = [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    @State private var audioRecordingURL: URL?
    @State private var isRecording: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(gradient: .init(colors: [.accentA.opacity(0.2), .accentA.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    NotesList(pageId: pageData.id)
//                    VStack{
//                        List{
//                            Section(content: {
//                                ForEach(pageData.notesData){noteData in
//                                    NoteView(noteData: noteData, textData: noteData.textData, audioRecordingData: noteData.audioRecordingData)
//                                }
//                                .onDelete(perform: { indexSet in
//                                    print("Deleting")
//                                })
//                                .listRowSeparator(.hidden)
//                                .listRowBackground(NoteBackground())
//                            })
//                        }
//                        .listRowSpacing(10)
//                        .scrollContentBackground(.hidden)
//                        Spacer()
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // -- NOTES LIST
                    
                    HStack{
                        Spacer()
                        Button(action: addTextData) {
                            Label("", systemImage: "plus.circle.fill")
                                .foregroundColor(.accentA)
                                .font(.largeTitle)
                        }
//                        RecordAudioView(pageData: pageData)
                        HStack{
                            Button(action: { record() }) {
                                Label("", systemImage: isRecording ? "stop.fill" : "record.circle.fill")
                                     .foregroundColor(.accentA)
                                     .font(.largeTitle)
                            }
                        }.onAppear(){
                            setupAudioSession()
                        }
                        
                        Spacer()
                    }
                    .padding(.top)
                    .background(.appBackground)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                }
            }
            .navigationTitle($pageData.title)
            .navigationBarTitleDisplayMode(.inline)
        }.tint(.accentA)
    }
    
    private func addTextData() {
        withAnimation {
            let newTextData = TextData()
            let note = NoteData(notePosition: pageData.notesData.count, textData: newTextData)
//            let note = NoteData(pageId: pageData.id, notePosition: pageData.notesData.count, textData: newTextData)
            
            print("Note to add: \(note)")
            pageData.notesData.append(note)
        }
    }
    
    // -- AUDIO RECORDING
    
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
    
    func record(){
        if(!isRecording){
            startRecording()
        }else{
            endRecording()
        }
    }
    
    private func startRecording(verbose: Bool = false){
        if (recorderPrepared()){
            audioRecorder?.record()
            isRecording = true
            if (verbose) { print("AudioView: Started recording")
            }
        }
    }
    
    private func recorderPrepared() -> Bool {
        do {
            audioRecordingURL = getNewFileName(verbose: true)
            audioRecorder = try AVAudioRecorder(url: audioRecordingURL!, settings: recordingSettings)
            audioRecorder?.prepareToRecord()
            
            return true
        } catch {
            // TODO: Check best practices on error handling
            print("Error preparing audio recorder: \(error)")
            return false
        }
    }
    
    func endRecording(verbose: Bool = false){
        audioRecorder?.stop()
        isRecording = false
        if (verbose) { print("AudioView: Ended recording") }
        
        let newAudioRecordingData = AudioRecordingData(urlString: audioRecordingURL!.lastPathComponent)
        let note = NoteData(notePosition: pageData.notesData.count, audioRecordingData: newAudioRecordingData)
//        let note = NoteData(pageId: pageData.id, notePosition: pageData.notesData.count, audioRecordingData: newAudioRecordingData)
        
        pageData.notesData.append(note)
    }
    
    func getNewFileName(verbose: Bool = false) -> URL {
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // ORIGINAL: MusicNotes_2024-08-24 18:15:50 +0000.m4a
        var fileName = "MusicNotes_\(Date.now).m4a"
        
        // FINAL: MusicNotes_2024-08-24_18-16-43_0000.m4a
        fileName = fileName.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "+", with: "").replacingOccurrences(of: ":", with: "-")
        
        let audioFilenameURL: URL = documentPath.appendingPathComponent(fileName)
        
        if verbose { print("Generated File Name: \(audioFilenameURL)") }
        
        return audioFilenameURL
    }
}

#Preview {
    let preview = Preview(TextData.self, AudioRecordingData.self, NoteData.self)
    
    let pageData = PageData(title: "Mock New Page")
    let textsData = TextData.sampleTextData
    let audioRecordingsData = AudioRecordingData.sampleAudioData
    
    var mockNotes: [NoteData] = [NoteData]()
    mockNotes.append(NoteData(notePosition: 0, textData: textsData[4]))
    mockNotes.append(NoteData(notePosition: 2, textData: textsData[1]))
    mockNotes.append(NoteData(notePosition: 1, audioRecordingData: audioRecordingsData[4]))
    
    preview.addExamples(textsData)
    preview.addExamples(audioRecordingsData)
    preview.addExamples(mockNotes)
    
    return PageView(pageData: pageData)
        .modelContainer(preview.container)
}
