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
            Label {
                Text(audioRecordingData.dateCreated.formatted(date: .abbreviated, time: .shortened))
            } icon: {
                Image(systemName: "music.quarternote.3")
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            
            if (audioRecordingData.title != "") {
                Text(audioRecordingData.title)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 1)
            }
            
            if (audioRecordingData.details != "") {
                Text(audioRecordingData.details)
                    .font(.caption)
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
                    }).tint(Color.accentColor).padding(.top)
                
                    HStack{
                        Button("",systemImage: "backward.end.circle.fill", action: rewindRecording)
                                .foregroundColor(Color.accentColor)
                                .font(.title)
                                .buttonStyle(BorderlessButtonStyle()) // Added to prevent all HStack buttons being called
                        
                        Button("", systemImage: playerDelegate.isPlaying ? "pause.fill" : "play.fill", action: {
                            playRecording(verbose: true)})
                                .foregroundColor(Color.accentColor)
                                .font(.title)
                                .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                }
            }
            .background(.clear)
            .onChange(of: playerDelegate.currentTime){oldTimeValue, newTimeValue in
                handleTimeChange(currentTime: newTimeValue)
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
            
        // TODO: Change so when timer ends playerDelegate go backs to beginning (can be inside Delegate)
    }
    
    // Dismiss is called before OnDissapear from sheet
    private func dismissSheet(){        
        // Variables get saved from editing in sheet
        audioRecordingData.title = saveTitle
        audioRecordingData.details = saveDetails
        
        if (audioRecordingData.title == "Title"){
            audioRecordingData.title = ""
        }
        if (audioRecordingData.details == "Details") {
            audioRecordingData.details = ""
        }
        
        isEditing = false
    }
    
    func handleSliderChange() {
        let newTime = sliderValue * audioPlayer!.duration / 100
        playerDelegate.rewindTo(audioPlayer: audioPlayer!, time: newTime)
    }
    
    func handleTimeChange(currentTime: TimeInterval){
        sliderValue = currentTime * 100 / audioPlayer!.duration
    }
    
    // TODO: Implement pausing other audios when new is played
    func playRecording(verbose: Bool = false){
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
        
        if (verbose) { print("Initialized Audio Player. File: \(String(describing: audioPlayer!.url))") }
    }
}

#Preview {
    let preview = Preview(AudioRecordingData.self)
    let audioRecordingData = AudioRecordingData.sampleAudioData
    preview.addExamples(audioRecordingData)
    
    return AudioRecordingView(audioRecordingData: audioRecordingData[4])
        .modelContainer(preview.container)
}
