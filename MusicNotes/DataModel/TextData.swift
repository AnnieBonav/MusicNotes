//
//  TextData.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/22/24.
//

import Foundation
import SwiftData

@Model
final class TextData {
    var dateCreated: Date
    var lastModified: Date
    var text: String
    var fontSize: FontSize
    
    init(
        dateCreated: Date = Date.now,
        lastModified: Date = Date.now,
        
         // TODO: Choose if there can be a no-text TextData or if it is automatically removed
         text: String = "Start writing!",
         fontSize: FontSize = .medium
    ) {
        self.dateCreated = dateCreated
        self.lastModified = lastModified
        self.text = text
        self.fontSize = fontSize
    }
}

enum FontSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
    
    var value: CGFloat {
        switch self {
        case .small:
            return 12.0
        case .medium:
            return 16.0
        case .large:
            return 20.0
        }
    }
}
