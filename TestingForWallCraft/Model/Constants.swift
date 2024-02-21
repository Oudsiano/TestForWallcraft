import Foundation
import UIKit

struct Constants {
    struct Image {
        static let offsetAToTopSafeArea = 50 as CGFloat
        static var imageNumber = 0
        static var diceArray: [UIImage] = []
        static var imageInfoArray: [ImageInfo] = []
    }
    
    struct TimerLabel {
        static let fontColor = UIColor.yellow
        static let fontSize = 16 as CGFloat
    }
    
    struct NextButton {
        static let backgroundColor = UIColor.yellow
        static let text = "NextImage"
        static let textColor = UIColor.black
        static let cornerNextButton = 20 as CGFloat
        static let textFontSize = 16 as CGFloat
        static let centerXOffsetViewRightAnchor = 50 as CGFloat
    }
    
    struct LikeButton {
        static let imageName = "heart.fill"
        static let imageColor = UIColor.white
        static let centerYAnchorOffsetViewTopAnchor = 50 as CGFloat
        static let centerXAnchorOffsetViewRightAnchor = -50 as CGFloat
    }
    
    struct FavoritesButton {
        static let imageName = "star.fill"
        static let imageColor = UIColor.white
        static let topAnchorOffsetLikeButton = 50 as CGFloat
        static let centerXAnchorOffsetViewRightAnchor = -50 as CGFloat
    }
    
    struct TitleLabel {
        static let backgroundColor = UIColor.yellow
        static let textColor = UIColor.white
        static let textFontSize = 18 as CGFloat
        static let numberOfLines = 1
        static let topAnchorOffsetImageBottomAnchor = 20 as CGFloat
        static let leadingAnchorOffsetView = 20 as CGFloat
        static let trailingAnchorOffsetView = -20 as CGFloat
    }
    
    struct DescriptionLabel {
        static let backgroundColor = UIColor.yellow
        static let textColor = UIColor.white
        static let textFontSize = 14 as CGFloat
        static let numberOfLines = 1
        static let topAnchorOffsetTitleLabel = 8 as CGFloat
        static let leadingAnchorOffsetView = 20 as CGFloat
        static let trailingAnchorOffsetView = -20 as CGFloat
    }
    
    struct AuthorLabel {
        static let backgroundColor = UIColor.yellow
        static let textColor = UIColor.white
        static let textFontSize = 16 as CGFloat
        static let numberOfLines = 1
        static let topAnchorOffsetDiscriptionLabel = 8 as CGFloat
        static let leadingAnchorOffsetView = 20 as CGFloat
        static let trailingAnchorOffsetView = -20 as CGFloat
    }
    struct BackInImagesButton {
        static let text = "Back to Gallery"
        static let topSaveAreaOffset = 10 as CGFloat
        static let leftSaveAreaOffset = 10 as CGFloat
    }
    struct Cell {
        static let multipleCellShowOffset = 150 as CGFloat
    }
    struct DeleteButton {
        static let tintColor = UIColor.red
        static let width = 30 as CGFloat
        static let height = 30 as CGFloat
    }
}

