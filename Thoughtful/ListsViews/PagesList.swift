import SwiftUI
import SwiftData

struct PageBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .foregroundColor(.lightAccent.opacity(0.8))
            .background(.ultraThinMaterial)
    }
}

struct PagesList: View {
    @Environment(\.modelContext) var context
    @Query(sort: \PageData.lastModified) var pages: [PageData]
    
    @State private var savedIndexSet: IndexSet?
    @State private var showingDeleteAlert: Bool = false
    var body: some View {
        List{
            Section(content: {
                ForEach(pages) { page in
                    NavigationLink {
                        PageView(pageData: page, pageId: page.pageId) // Sending pageId from here avoid error of .padeId comparison
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
                    }
                    .isDetailLink(false)
                    .tint(.primary)
                }
                .onDelete { indexSet in
                    savedIndexSet = indexSet
                    showingDeleteAlert = true
                }
                .alert(
                    isPresented: $showingDeleteAlert
                ) {
                    let pageString = savedIndexSet?.count == 1 ?
                    """
                    \n"\(pages[savedIndexSet!.first!].title)"
                    """ : "multiple pages"
                    return Alert(title: Text("Confirm delete"),
                        message: Text("Are you sure you want to delete \(pageString)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            deletePage()
                        },
                        secondaryButton: .cancel() {
                            savedIndexSet = nil
                        })
                    }
                .listRowBackground(PageBackground())
            })
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
    let preview = Preview(PageData.self)
    let pages = PageData.mockPageData
    
    preview.addExamples(pages)
    return PagesList()
        .modelContainer(preview.container)
}
