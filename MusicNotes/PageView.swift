//
//  PageView.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/19/24.
//

import SwiftUI
import SwiftData


struct PageView: View {
    var backgroundColor = Color(.appBackground)
    
    var body: some View {
        VStack {
            Text("Page Title")
                .font(.title).padding(.top)
        }
        .padding(.leading).background(backgroundColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        TextView()
        Spacer()
    }
}

#Preview {
    PageView()
}
