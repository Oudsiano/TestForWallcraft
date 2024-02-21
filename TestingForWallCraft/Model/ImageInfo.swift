import UIKit

struct ImageInfo {
    let imageURL: String
    let title: String
    let description: String
    let author: String
    var image: UIImage?

    init(imageURL: String, title: String, description: String, author: String, image: UIImage?) {
        self.imageURL = imageURL
        self.title = title
        self.description = description
        self.author = author
        self.image = image
    }
}
