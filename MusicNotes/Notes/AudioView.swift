//
//  AudioView.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/23/24.
//

import SwiftUI
import AVFAudio

struct AudioView: View {
    @Environment(\.modelContext) var context
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var recordingSettings: [String: Any] = [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    // TODO: Change recording URL to take the data from AudioData instance
    @State var audioRecordingURL: URL
    
    var body: some View {
        GroupBox(label: Label("Audio will be nice :)", systemImage: "building.columns")
            ){
            HStack{
                Button(action: startRecording) {
                    Label("", systemImage: "record.circle.fill")
                         .foregroundColor(.accentA)
                }
                
                Button(action: endRecording) {
                    Label("", systemImage: "stop.fill")
                         .foregroundColor(.accentA)
                }
                
                Button(action: playRecording) {
                    Label("", systemImage: "play.fill")
                         .foregroundColor(.accentA)
                }
            }
        }.onAppear(){
            setupAudioSession()
        }
    }
    
    private func setupAudioSession() {
        do {
            // TODO: understand more what this is for
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("OOPS, something failed creating the audio Session")
        }
    }
    
    func startRecording(){
        if (recorderPrepared()){
            print("Started recording")
            audioRecorder?.record()
        }
    }
    
    private func recorderPrepared() -> Bool {
        do {
            audioRecordingURL = getFileName(verbose: true)
            audioRecorder = try AVAudioRecorder(url: audioRecordingURL, settings: recordingSettings)
            audioRecorder?.prepareToRecord()
            
            return true
        } catch {
            // TODO: Check best practices on error handling
            print("Error preparing audio recorder: \(error)")
            return false
        }
    }
    
    func endRecording(){
        print("Ended recording")
        audioRecorder?.stop()
        
        context.insert(AudioRecordingData(urlString: audioRecordingURL.absoluteString))
    }
    
    func getFileName(verbose: Bool = false) -> URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // ORIGINAL: MusicNotes_2024-08-24 18:15:50 +0000.m4a
        var fileName = "MusicNotes_\(Date.now).m4a"
        
        // FINAL: MusicNotes_2024-08-24_18:16:43_0000.m4a
        fileName = fileName.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "+", with: "")
        
        let audioFilenameURL: URL = documentPath.appendingPathComponent(fileName)
        
        if verbose { print(audioFilenameURL)}
        
        return audioFilenameURL
    }
    
    func playRecording() {
        // TODO: Add getting correct URL from AudioView component
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecordingURL)
            audioPlayer?.play()
        } catch {
            print("couldn't load the file")
        }
    }
    
    func requestRecordPermission() {
        Task { @MainActor in
            AVAudioApplication.requestRecordPermission() { wasCompleted in
                if wasCompleted {
                    print("Granted")
                } else {
                    print("Denied")
                }
            }
        }
    }
}

#Preview {
    AudioView(audioRecordingURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]) // audioData: AudioData.sampleAudioData[-1]
}
