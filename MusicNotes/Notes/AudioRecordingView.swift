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
    @ObservedObject private var playerDelegate = AudioPlayerDelegate()
    
    // TODO: Decide if should be injected
    let currentDocumentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    @State var sliderValue : Double = 0
    
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
                    .padding(.top, 1)
            }
            
            if let details = audioRecordingData.details {
                Text(details)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Slider(value: $sliderValue, in: 0...100, onEditingChanged: { editing in
                // Handle pausing while moving slider
                var wasPlaying = playerDelegate.isPlaying
                if (editing) {
                    if (wasPlaying) {
                        audioPlayer!.pause()
                    }
                }else{
                    handleSliderChange()
                    if (wasPlaying){
                        audioPlayer!.play()
                    }
                }
            })
                .tint(.accentA).padding(.top)
                
            HStack{
                Button(action: rewindRecording) {
                    Label("", systemImage: "backward.end.circle.fill")
                        .foregroundColor(.accentA)
                        .font(.title)
                }
                Button(action: { playRecording() }) {
                    Label("", systemImage: playerDelegate.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.accentA)
                        .font(.title)
                }
            }
        }.onChange(of: playerDelegate.currentTime){ newTimeValue in
            handleTimeChange(currentTime: newTimeValue)
        }
        // TODO: Change so when timer ends playerDelegate go backs to beginning (can be inside Delegate)
    }
    
    func handleSliderChange() {
        let newTime = sliderValue * audioPlayer!.duration / 100
        playerDelegate.rewindTo(audioPlayer: audioPlayer!, time: newTime)
    }
    
    func handleTimeChange(currentTime: TimeInterval){
        sliderValue = currentTime * 100 / audioPlayer!.duration
    }
    
    // TODO: Decide if other audios should be paused when something played
    func playRecording(verbose: Bool = false){
        guard let audioPlayerInitialized = audioPlayer
        else{
            initializePlaying()
            // TODO: Check if could be cleaner (not use audioPlayer directly)
            audioPlayer?.play()
            playerDelegate.startTimer(audioPlayer: audioPlayer!)
            playerDelegate.isPlaying = true
            return
        }
        
        if(!audioPlayerInitialized.isPlaying){
            audioPlayerInitialized.play()
            playerDelegate.startTimer(audioPlayer: audioPlayer!)
            playerDelegate.isPlaying = true
            if (verbose) { print("IS Playing") }
        }else{
            audioPlayerInitialized.pause()
            playerDelegate.isPlaying = false
            if (verbose) { print("NOT Playing") }
        }
    }
    
    func rewindRecording(){
        guard let audioPlayerInitialized = audioPlayer
        else{
            print("ERROR: audioPlayer is nil in rewindRecording")
            return
        }
        playerDelegate.rewindTo(audioPlayer: audioPlayerInitialized, time: 0)
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
            _ = try audioURL.checkResourceIsReachable()
        }
        catch {
            print("Error reaching audioURL: \(error)")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            
            // TODO: Check if prepareToPlay is needed
            audioPlayer!.prepareToPlay()
            audioPlayer!.delegate = playerDelegate
        } catch {
            print("Error initializing AVAudioPlayer: \(error)")
        }
        
        if (verbose) { print("Initialized Audio Player. File: \(audioPlayer!.url)") }
    }
}

#Preview {
    let preview = Preview(AudioRecordingData.self)
    let audioRecordingData = AudioRecordingData.sampleAudioData
    preview.addExamples(audioRecordingData)
    
    return AudioRecordingView(audioRecordingData: audioRecordingData[4])
        .modelContainer(preview.container)
}
