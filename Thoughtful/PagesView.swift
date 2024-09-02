import SwiftUI
import SwiftData

struct PagesView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \PageData.lastModified) var pages: [PageData]
    
    @State var noPages: Bool = true
    var body: some View {
        NavigationStack{
            Group {
                if !pages.isEmpty  {
                    VStack{
                        PagesList()
                        HStack{
                            Spacer()
                            Button{
                                addPage()
                            } label: {
                                Label("", systemImage: "plus.circle.fill")
                                    .foregroundColor(.appBackground)
                                    .font(.largeTitle)
                            }
                            Spacer()
                        }
                        .padding(.top)
                        .background(Color.accentColor)
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea()
                    }.frame(maxWidth: .infinity)
                }else{
                    ContentUnavailableView{
                        Label("You have nowhere to write yet", systemImage: "note.text")
                    } description: {
                        Text("Start with a new Page!").font(.title)
                    } actions: {
                        Button {
                            addPage()
                        } label: {
                            Label("New Page", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .font(.title2)
                        .tint(Color.accentColor)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("All Pages")
            .background(.appBackground)
        }
    }
    
    private func addPage(){
        let newPage = PageData()
        context.insert(newPage)
    }
}

#Preview {
    var preview = Preview(PageData.self)
//    let pages = PageData.mockPageData
//    
//    preview.addExamples(pages)
    return PagesView()
        .modelContainer(preview.container)
}
