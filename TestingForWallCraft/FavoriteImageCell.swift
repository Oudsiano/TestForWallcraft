import UIKit

class FavoriteImageCell: UITableViewCell {
    
    
    private var imageViewCell: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = Constants.DeleteButton.tintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onDeleteButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        setupDeleteButton()
        setupImageViewCell()
        
    }
    private func setupImageViewCell() {
        contentView.addSubview(imageViewCell)
        
        NSLayoutConstraint.activate([
            imageViewCell.topAnchor.constraint(equalTo: deleteButton.bottomAnchor),
            imageViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageViewCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: UIImage) {
        imageViewCell.image = image
    }
    private func setupDeleteButton() {
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: Constants.DeleteButton.width),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.DeleteButton.height)
        ])
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        onDeleteButtonTapped?()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.bringSubviewToFront(deleteButton)
    }
}
