import Foundation
import SwiftData
import SwiftUI

// Shows the TextData with an edit field and handles interactions like size change.
struct TextView: View {
    @Bindable var textData: TextData
        
    var placeHolderText = "Write Something!"
    
    @State private var containsPlaceHolderText: Bool = false
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                TextEditor(text: $textData.text)
                    .font(.system(size: textData.fontSize.value))
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .foregroundColor(
                        Color.primary
                            .opacity(containsPlaceHolderText ? 0.7 : 1)
                    )
                // TODO: Add deleting if null at closure?
                    .onTapGesture {
                        if containsPlaceHolderText {
                            textData.text = ""
                            containsPlaceHolderText = false
                        }
                    }
                // TODO: Add having placeholder back
                HStack {
                    ForEach(FontSize.allCases, id: \.self) { fs in
                        Button {
                            textData.fontSize = fs
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(textData.fontSize.value == fs.value ? .accentA : .clear)
                                    .frame(width: 20, height: 24)
                                Text("A")
                                    .foregroundColor(textData.fontSize.value == fs.value ? .appBackground : .accentA)
                                    .font(.system(size: fs.value, weight: .medium, design: .rounded))
                                    .frame(width: 20, height: 24, alignment: .center)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity,  alignment: .center)
                .onAppear{
                    let originalFs = textData.fontSize
                    textData.fontSize = .small
                    textData.fontSize = originalFs
                    
                    if(textData.text == ""){
                        textData.text = "Start writing!"
                    }
                    if(textData.text == "Start writing!"){
                        containsPlaceHolderText = true
                    }
                    
                    textData.fontSize = .small
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
