//
//  SceneDelegateExtensions.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 15.11.2021.
//

import Foundation
import UIKit

extension SceneDelegate {
    func getTopViewController() -> ViewSecurityBlurProtocol? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if let topController = keyWindow?.rootViewController as? ViewSecurityBlurProtocol {
            return topController
        }
        
        return nil
    }
}
