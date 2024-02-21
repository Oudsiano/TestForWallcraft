import SDWebImage
import Reachability

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
class MainViewController: UIViewController {
    
    private var timer: Timer?
    private var secondsRemaining = 10
    private var likedImages: [UIImage] = []
    private var activityIndicator: UIActivityIndicatorView!
    private var currentImage: ImageInfo?
    private var imagesQuantityParse = 5

    enum Constants {
        struct Image {
            static let offsetAToTopSafeArea = 50 as CGFloat
            static var imageNumber = 0
            static var diceArray: [UIImage] = []
            static var imageInfoArray: [ImageInfo] = []
        }
        enum TimerLabel {
            static let fontColor = UIColor.yellow
            static let fontSize = 16 as CGFloat
        }
        enum NextButton {
            static let backgroundColor = UIColor.yellow
            static let text = "NextImage"
            static let textColor = UIColor.black
            static let cornerNextButton = 20 as CGFloat
            static let textFontSize = 16 as CGFloat
            static let centerXOffsetViewRightAnchor = 50 as CGFloat
        }
        enum LikeButton {
            static let imageName = "heart.fill"
            static let imageColor = UIColor.white
            static let centerYAnchorOffsetViewTopAnchor = 50 as CGFloat
            static let centerXAnchorOffsetViewRightAnchor = -50 as CGFloat
        }
        enum FavoritesButton {
            static let imageName = "star.fill"
            static let imageColor = UIColor.white
            static let topAnchorOffsetLikeButton = 50 as CGFloat
            static let centerXAnchorOffsetViewRightAnchor = -50 as CGFloat
        }
        enum TitleLabel {
            static let backgroundColor = UIColor.yellow
            static let textColor = UIColor.white
            static let textFontSize = 18 as CGFloat
            static let numberOfLines = 1
            static let topAnchorOffsetImageBottomAnchor = 20 as CGFloat
            static let leadingAnchorOffsetView = 20 as CGFloat
            static let trailingAnchorOffsetView = -20 as CGFloat
        }
        enum DescriptionLabel {
            static let backgroundColor = UIColor.yellow
            static let textColor = UIColor.white
            static let textFontSize = 14 as CGFloat
            static let numberOfLines = 1
            static let topAnchorOffsetTitleLabel = 8 as CGFloat
            static let leadingAnchorOffsetView = 20 as CGFloat
            static let trailingAnchorOffsetView = -20 as CGFloat
        }
        enum AuthorLabel {
            static let backgroundColor = UIColor.yellow
            static let textColor = UIColor.white
            static let textFontSize = 16 as CGFloat
            static let numberOfLines = 1
            static let topAnchorOffsetDiscriptionLabel = 8 as CGFloat
            static let leadingAnchorOffsetView = 20 as CGFloat
            static let trailingAnchorOffsetView = -20 as CGFloat
        }
        
    }
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.TitleLabel.textColor
        label.font = UIFont.systemFont(ofSize: Constants.TitleLabel.textFontSize, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = Constants.TitleLabel.numberOfLines
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.DescriptionLabel.textColor
        label.font = UIFont.systemFont(ofSize: Constants.DescriptionLabel.textFontSize, weight: .regular)
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = Constants.DescriptionLabel.numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.AuthorLabel.textColor
        label.font = UIFont.systemFont(ofSize: Constants.AuthorLabel.textFontSize, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = Constants.AuthorLabel.numberOfLines
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(Constants.NextButton.text, for: .normal)
        btn.setTitleColor(Constants.NextButton.textColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: Constants.NextButton.textFontSize,weight: .bold)
        btn.layer.cornerRadius = Constants.NextButton.cornerNextButton
        btn.backgroundColor = Constants.NextButton.backgroundColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private lazy var likeButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: Constants.LikeButton.imageName)
        btn.setImage(image, for: .normal)
        btn.tintColor = Constants.LikeButton.imageColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var favoritesButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: Constants.FavoritesButton.imageName)
        btn.setImage(image, for: .normal)
        btn.tintColor = Constants.FavoritesButton.imageColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.TimerLabel.fontColor
        label.font = UIFont.systemFont(ofSize: Constants.TimerLabel.fontSize, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        SetupImage()
        setupNextButton()
        setupLoadingIndicator()
        loadImagesInBackground(count: imagesQuantityParse)
        setupLabels()
        setupTimerLabel()
        setupLikeButton()
        setupFavoritesButton()
    }

    private func setupTimerLabel() {
        view.addSubview(timerLabel)
        
        timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setupLoadingIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    private func SetupImage() {
        view.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Image.offsetAToTopSafeArea),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }
    
