import Foundation
import SDWebImage
import Reachability

protocol MainModelProtocol: AnyObject {
    func loadRandomImage(completion: @escaping (ImageInfo?) -> Void)
}

class MainModel: MainModelProtocol {
    
    func loadRandomImage(completion: @escaping (ImageInfo?) -> Void) {
            let cachedKeys = UserDefaults.standard.stringArray(forKey: "cachedImageKeys") ?? []

            guard isNetworkAvailable() else {
                if let currentImageInfo = Constants.Image.imageInfoArray.indices.contains(Constants.Image.imageNumber) ? Constants.Image.imageInfoArray[Constants.Image.imageNumber] : nil {
                    let currentKey = currentImageInfo.imageURL

                    if cachedKeys.contains(currentKey),
                       let cachedImage = loadImageFromCache(forKey: currentKey) {
                        print("Image found in cache")
                        var updatedImageInfo = currentImageInfo
                        updatedImageInfo.image = cachedImage
                        completion(updatedImageInfo)
                    } else {
                        print("No internet connection and no cached image")
                        completion(nil)
                    }
                } else {
                    print("Invalid current image info")
                    completion(nil)
                }
                return
            }

            let apiKey = "--tq3lsl7GQz4zdRBzupF4TTXv9fM-82jyIgou_f47Q"
            let urlString = "https://api.unsplash.com/photos/random?client_id=\(apiKey)"

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                completion(nil)
                return
            }

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error fetching random image:", error?.localizedDescription ?? "Unknown error")
                    completion(nil)
                    return
                }

                do {
                    let unsplashResponse = try JSONDecoder().decode(UnsplashResponse.self, from: data)

                    print("Image URL: \(unsplashResponse.urls.regular)")
                    print("Title: \(unsplashResponse.title ?? "N/A")")
                    print("Description: \(unsplashResponse.description ?? "N/A")")
                    print("Author: \(unsplashResponse.user.name)")

                    let imageInfo = ImageInfo(
                        imageURL: unsplashResponse.urls.regular,
                        title: unsplashResponse.title ?? "",
                        description: unsplashResponse.description ?? "",
                        author: unsplashResponse.user.name,
                        image: nil
                    )

                    self.loadImage(from: URL(string: unsplashResponse.urls.regular)!) { image in
                        if let image = image {
                            self.saveImageToCache(image, forKey: unsplashResponse.urls.regular)

                            var updatedImageInfo = imageInfo
                            updatedImageInfo.image = image

                            var updatedCachedKeys = cachedKeys
                            updatedCachedKeys.append(unsplashResponse.urls.regular)

                            UserDefaults.standard.set(updatedCachedKeys, forKey: "cachedImageKeys")

                            completion(updatedImageInfo)
                        } else {
                            print("Error loading image")
                            completion(nil)
                        }
                    }
                } catch {
                    print("Error parsing JSON:", error.localizedDescription)
                    completion(nil)
                }
            }

            task.resume()
        }

    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let imageTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching image data:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        imageTask.resume()
    }

    private func loadImageFromCache(forKey key: String) -> UIImage? {
        let cache = SDImageCache.shared
        return cache.imageFromDiskCache(forKey: key)
    }

    private func saveImageToCache(_ image: UIImage, forKey key: String) {
        let cache = SDImageCache.shared
        cache.store(image, forKey: key, completion: nil)

        var cachedKeys = UserDefaults.standard.stringArray(forKey: "cachedImageKeys") ?? []

        cachedKeys.append(key)

        UserDefaults.standard.set(cachedKeys, forKey: "cachedImageKeys")
    }

    private func isNetworkAvailable() -> Bool {
        guard let reachability = try? Reachability() else {
            return false
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

        let networkStatus = reachability.connection

        switch networkStatus {
        case .wifi, .cellular:
            return true
        case .unavailable, .none:
            return false
        }
    }
}
