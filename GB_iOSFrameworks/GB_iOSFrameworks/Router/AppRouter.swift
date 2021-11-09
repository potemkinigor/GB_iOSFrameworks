//
//  AppRouter.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 09.11.2021.
//

import Foundation
import UIKit

final class AppRouter: NSObject, AppRouterProtocol {

    // MARK: - Static

    private static var _router: AppRouter?
    
    static var router: AppRouter {
        if let router = _router {
            return router
        }
        fatalError("AppRouter: call create router before use it.")
    }

    static func create(_ appDelegate: AppDelegate, controller: UIViewController) {
        AppRouter._router = AppRouter(appDelegate: appDelegate, controller: controller)

        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.backgroundColor = Appearance.backgroundColor
        appDelegate.window?.makeKeyAndVisible()
//        appDelegate.window?.rootViewController = controller
    }

    // MARK: - Instance

    private var appDelegate: AppDelegate

    private init(appDelegate: AppDelegate, controller: UIViewController) {
        self.appDelegate = appDelegate
        self.currentController = controller
        super.init()
    }

    // MARK: - RouterProtocol

    var currentController: UIViewController

    var rootNavigationController: UIViewController? {
        return currentController.navigationController?.viewControllers.first
    }

    func go(controller: UIViewController, mode: RouterPresentationMode, animated: Bool, modalTransitionStyle: UIModalTransitionStyle) {
        present(controller: controller, mode: mode, animated: animated, modalTransitionStyle: modalTransitionStyle)
        currentController = controller
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        currentController.dismiss(animated: animated, completion: completion)
    }

    func pop(animated: Bool) {
        currentController.navigationController?.popViewController(animated: animated)
        if let controller = currentController.navigationController?.viewControllers.last {
            currentController = controller
        }
    }

    func popToRoot(animated: Bool) {
        let firstController = currentController.navigationController?.viewControllers.first
        currentController.navigationController?.popToRootViewController(animated: animated)
        if let controller = firstController {
            currentController = controller
        }
    }

    func replaceWindowRoot(with controller: UIViewController) {
        appDelegate.window?.rootViewController = controller
    }
    
    func tabBarDidChangedTo(controller: UIViewController) {

    }

    // MARK: - Private

    private func present(controller: UIViewController, mode: RouterPresentationMode, animated: Bool, modalTransitionStyle: UIModalTransitionStyle) {
        switch mode {
        case .push:
            guard let navController = currentController.navigationController else {
                present(controller: controller, animated: animated)
                return
            }
            navController.pushViewController(controller, animated: animated)
        case .modal:
            controller.modalTransitionStyle = modalTransitionStyle
            controller.modalPresentationStyle = .fullScreen
            present(controller: controller, animated: animated)
        case .modalWithNavigation:
            let navController = UINavigationController(rootViewController: controller)
            navController.modalTransitionStyle = modalTransitionStyle
            navController.modalPresentationStyle = .fullScreen
            present(controller: navController, animated: animated)
        case .replace:
            guard let navController = currentController.navigationController else {
                present(controller: controller, animated: animated)
                return
            }
            navController.setViewControllers([controller], animated: animated)
        case .replaceWithPush:
            guard let navController = currentController.navigationController else {
                present(controller: controller, animated: animated)
                return
            }
            navController.pushViewController(controller, animated: animated)
            let controllers = navController.viewControllers.filter { $0 != currentController }
            navController.setViewControllers(controllers, animated: animated)
        }
    }

    private func present(controller: UIViewController, animated: Bool) {
        currentController.present(controller, animated: animated, completion: nil)
    }

}

// MARK: - Appearance

extension AppRouter {
    
    private struct Appearance {
        static let backgroundColor: UIColor = .black
    }
    
}
