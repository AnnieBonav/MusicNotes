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
    var placeHolderText = "Write Something!"
    @State private var fullText: String = ""
    
    @State private var containsPlaceHolderText: Bool = false
    
    @State private var fontSize: CGFloat = FontSize.medium.rawValue // Default font size
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                TextEditor(text: $fullText)
                    .font(.system(size: fontSize))
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .foregroundColor(
                        Color.primary
                            .opacity(containsPlaceHolderText ? 0.7 : 1)
                    )
                    .onTapGesture {
                        if containsPlaceHolderText {
                            fullText = ""
                        }
                    }.onChange(of: fullText) { newValue in
                        containsPlaceHolderText = (newValue == placeHolderText)
                        // TODO: Add having placeholder back
                    }
                HStack {
                    ForEach(FontSize.allCases, id: \.self) { fs in
                        Button {
                            fontSize = fs.rawValue
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(fontSize == fs.rawValue ? .accentA : .clear)
                                    .frame(width: 20, height: 24)
                                Text("A")
                                    .foregroundColor(fontSize == fs.rawValue ? .appBackground : .accentA)
                                    .font(.system(size: fs.rawValue, weight: .medium, design: .rounded))
                                    .frame(width: 20, height: 24, alignment: .center)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity,  alignment: .center)
                .onAppear {
                    fullText = placeHolderText
                    containsPlaceHolderText = placeHolderText == fullText
                }
            }
        }
    }
}

struct TextView_Previews : PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
