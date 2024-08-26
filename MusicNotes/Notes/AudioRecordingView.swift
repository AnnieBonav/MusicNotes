//
//  AudioRecordingView.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/24/24.
//

import SwiftUI
import AVFAudio
import SwiftData

struct AudioRecordingView: View {
    @Bindable var audioRecordingData: AudioRecordingData
    
    @State private var audioPlayer: AVAudioPlayer?
    
    // TODO: Decide if should be injected
    let currentDocumentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    @State var isPlaying: Bool = false
    
    var body: some View {
        GroupBox(label: Label {
            Text(audioRecordingData.dateCreated.formatted(date: .abbreviated, time: .shortened))
        } icon: {
            Image(systemName: "music.quarternote.3")
        }) {
            if let title = audioRecordingData.title {
                Text(title)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let details = audioRecordingData.details {
                Text(details)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            ProgressView(value: 0.4, total: 1)
                .tint(.accentA).padding(.top)
            HStack{
                Button(action: rewindRecording) {
                    Label("", systemImage: "backward.end.circle.fill")
                        .foregroundColor(.accentA)
                }
                Button(action: { playRecording() }) {
                    Label("", systemImage: isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.accentA)
                }
            }
        }
    }
    
    // TODO: Decide if other audios should be paused when something played
    func playRecording(verbose: Bool = false){
        guard let audioPlayerInitialized = audioPlayer
        else{
            initializePlaying()
            // TODO: Check if could be cleaner (not use audioPlayer directly)
            audioPlayer?.play()
            isPlaying = true
            return
        }
        
        if(!audioPlayerInitialized.isPlaying){
            audioPlayerInitialized.play()
            isPlaying = true
            if (verbose) { print("IS Playing") }
        }else{
            audioPlayerInitialized.pause()
            isPlaying = false
            if (verbose) { print("NOT Playing") }
        }
    }
    
    func rewindRecording(){
        guard let audioPlayerInitialized = audioPlayer
        else{
            print("ERROR: audioPlayer is nil in rewindRecording")
            return
        }
        
        audioPlayerInitialized.currentTime = 0
    }
    
    func initializePlaying(verbose: Bool = false){
        guard let audioURL = URL(string: "\(currentDocumentPath)\(audioRecordingData.urlString)")
        else{
            print("ERROR: Audio URL could not be initialized")
            return
        }
        
        if (!FileManager.default.fileExists(atPath: audioURL.path)) {
            print("ERROR: File does not exist at URL \(audioURL.path)")
            return
        }
        
        if (verbose) { print("Audio URL: \(audioURL)\n") }
        
        do {
            let isReachable = try audioURL.checkResourceIsReachable()
        }
        catch {
            print("Error reaching audioURL: \(error)")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            
            // TODO: Check if prepareToPlay is needed
            audioPlayer!.prepareToPlay()
        } catch {
            print("Error initializing AVAudioPlayer: \(error)")
        }
        
        if (verbose) { print("Initialized Audio Player. File: \(audioPlayer!.url)") }
    }
}

#Preview {
    return AudioRecordingView(audioRecordingData: AudioRecordingData.sampleAudioData[4])
}
