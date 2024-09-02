import Foundation

// Used for testing AudioRecordingView preview.
extension AudioRecordingData {
    static let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
    static let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!
    static var sampleAudioData: [AudioRecordingData]{
        [
            AudioRecordingData(urlString: "/Users/annie/Downloads/MockAudio.mp3"),
            AudioRecordingData(dateCreated: yesterday, title: "I Was created Yesterday", urlString: "/Users/annie/Downloads/MockAudio.mp3"),
            AudioRecordingData(dateCreated: tomorrow, title: "I am an Audio from tomorrow!", urlString: "/Users/annie/Downloads/MockAudio.mp3"),
            AudioRecordingData(title: "I am an Audio with default Date!", urlString: "/Users/annie/Downloads/MockAudio.mp3"),
            AudioRecordingData(dateCreated: yesterday, title: "I am the same audio lol...", details: "...but from like yesterday and with a description! .but from like yesterday and with a description! .but from like yesterday and with a description!", urlString: "/Users/annie/Downloads/MockAudio.mp3")
        ]
    }
}
