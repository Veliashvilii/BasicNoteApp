//
//  AppRouter.swift
//  BasicNoteApp
//
//  Created by Serkan Erkan on 18.07.2024.
//

import UIKit

final class AppRouter: Router {
    
    static let shared = AppRouter()
    
    var window: UIWindow?
    
    func startApp(window: UIWindow?) {
        self.window = window

        let router = Router()
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        router.viewController = viewController
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
    
    private func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
