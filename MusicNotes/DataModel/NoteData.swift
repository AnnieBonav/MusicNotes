//
//  NoteData.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/27/24.
//

import Foundation
import SwiftData

enum NoteType: String, CaseIterable, Codable {
    case notDefined
    case text
    case audioRecording
}

@Model
final class NoteData { // Will take the last data that was chosen as noteType
    var noteType: NoteType
    
    var textData: TextData?
    var audioRecordingData: AudioRecordingData?
    
    var notePosition: Int
    
    init(notePosition: Int,
         textData: TextData? = nil,
         audioRecordingData: AudioRecordingData? = nil) {
        
        self.notePosition = notePosition
        if(textData != nil){
            noteType = NoteType.text
            self.textData = textData
        }else if (audioRecordingData != nil){
            noteType = NoteType.audioRecording
            self.audioRecordingData = audioRecordingData
        }else{
            noteType = NoteType.notDefined
        }
    }
}
