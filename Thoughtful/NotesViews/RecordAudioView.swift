import SwiftUI
import AVFAudio
import SwiftData
import Foundation

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
    
    @State var seconds = 0
    @State var minutes = 0
    @State var timeString = "00:00"
    @State var timerRecord: Timer?
    
    @Binding var showRecordingSheet: Bool
    
    var body: some View {
        VStack {
            Label {
                Text("New Audio Recording")
                    .padding(.top)
            } icon: {
                Image(systemName: "waveform")
                    .symbolEffect(
                        .variableColor.iterative, isActive: isRecording)
            }
            .padding([.top], 20)
            .padding([.bottom], 2)
            
            Text(timeString)
                .font(.title)
            Spacer()
            
            HStack{
                Button(action: { record() }) {
                    Label("", systemImage: isRecording ? "stop.fill" : "record.circle.fill")
                        .foregroundColor(.accentColor)
                         .font(.largeTitle)
                         .padding(.bottom)
                         .padding(.top, 2)
                }
            }
        }.onAppear(){
            record()
        }
        .onDisappear(){
            cancelRecording()
//            endRecording()
        }
        .frame(maxWidth: .infinity)
        .background(.lightAccent)
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
            guard let validatedAuidoRecorder = audioRecorder
            else{
                return
            }
            validatedAuidoRecorder.prepareToRecord()
            validatedAuidoRecorder.record()
            
            isRecording = true
            timerRecord = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                seconds += 1
                
                if (seconds == 60) {
                    seconds = 0
                    minutes += 1
                }
                
                let timeString = String(format: "%02d:%02d", minutes, seconds)
                self.timeString = timeString
            })
            if (verbose) { print("AudioView: Started recording")
            }
        }
    }
    
    private func recorderPrepared() -> Bool {
        do {
            audioRecordingURL = getNewFileName(verbose: true)
            audioRecorder = try AVAudioRecorder(url: audioRecordingURL!, settings: recordingSettings)
            return true
        } catch {
            // TODO: Check best practices on error handling
            print("Error preparing audio recorder: \(error)")
            return false
        }
    }
    
    func cancelRecording(){
        guard let validatedAudioRecorder = audioRecorder
        else{
            return
        }
        validatedAudioRecorder.stop()
        
        isRecording = false
        timerRecord?.invalidate()
        seconds = 0
        minutes = 0
    }
    
    func endRecording(verbose: Bool = false){
        guard let validatedAudioRecorder = audioRecorder
        else{
            return
        }
        validatedAudioRecorder.stop()
        
        isRecording = false
        timerRecord?.invalidate()
        seconds = 0
        minutes = 0
        
        if (verbose) { print("AudioView: Ended recording") }
        
        let newAudioRecordingData = AudioRecordingData(urlString: audioRecordingURL!.lastPathComponent)
        
        context.insert(newAudioRecordingData)
        
        let note = NoteData(pageId: pageData.pageId, notePosition: pageData.notesData!.count, noteType: NoteType.audioRecording, audioRecordingData: newAudioRecordingData)
        
        context.insert(note)
        newAudioRecordingData.noteData = note // Without adding the Audio Recording first, it creates a duplicate registration attempt
        
        note.pageData = pageData
        
        showRecordingSheet = false
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
    
    @State var isShowing: Bool = false
    return RecordAudioView(pageData: mockPageData, showRecordingSheet: $isShowing)
        .modelContainer(preview.container)
}
