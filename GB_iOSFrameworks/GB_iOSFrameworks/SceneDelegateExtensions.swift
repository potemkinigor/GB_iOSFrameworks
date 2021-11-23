//
//  SceneDelegateExtensions.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 15.11.2021.
//

import Foundation
import UIKit

extension SceneDelegate {
    func getTopSecurityViewController() -> ViewSecurityBlurProtocol? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if let topController = keyWindow?.rootViewController as? ViewSecurityBlurProtocol {
            return topController
        }
        
        return nil
    }
    
    func generatePushNotification() {
        notificationManager.areNotificationsAvailable {[weak self] available in
            if let available = available, available {
                self?.notificationManager.makeNotificationRequest(title: "Важное уведомление!",
                                                                  subtitle: "Самое крутое приложение",
                                                                  body: "Вы не были в приложении целую 1 минуту!",
                                                                  inMinutes: 1)
            }
        }
    }
    
}
