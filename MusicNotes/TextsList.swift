//
//  TextsList.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/25/24.
//

import SwiftUI
import SwiftData

struct TextsList: View {
    @Query(sort: \TextData.dateCreated) private var textsData: [TextData]
    
    var body: some View {
        ScrollView {
            Grid(alignment: .top) {
                ForEach(textsData) { textData in
                    GridRow{
                        TextView(textData: textData)
                    }
                    // TODO: Fix bug so it can automatically be resized (and does not start without showing text)
                    .frame(minHeight: 100)
                }
            }
        }.frame(maxHeight: 400)
    }
}

#Preview {
    let preview = Preview(TextData.self)
    preview.addExamples(TextData.sampleTextData)
    return TextsList()
        .modelContainer(preview.container)
}
