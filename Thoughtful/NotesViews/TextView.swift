import Foundation
import SwiftData
import SwiftUI

// Shows the TextData with an edit field and handles interactions like size change.
struct TextView: View {
    @Environment(\.modelContext) var context
    @Bindable var textData: TextData
        
    var placeHolderText = "Write Something!"
    @State private var containsPlaceHolderText: Bool = false
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                TextEditor(text: $textData.userText)
                    .font(.system(size: textData.fontSize.value))
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .foregroundColor(
                        Color.primary
                            .opacity(containsPlaceHolderText ? 0.7 : 1)
                    )
                // TODO: Add deleting if null at closure?
                    .onTapGesture {
                        if (containsPlaceHolderText) {
                            textData.userText = ""
                            containsPlaceHolderText = false
                        }
                    }
                // TODO: Add having placeholder back
                if (isEditing) {
                    HStack {
                        ForEach(FontSize.allCases, id: \.self) { fontSize in
                            Button {
                                if (textData.fontSize != fontSize) {
                                    textData.fontSize = fontSize
                                    print("Setting to fontSize \(fontSize)")
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundColor(textData.fontSize.value == fontSize.value ? Color.accentColor : .clear)
                                        .frame(width: 20, height: 24)
                                    Text("A")
                                        .foregroundColor(textData.fontSize.value == fontSize.value ? .appBackground : Color.accentColor)
                                        .font(.system(size: fontSize.value, weight: .medium, design: .rounded))
                                        .frame(width: 20, height: 24, alignment: .center)
                                }
                            }
                        }.background(.gray.opacity(0.3))
                    }
                    .frame(maxWidth: .infinity,  alignment: .center)
                }
            }.onAppear {
                let originalFs = textData.fontSize
                textData.fontSize = .medium
                textData.fontSize = originalFs
                
                if(textData.userText == ""){
                    textData.userText = "Start writing!"
                }
                if(textData.userText == "Start writing!"){
                    containsPlaceHolderText = true
                }
                
                textData.fontSize = .medium
            }
            .swipeActions {
                Button("Delete", role: .destructive) {
                    textData.userText = "" // Need to delete because the value is in _binding_ mode
                    withAnimation {
                        context.delete(textData)
                    }
                }
            }
        }
        .background(.clear)
    }
}

#Preview {
    let preview = Preview(TextData.self)
    let textsData = TextData.sampleTextData
    preview.addExamples(textsData)
    
    return TextView(textData: textsData[4])
        .modelContainer(preview.container)
}
