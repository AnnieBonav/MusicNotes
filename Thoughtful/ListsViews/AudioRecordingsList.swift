import SwiftUI
import SwiftData

// Used to debug only AudioRecordingViews list rendering (helps with spotting errors on list that will translate to the overall Note render).
struct AudioRecordingsList: View {
    @Query(sort: \AudioRecordingData.dateCreated) private var audioRecordingsData: [AudioRecordingData]
    
    var body: some View {
        ScrollView{
            Grid(alignment: .top){
                ForEach(audioRecordingsData){ audioRecordingData in
                    GridRow{
                        AudioRecordingView(audioRecordingData: audioRecordingData)
                    }
                }
            }
        }.frame(maxHeight: 500)
    }
}

#Preview {
    let preview = Preview(AudioRecordingData.self)
    preview.addExamples(AudioRecordingData.sampleAudioData)
    return AudioRecordingsList()
        .modelContainer(preview.container)
}
