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
        VStack(alignment: .leading) {
            Text("Page Title")
                .font(.title).padding(.top)
            ScrollView {
                Grid(alignment: .top) {
                    GridRow{
                        TextView()
                    }
                    GridRow{
                        TextView()
                    }
                    // .gridCellUnsizedAxes([.horizontal, .vertical])
                }
            }
        }
        .padding(.horizontal).background(backgroundColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PageView()
}
