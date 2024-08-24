//
//  AudioData.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/23/24.
//

import Foundation
import AVFAudio
import SwiftData

@Model
final class AudioData {
    var dateCreated: Date
    var title: String?
    var details: String?
    var urlString: String
    
    init(dateCreated: Date = Date.now,
         title: String? = nil,
         details: String? = nil,
         urlString: String
    ) {
        self.dateCreated = dateCreated
        self.title = title
        self.details = details
        self.urlString = urlString
    }
}
