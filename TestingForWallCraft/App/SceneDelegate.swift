import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainView: MainView?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        mainView = MainView()

        if let mainView = mainView {
            let mainModel = MainModel()
            let mainPresenter = MainPresenter(view: mainView, model: mainModel)

            mainView.presenter = mainPresenter
        }

        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()

        window?.rootViewController = mainView
    }



    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

