import UIKit

protocol FavoritesModelProtocol {
}

class FavoritesModel: FavoritesModelProtocol {
    private var favoriteImages: [UIImage] = []

    func getFavoriteImages() -> [UIImage] {
        return favoriteImages
    }

    func removeImage(at index: Int) {
        guard index >= 0 && index < favoriteImages.count else { return }
        favoriteImages.remove(at: index)
    }
}
