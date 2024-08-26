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
    @State var isPlaying: Bool = false
    
    var body: some View {
        GroupBox(label: Label {
            Text(audioRecordingData.dateCreated, style: .date)
        } icon: {
            Image(systemName: "music.quarternote.3")
        }) {
            if (audioRecordingData.title != nil) {
                // TODO: Check why ! is needed if check was made
                Text(audioRecordingData.title!)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if (audioRecordingData.details != nil) {
                Text(audioRecordingData.details!)
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
                Button(action: playRecording) {
                    Label("", systemImage: isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.accentA)
                }
            }
        }
    }
    
    func playRecording(){
        // TODO: Check if something else is playing?
        do {
            if let audioURL = URL(string: audioRecordingData.urlString){
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer?.play()
            }
        } catch {
            print("Couldn't initialize AV Audio Player. URL: \(audioRecordingData.urlString)")
        }
    }
    
    func rewindRecording(){
        // TODO: Implement rewinding
    }
    
}

#Preview {
    return AudioRecordingView(audioRecordingData: AudioRecordingData.sampleAudioData[4])
}
