//
//  MusicNotesApp.swift
//  MusicNotes
//
//  Created by Ana Bonavides Aguilar on 8/19/24.
//

import SwiftUI
import SwiftData

@main
struct MusicNotesApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            PageView()
                .modelContainer(container)
        }
    }
    
    init(){
        let schema = Schema([TextData.self])
        let config = ModelConfiguration("TextData", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            print("Error configuring ModelContainer: \(error.localizedDescription)")
            fatalError("Could not configure Container in Main.")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
