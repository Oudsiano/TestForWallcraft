import UIKit

protocol FavoritesPresenterProtocol: AnyObject {
    func viewDidLoad()
}

class FavoritesPresenter: FavoritesPresenterProtocol {
    
    weak var view: FavoritesViewProtocol?
    var model: FavoritesModelProtocol
    
    init(view: FavoritesViewProtocol, model: FavoritesModelProtocol) {
        self.view = view
        self.model = model
    }

    func viewDidLoad() {
        view?.setupUI()
        view?.loadImages()
        view?.setupTableView()
    }
}
