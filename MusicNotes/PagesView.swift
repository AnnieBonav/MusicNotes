import SwiftUI
import SwiftData

struct PagesView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \PageData.lastModified) var pages: [PageData]
    
    var body: some View {
        NavigationStack{
            Group{
                if(pages.isEmpty) {
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
                        .tint(.accentA)
                        .padding(.bottom)
                    }
                }else{
                    PagesList()
                        .toolbar {
                            ToolbarItemGroup(placement: .bottomBar) {
                                Spacer()
                                Button("Press Me", systemImage: "plus.circle.fill") {
                                    addPage()
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                                .buttonBorderShape(.circle)
                                .font(.largeTitle)
                                .tint(.accentA)
                                .foregroundColor(.accentA)
                            }
                        }
                }
            }
            .navigationTitle("Pages")
        }.background(.accentA)
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