    private func loadRandomImage(completion: @escaping (ImageInfo?) -> Void) {
        guard isNetworkAvailable() else {
            if let currentImageInfo = Constants.Image.imageInfoArray.indices.contains(Constants.Image.imageNumber) ? Constants.Image.imageInfoArray[Constants.Image.imageNumber] : nil,
               let cachedImage = loadImageFromCache(forKey: currentImageInfo.imageURL) {
                print("Image found in cache")
                var updatedImageInfo = currentImageInfo
                updatedImageInfo.image = cachedImage
                completion(updatedImageInfo)
            } else {
                print("No internet connection and no cached image")
                completion(nil)
            }
            return
        }

        let apiKey = "AgSxq2sQJULT8QGT6rAU0UOc_gIMAEnc_AMexWgRK5I"
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
    private func loadImagesInBackground(count: Int) {
        showLoadingIndicator()

        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue.global(qos: .background)

        for _ in 0..<count {
            dispatchGroup.enter()

            loadRandomImage { imageInfo in
                if let imageInfo = imageInfo {
                    queue.async {
                        Constants.Image.diceArray.append(imageInfo.image!)
                        Constants.Image.imageInfoArray.append(imageInfo)
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("All images loaded")

            self.startTimer()

            // Скрыть экран загрузки
            self.hideLoadingIndicator()
            self.didTapNextButton()
        }
    }
    private func loadImageFromCache(forKey key: String) -> UIImage? {
        let cache = SDImageCache.shared
        return cache.imageFromDiskCache(forKey: key)
        print("loadImage")
    }

    private func saveImageToCache(_ image: UIImage, forKey key: String) {
        let cache = SDImageCache.shared
        cache.store(image, forKey: key, completion: nil)
        print("saveImage")

    }

    private func setupLabels() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(authorLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Constants.TitleLabel.topAnchorOffsetImageBottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.TitleLabel.leadingAnchorOffsetView),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.TitleLabel.trailingAnchorOffsetView),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.DescriptionLabel.topAnchorOffsetTitleLabel),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.DescriptionLabel.leadingAnchorOffsetView),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.DescriptionLabel.trailingAnchorOffsetView),

            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.AuthorLabel.topAnchorOffsetDiscriptionLabel),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.AuthorLabel.leadingAnchorOffsetView),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.AuthorLabel.trailingAnchorOffsetView)
        ])
    }

    private func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.NextButton.centerXOffsetViewRightAnchor).isActive = true

        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }

    private func setupLikeButton() {
        view.addSubview(likeButton)
        likeButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: Constants.LikeButton.centerYAnchorOffsetViewTopAnchor).isActive = true
        likeButton.centerXAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.LikeButton.centerXAnchorOffsetViewRightAnchor).isActive = true
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        likeButton.showsTouchWhenHighlighted = true // Включаем анимацию нажатия
    }

    private func setupFavoritesButton() {
        view.addSubview(favoritesButton)
        favoritesButton.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: Constants.FavoritesButton.topAnchorOffsetLikeButton).isActive = true
        favoritesButton.centerXAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.FavoritesButton.centerXAnchorOffsetViewRightAnchor as CGFloat).isActive = true
        favoritesButton.addTarget(self, action: #selector(didTapFavoritesButton), for: .touchUpInside)
    }

    private func startTimer() {
        stopTimer()

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            timerLabel.text = timeString(time: TimeInterval(secondsRemaining))
        } else {
            self.didTapNextButton()
        }
    }

    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func updateLabels(with imageInfo: ImageInfo) {
        titleLabel.text = imageInfo.title
        descriptionLabel.text = imageInfo.description
        authorLabel.text = "Author: \(imageInfo.author)"
    }

    @objc private func didTapNextButton() {
        guard !Constants.Image.diceArray.isEmpty else {
            print("No images in the array")
            return
        }

        Constants.Image.imageNumber = (Constants.Image.imageNumber + 1) % Constants.Image.diceArray.count

        let currentImageInfo = Constants.Image.imageInfoArray[Constants.Image.imageNumber]

        image.image = Constants.Image.diceArray[Constants.Image.imageNumber]

        updateLabels(with: currentImageInfo)

        secondsRemaining = 10
        startTimer()
    }

    @objc private func didTapLikeButton() {
        guard let currentImage = image.image else {
            print("No image to like")
            return
        }

        likedImages.append(currentImage)
        print("Image liked and added to the favorites")
    }

    @objc private func didTapFavoritesButton() {
        let favoriteVC = FavoritesViewController()
        favoriteVC.modalPresentationStyle = .overFullScreen
        favoriteVC.modalTransitionStyle = .flipHorizontal
        favoriteVC.receivedImages = likedImages

        favoriteVC.onDeleteImage = { [weak self] index in
            self?.likedImages.remove(at: index)
        }

        present(favoriteVC, animated: true)
    }
    func isNetworkAvailable() -> Bool {
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

