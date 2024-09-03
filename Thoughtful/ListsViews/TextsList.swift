import SwiftUI
import SwiftData

// Used to debug only TextViews list rendering (helps with spotting errors on list that will translate to the overall Note render).
struct TextsList: View {
    @Query(sort: \TextData.dateCreated) private var textsData: [TextData]
    
    var body: some View {
        VStack{
            List{
                Section(content: {
                    ForEach(textsData) { textData in
                        TextView(textData: textData)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(NoteBackground())
                }, header: {
                    Text("I am a title")
                        .font(.title)
                })
            }
            .listRowSpacing(10)
            .scrollContentBackground(.hidden)
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    let preview = Preview(TextData.self)
    preview.addExamples(TextData.sampleTextData)
    return TextsList()
        .modelContainer(preview.container)
}
