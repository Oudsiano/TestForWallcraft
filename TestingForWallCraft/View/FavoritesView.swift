import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func setupUI()
    func setupTableView()
    func loadImages()
}

class FavoritesView: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoritesViewProtocol {
    private var tableView: UITableView?
    var receivedImages: [UIImage] = []
    var favoriteImages: [UIImage] = []
    var onDeleteImage: ((Int) -> Void)?

    enum Constants {
        enum BackInImagesButton {
            static let text = "Back to Gallery"
            static let topSaveAreaOffset = 10 as CGFloat
            static let leftSaveAreaOffset = 10 as CGFloat
        }
        enum Cell {
            static let multipleCellShowOffset = 150 as CGFloat
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImages()
        setupTableView()
    }

    func setupUI() {
        setupButtonBackInImages()
    }

    func loadImages() {
        favoriteImages = receivedImages
        tableView?.reloadData()
    }

    private lazy var buttonBackInImages: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.setTitle(Constants.BackInImagesButton.text, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private func setupButtonBackInImages() {
        view.addSubview(buttonBackInImages)
        buttonBackInImages.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.BackInImagesButton.topSaveAreaOffset).isActive = true
        buttonBackInImages.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.BackInImagesButton.leftSaveAreaOffset).isActive = true
        buttonBackInImages.addTarget(self, action: #selector(didTapBackImageButton), for: .touchUpInside)
    }


    @objc private func didTapBackImageButton() {
        dismiss(animated: true, completion: nil)
    }

    func setupTableView() {
        tableView = UITableView()
        tableView?.register(FavoriteImageCell.self, forCellReuseIdentifier: "FavoriteImageCell")
        tableView?.dataSource = self
        tableView?.delegate = self

        guard let tableView = tableView else { return }

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: buttonBackInImages.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteImages.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height - Constants.Cell.multipleCellShowOffset
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteImageCell", for: indexPath) as? FavoriteImageCell else {
            return UITableViewCell()
        }

        let image = favoriteImages[indexPath.row]
        cell.configure(with: image)

        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true

        cell.onDeleteButtonTapped = { [weak self] in
            self?.removeImage(at: indexPath.row)
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = favoriteImages.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    private func removeImage(at index: Int) {
        favoriteImages.remove(at: index)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)

        onDeleteImage?(index)
    }
}
