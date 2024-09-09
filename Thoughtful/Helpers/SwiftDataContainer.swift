import SwiftData
import SwiftUI

struct SwiftDataViewer<Content: View>: View {
    private let content: Content
    private let preview: Preview
    private let items: [any PersistentModel]?
    
    init(
        preview: Preview,
        items: [any PersistentModel]? = nil,
        @ViewBuilder _ content: () -> Content
    ) {
        self.preview = preview
        self.items = items
        self.content = content()
    }
    
    var body: some View {
        content
            .modelContainer (preview.container)
            .onAppear (perform: {
                if let items {
                    preview.addExamples(items)
                }
            })
    }
}
