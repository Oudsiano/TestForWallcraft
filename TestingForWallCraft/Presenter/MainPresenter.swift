import Foundation
import UIKit

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapNextButton()
    func didTapLikeButton()
    func didTapFavoritesButton()
    func loadRandomImage(completion: @escaping (ImageInfo?) -> Void)
    func loadImagesInBackground(count: Int)
}

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var model: MainModelProtocol
    
    private var likedImages: [UIImage] = []
    
    init(view: MainViewProtocol, model: MainModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view?.setupUI()
        view?.loadImagesInBackground(count: 4)
        
    }
    
    func didTapNextButton() {
        view?.stopTimer()

        model.loadRandomImage { [weak self] imageInfo in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let imageInfo = imageInfo {
                    self.view?.updateImage(imageInfo.image)
                    self.view?.updateLabels(with: imageInfo)
                    self.view?.resetTimer()

                    self.view?.startTimer()
                } else {
                    print("Failed to load random image")
                }
            }
        }
    }
    
    func didTapLikeButton() {
        guard let currentImage = view?.getCurrentImage() else {
            print("No image to like")
            return
        }
        likedImages.append(currentImage)
        print("Image liked and added to favorites")
    }
    
    func didTapFavoritesButton() {
        view?.showFavorites(likedImages: likedImages) { [weak self] index in
            self?.likedImages.remove(at: index)
        }
    }
    func loadRandomImage(completion: @escaping (ImageInfo?) -> Void) {
        model.loadRandomImage { imageInfo in
            completion(imageInfo)
        }
    }
    func loadImagesInBackground(count: Int) {
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue.global(qos: .background)
        
        for _ in 0..<count {
            dispatchGroup.enter()
            
            loadRandomImage { imageInfo in
                if imageInfo != nil {
                    queue.async {
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All images loaded")
            
        }
    }
}
