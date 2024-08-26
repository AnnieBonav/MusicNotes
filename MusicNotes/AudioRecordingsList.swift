//
//  AudioRecordingsList.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/25/24.
//

import SwiftUI
import SwiftData

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
        }
    }
}

#Preview {
    let preview = Preview(AudioRecordingData.self)
    preview.addExamples(AudioRecordingData.sampleAudioData)
    return AudioRecordingsList()
        .modelContainer(preview.container)
}
