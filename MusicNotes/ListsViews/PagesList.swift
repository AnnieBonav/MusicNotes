import SwiftUI
import SwiftData

struct PageBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .foregroundColor(.accentA.opacity(0.1))
            .background(.ultraThinMaterial)
    }
}

struct PagesList: View {
    @Environment(\.modelContext) var context
    @Query(sort: \PageData.lastModified) var pages: [PageData]
    
    @State private var confirmDelete: Bool = false
    @State private var savedIndexSet: IndexSet?
    var body: some View {
        List{
            Section(content: {
                ForEach(pages){page in
                    NavigationLink {
                        PageView(pageData: page)
                    } label:{
                        VStack(alignment: .leading){
                            Text(page.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.top, 8)
                            Text(page.dateCreated.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .padding(.bottom, 4)
                        }
                    }.tint(.primary)
                }
                // TODO: Add confirm delete
                .onDelete { indexSet in
                    savedIndexSet = indexSet
                    deletePage()
                }
                .listRowBackground(PageBackground())
            })
            .listRowSpacing(20)
            .listRowSeparatorTint(.white)
        }
        .scrollContentBackground(.hidden)
    }
    
    private func deletePage() {
        withAnimation {
            for index in savedIndexSet! {
                context.delete(pages[index])
            }
        }
    }
}

#Preview {
    var preview = Preview(PageData.self)
    let pages = PageData.mockPageData
    
    preview.addExamples(pages)
    return PagesList()
        .modelContainer(preview.container)
}
