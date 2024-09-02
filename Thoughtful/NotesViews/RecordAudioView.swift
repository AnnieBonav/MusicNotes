import SwiftUI
import AVFAudio
import SwiftData

// View currently shown on PageView to record new Audio
struct RecordAudioView: View {
    @Environment(\.modelContext) var context

    @State private var audioRecorder: AVAudioRecorder?
    @State private var recordingSettings: [String: Any] = [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    @State private var audioRecordingURL: URL?
    @State private var isRecording: Bool = false
    
    @State var pageData: PageData
    
    var body: some View {
        HStack{
            Button(action: { record() }) {
                Label("", systemImage: isRecording ? "stop.fill" : "record.circle.fill")
                    .foregroundColor(.appBackground)
                     .font(.largeTitle)
            }
        }.onAppear(){
            setupAudioSession()
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
        let note = NoteData(pageId: pageData.pageId, notePosition: pageData.notesData.count, noteType: NoteType.audioRecording, audioRecordingData: newAudioRecordingData)
        
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
    let preview = Preview(PageData.self)
    let mockPageData = PageData()
    preview.addExamples([mockPageData])
    
    return RecordAudioView(pageData: mockPageData)
        .modelContainer(preview.container)
}
