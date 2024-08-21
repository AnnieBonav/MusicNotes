//
//  TextView.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/19/24.
//

import Foundation
import SwiftData
import SwiftUI

struct TextView: View {
    var accentA = Color(.accentA)
    var accentB = Color(.accentB)
    var backgroundColor = Color(.appBackground)
    
    var placeHolderText = "Write Here!"
    @State private var fullText: String = "Write Here!"
    
    var containsPlaceHolderText: Bool {
        fullText == placeHolderText
    }
    
    @State private var fontSize: CGFloat = FontSize.medium.rawValue // Default font size

    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $fullText) // (text: $value.text)
                .font(.system(size: fontSize))
                .foregroundColor(
                        Color.primary
                        .opacity(containsPlaceHolderText ? 0.7 : 1)
                )
                .onTapGesture {
                    if containsPlaceHolderText {
                        fullText = ""
                    }
                }
            HStack {
                ForEach(FontSize.allCases, id: \.self) { fs in
                    Button {
                        fontSize = fs.rawValue
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(fontSize == fs.rawValue ? accentA : .clear)
                                .frame(width: 20, height: 24)
                            Text("A")
                                .foregroundColor(fontSize == fs.rawValue ? backgroundColor : accentA)
                                .font(.system(size: fs.rawValue, weight: .medium, design: .rounded))
                                .frame(width: 20, height: 24, alignment: .center)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity,  alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding()
    }
    
}

struct TextView_Previews : PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
