import SwiftUI
import SwiftData
import AVFoundation

@main
struct ThoughtfulApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            PagesView()
                .modelContainer(container)
        }
    }
    
    init(){
        let schema = Schema([TextData.self, AudioRecordingData.self, NoteData.self, PageData.self])
        let config = ModelConfiguration("NotesData", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            print("Error configuring ModelContainer: \(error.localizedDescription)")
            fatalError("Could not configure Container in Main.")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
