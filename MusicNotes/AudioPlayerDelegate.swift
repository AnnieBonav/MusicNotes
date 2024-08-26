//
//  AudioPlayerDelegate.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/26/24.
//

import Foundation
import AVFAudio

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate, ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    private var timer: Timer?

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        stopTimer()
    }
    
    func startTimer(audioPlayer: AVAudioPlayer) {
        stopTimer()  // Ensure no previous timer is running
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            self.currentTime = audioPlayer.currentTime
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func pauseAudio(audioPlayer: AVAudioPlayer) {
        audioPlayer.pause()
        isPlaying = false
        stopTimer()
    }
}
