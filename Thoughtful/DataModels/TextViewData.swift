//
//  TextViewData.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/20/24.
//

import Foundation

struct TextData: Equatable, Codable {
    var text: String = "Write Something!"
    var fontSize: FontSize = .medium
}

enum FontSize: CGFloat, CaseIterable, Codable {
    case small = 16
    case medium = 20
    case large = 24
}
