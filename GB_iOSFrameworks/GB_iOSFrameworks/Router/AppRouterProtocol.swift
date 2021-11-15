//
//  AppRouterProtocol.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 09.11.2021.
//

import Foundation
import UIKit

enum RouterPresentationMode {
    // Standard pushViewController presentation with default iOS animation
    case push
    // Modal presentation with custom transition
    case modal
    // Modal presentation with navigation controller
    case modalWithNavigation
    // Replaces the view controllers currently managed by the navigation controller with your view controller
    case replace
    // Replaces only current view controller currently managed by the navigation controller with your view controller
    case replaceWithPush
}

protocol AppRouterProtocol {
    var currentController: UIViewController { get }
    var rootNavigationController: UIViewController? { get }
    
    func go(controller: UIViewController,
            mode: RouterPresentationMode,
            animated: Bool,
            modalTransitionStyle: UIModalTransitionStyle)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func replaceWindowRoot(with controller: UIViewController)
    func tabBarDidChangedTo(controller: UIViewController)
}

extension AppRouterProtocol {
    func go(controller: UIViewController,
                   mode: RouterPresentationMode,
                   animated: Bool = true,
                   modalTransitionStyle: UIModalTransitionStyle = .coverVertical) {
        go(controller: controller, mode: mode, animated: animated, modalTransitionStyle: modalTransitionStyle)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: completion)
    }
    
    func pop(animated: Bool = true) {
        pop(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        popToRoot(animated: animated)
    }
}
