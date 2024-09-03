import SwiftUI
import AVFAudio
import SwiftData

// Shows the AudioRecordingData, handles playing interactions/
struct AudioRecordingView: View {
    @Bindable var audioRecordingData: AudioRecordingData
    @State private var audioPlayer: AVAudioPlayer?
    @ObservedObject private var playerDelegate = AudioPlayerDelegate()
    
    // TODO: Decide if should be injected
    let currentDocumentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    @State var sliderValue : Double = 0
    @State var isEditing: Bool = false
    
    // Needs to change view to work
    @State private var settingsDetent = PresentationDetent.medium
    
    @State var saveTitle: String = ""
    @State var saveDetails: String = ""
    
    var body: some View {
        NavigationStack() {
            if (audioRecordingData.title != "") {
                Text(audioRecordingData.title)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 1)
            }
            
            if (audioRecordingData.details != "") {
                Text(audioRecordingData.details)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            ZStack{
                VStack(alignment: .leading) {
                    Slider(value: $sliderValue, in: 0...100, onEditingChanged: { editing in
                        // Handle pausing while moving slider
                        let wasPlaying = playerDelegate.isPlaying
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
                    }).tint(Color.accentColor)
                
                    HStack{
                        Button("",systemImage: "backward.end.circle.fill", action: rewindRecording)
                                .foregroundColor(Color.accentColor)
                                .font(.title)
                                .buttonStyle(BorderlessButtonStyle()) // Added to prevent all HStack buttons being called
                        
                        Button("", systemImage: playerDelegate.isPlaying ? "pause.fill" : "play.fill", action: {
                            playRecording()})
                                .foregroundColor(Color.accentColor)
                                .font(.title)
                                .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Text(audioRecordingData.dateCreated.formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.primary.opacity(0.8))

                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                    }
                }
            }
            .background(.clear)
            .onChange(of: playerDelegate.currentTime) { oldTimeValue, newTimeValue in
                handleTimeChange(currentTime: newTimeValue)
            }
            .onChange(of: playerDelegate.finishedPlaying) { oldValue, newValue in
                handleFinishedPlaying(newValue: newValue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            saveTitle = audioRecordingData.title
            saveDetails = audioRecordingData.details
            
            audioRecordingData.title = "..."
            audioRecordingData.details = "..."
            isEditing = true
        }
        .sheet(isPresented: $isEditing, onDismiss: {
            dismissSheet()
        }, content: {
            NavigationStack{
                EditAudioRecordingView(audioRecordingData: audioRecordingData, saveTitle: $saveTitle, saveDetails: $saveDetails)
            }
            .presentationDetents([.medium, .large], selection: $settingsDetent)
            .presentationBackgroundInteraction(.automatic)
            .padding()
        })
    }
    
    private func handleFinishedPlaying(newValue: Bool) {
        if (newValue) {
            rewindRecording()
            playerDelegate.finishedPlaying = false
        }
    }
    
    // Dismiss is called before OnDissapear from sheet
    private func dismissSheet() {
        // Variables get saved from editing in sheet
        audioRecordingData.title = saveTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        audioRecordingData.details = saveDetails.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (audioRecordingData.title == "Title") {
            audioRecordingData.title = ""
        }
        if (audioRecordingData.details == "Details") {
            audioRecordingData.details = ""
        }
        
        isEditing = false
    }
    
    func handleSliderChange() {
        guard let initializedAudioPlayer = audioPlayer
        else {
            initializePlaying()
            guard let initializedAudioPlayer = audioPlayer
            else{
                return
            }
            let newTime = sliderValue * initializedAudioPlayer.duration / 100
            playerDelegate.rewindTo(audioPlayer: initializedAudioPlayer, time: newTime)
            return
        }
        
        let newTime = sliderValue * initializedAudioPlayer.duration / 100
        playerDelegate.rewindTo(audioPlayer: initializedAudioPlayer, time: newTime)
    }
    
    func handleTimeChange(currentTime: TimeInterval){
        guard let initializedAudioPlayer = audioPlayer
        else{
            return
        }
        sliderValue = currentTime * 100 / initializedAudioPlayer.duration
    }
    
    // TODO: Implement pausing other audios when new is played
    func playRecording(){
        guard let audioPlayerInitialized = audioPlayer
        else{
            initializePlaying()
            // TODO: Standardize either using audioPlayer directly or through delegate functions
            audioPlayer?.play()
            playerDelegate.startTimer(audioPlayer: audioPlayer!)
            playerDelegate.isPlaying = true
            return
        }
        
        if(!audioPlayerInitialized.isPlaying){
            audioPlayerInitialized.play()
            playerDelegate.startTimer(audioPlayer: audioPlayer!)
            playerDelegate.isPlaying = true
        }else{
            audioPlayerInitialized.pause()
            playerDelegate.isPlaying = false
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
    
    func initializePlaying(){
        guard let audioURL = URL(string: "\(currentDocumentPath)\(audioRecordingData.urlString)")
        else{
            print("ERROR: Audio URL could not be initialized")
            return
        }
        
        if (!FileManager.default.fileExists(atPath: audioURL.path)) {
            print("ERROR: File does not exist at URL \(audioURL.path)")
            return
        }
                
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
    }
}

#Preview {
    let preview = Preview(AudioRecordingData.self)
    let audioRecordingData = AudioRecordingData.sampleAudioData
    preview.addExamples(audioRecordingData)
    
    return AudioRecordingView(audioRecordingData: audioRecordingData[4])
        .modelContainer(preview.container)
}
