import Foundation

extension PageData{
    static let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
    static let today = Date.now
    
    static var mockPageData: [PageData] {
        [
            PageData(title: "My first page!", dateCreated: yesterday, lastModified: today),
            PageData(title: "My Second page!", dateCreated: today, lastModified: today)
        ]
    }
}
