//
//  EditAudioRecordingView.swift
//  Thoughtful
//
//  Created by Ana Bonavides Aguilar on 9/1/24.
//

import SwiftUI

struct EditAudioRecordingView: View {
    @State var audioRecordingData: AudioRecordingData
    
    @State private var settingsDetent = PresentationDetent.medium
    @State private var detailsContainsPlaceHolderText: Bool = false
    
    // Is comming from AudioRecordingView
    @Binding var saveTitle: String
    @Binding var saveDetails: String
    
    var body: some View {
        VStack {
            Label {
                Text(audioRecordingData.dateCreated.formatted(date: .abbreviated, time: .shortened))
                    .padding(.top)
            } icon: {
                Image(systemName: "music.quarternote.3")
            }.padding(.top)
            
            VStack {
                TextField("Title", text: $saveTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .foregroundColor(.primary)
            }.background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.lightAccent)
            }
            
            
            VStack {
                TextEditor(text: $saveDetails)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .foregroundColor(
                        Color.primary
                            .opacity(detailsContainsPlaceHolderText ? 0.5 : 1)
                    )
                    .onTapGesture {
                        if (detailsContainsPlaceHolderText) {
                            saveDetails = ""
                            detailsContainsPlaceHolderText = false
                        }
                    }
            }.background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.lightAccent)
            }
        }.onAppear(){
            if (saveDetails == "") {
                saveDetails = "Details"
                detailsContainsPlaceHolderText = true
            }
            if (saveDetails == "Details") {
                detailsContainsPlaceHolderText = true
            }
        }
    }
}

// To preview see in AudioRecordingView
