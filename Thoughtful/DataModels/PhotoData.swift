import SwiftData
import Foundation

enum Location: String, Codable {
    case resources, documents
}

@Model
final class PhotoData{
    var fileName: String?
    var location = Location.documents
    
    init(
        fileName: String? = nil) {
        self.fileName = fileName
    }
    
    var url: URL? {
        if location == .resources {
            if let jpegImage = Bundle.main.url(forResource: fileName, withExtension: "jpeg") {
                return jpegImage
            } else {
                return Bundle.main.url(forResource: fileName, withExtension: "png")
            }
        } else {
            guard let fileName else {
                return nil
            }
            let documentDirectory = FileManager.default.documentDirectory
            return documentDirectory.appendingPathComponent(fileName)
        }
    }
}
