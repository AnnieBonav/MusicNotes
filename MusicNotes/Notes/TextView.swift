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
    @Binding var value: TextData

    var placeHolderText = "Write Something"
    var containsPlaceHolderText: Bool {
        value.text == placeHolderText
    }
    
    var accentA = Color(.accentA)
    var accentB = Color(.accentB)
    var backgroundColor = Color(.appBackground)
    
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $value.text)
                .foregroundColor(
                        Color.black
                        .opacity(containsPlaceHolderText ? 0.7 : 1)
                )
                .onTapGesture {
                    if containsPlaceHolderText {
                        value.text = ""
                    }
                }
                .padding(.top)
            HStack {
                ForEach(FontSize.allCases, id: \.self) { fs in
                    Button {
                        value.fontSize = fs
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(value.fontSize == fs ? accentA : .clear)
                                .frame(width: 20, height: 24)
                            Text("A")
                                .foregroundColor(value.fontSize == fs ? backgroundColor : accentA)
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
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
}

struct TextView_Previews : PreviewProvider {
    static var previews: some View {
        TextView(value: .constant(TextData()))
    }
}
