import UIKit

struct UnsplashResponse: Codable {
    let urls: URLSet
    let description: String?
    let user: User
    let title: String?

    struct URLSet: Codable {
        let regular: String
    }

    struct User: Codable {
        let name: String
    }
}
