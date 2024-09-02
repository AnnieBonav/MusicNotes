import Foundation

// Used for testing TextView preview.
extension TextData {
    static let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!
    static let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
    static var sampleTextData: [TextData] {
        [
            TextData(userText: "I am a note about some songs I am doing this is so cool!"),
            TextData(dateCreated: lastWeek, userText: "Songs song...music music...Notes notes???"),
            TextData(dateCreated: lastMonth, lastModified: lastWeek, userText: "I do not know what to write about anymore lol but like lets pretend I am a note and stuff and also I like lemon chips."),
            TextData(dateCreated: lastMonth, lastModified: lastWeek, userText: "Interesting because I am also a note!"),
            TextData(dateCreated: lastMonth, lastModified: lastWeek, userText: "I am the same as last but I am bigger!", fontSize: FontSize.large),
            TextData(dateCreated: lastMonth, lastModified: lastWeek, userText: "I am super smaller lol...", fontSize: .small),
            TextData(dateCreated: lastMonth, lastModified: lastWeek, userText: "I am medium...", fontSize: .medium),
            TextData(dateCreated: lastMonth, lastModified: lastWeek, userText: "Am I?", fontSize: .small)
        ]
    }
}
