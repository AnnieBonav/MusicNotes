import Foundation
import AVFAudio

// Used to handle an audioRecording state on its view.
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
    
    func rewindTo(audioPlayer: AVAudioPlayer, time: TimeInterval) {
        var newTime: Double
        if(time <= 0){
            newTime = 0
        }else if (time < audioPlayer.duration){
            newTime = time
        }else{
            newTime = audioPlayer.duration
        }
        
        audioPlayer.currentTime = newTime
        self.currentTime = newTime
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
