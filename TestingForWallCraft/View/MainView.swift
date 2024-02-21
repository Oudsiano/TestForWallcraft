import Foundation
import UIKit

protocol MainViewProtocol: AnyObject {
    func setupUI()
    func startTimer()
    func resetTimer()
    func updateImage(_ image: UIImage?)
    func updateLabels(with imageInfo: ImageInfo)
    func getCurrentImage() -> UIImage?
    func showFavorites(likedImages: [UIImage], onDeleteImage: @escaping (Int) -> Void)
    func loadImagesInBackground(count: Int)
    func stopTimer()
}

class MainView: UIViewController, MainViewProtocol {
    private var timer: Timer?
    private var secondsRemaining = 20
    private var likedImages: [UIImage] = []
    private var activityIndicator: UIActivityIndicatorView!
    private var currentImage: ImageInfo?
    
    var presenter: MainPresenterProtocol!
    

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
        presenter.viewDidLoad()
    }

    @objc func didTapNextButton() {
        presenter.didTapNextButton()
    }

    @objc func didTapLikeButton() {
        presenter.didTapLikeButton()
    }

    @objc func didTapFavoritesButton() {
        presenter.didTapFavoritesButton()
    }

    // Implement MainViewProtocol methods
    func setupUI() {
        SetupImage()
        setupNextButton()
        setupLoadingIndicator()
        setupLabels()
        setupTimerLabel()
        setupLikeButton()
        setupFavoritesButton()
    }

    

    func startTimer() {
        stopTimer()

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func resetTimer() {
        secondsRemaining = 20
        timerLabel.text = timeString(time: TimeInterval(secondsRemaining))
    }

    func updateImage(_ image: UIImage?) {
        self.image.image = image
    }

    func updateLabels(with imageInfo: ImageInfo) {
        titleLabel.text = imageInfo.title
        descriptionLabel.text = imageInfo.description
        authorLabel.text = "Author: \(imageInfo.author)"
    }

    func getCurrentImage() -> UIImage? {
        return image.image
    }

    func showFavorites(likedImages: [UIImage], onDeleteImage: @escaping (Int) -> Void) {
        let favoriteVC = FavoritesView()
        favoriteVC.modalPresentationStyle = .overFullScreen
        favoriteVC.modalTransitionStyle = .flipHorizontal
        favoriteVC.receivedImages = likedImages

        favoriteVC.onDeleteImage = onDeleteImage

        present(favoriteVC, animated: true)
    }

    @objc func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            timerLabel.text = timeString(time: TimeInterval(secondsRemaining))
        } else {
            print("Timer reached 0")
            didTapNextButton()
        }
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

    internal func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func loadImagesInBackground(count: Int) {
            showLoadingIndicator()

            let dispatchGroup = DispatchGroup()
            let queue = DispatchQueue.global(qos: .background)

            for _ in 0..<count {
                dispatchGroup.enter()

                presenter?.loadRandomImage { [weak self] imageInfo in
                    guard self != nil else { return }
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

                self.startTimer()
                self.hideLoadingIndicator()
                self.presenter.didTapNextButton()
            }
        }

}
