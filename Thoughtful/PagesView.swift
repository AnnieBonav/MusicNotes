import SwiftUI
import SwiftData

struct PagesView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \PageData.lastModified) var pages: [PageData]
    
    var body: some View {
        NavigationStack {
            Group {
                if (!pages.isEmpty) {
                    VStack{
                        PagesList()
                    }.frame(maxWidth: .infinity)
                } else {
                    ContentUnavailableView{
                        Label("You have nowhere to write yet", systemImage: "note")
                            .imageScale(.large)
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
                        Spacer()
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        addPage()
                    }) {
                        Label("Add Page", systemImage: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("All Pages")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                LinearGradient(gradient: .init(colors: [Color.accentColor.opacity(0.06), Color.accentColor.opacity(0.02)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
    }
}

extension PagesView {
    
    private func addPage(){
        let newPage = PageData()
        context.insert(newPage)
        newPage.notesData = []
    }
}

#Preview("Empty Pages View") {
    SwiftDataViewer(preview: PreviewContainer(PageData.self)){
        PagesView()
    }
}

#Preview("Mock Pages View") {
    SwiftDataViewer(preview: PreviewContainer(PageData.self), items: PageData.mockPageData){
        PagesView()
    }
}
