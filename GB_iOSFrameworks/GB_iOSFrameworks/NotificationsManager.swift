//
//  NotificationsManager.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 23.11.2021.
//

import Foundation
import NotificationCenter

final class NotificationsManager {
    
    static let shared = NotificationsManager()
    
    private init() {}
    
    let center = UNUserNotificationCenter.current()
    
    func requestNotificationAuthorization() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if !granted {
                let alert = UIAlertController(title: "Ошибка",
                                              message: "Чтобы получать уведомления необходимо включить данную опцию в настройках",
                                              preferredStyle: .alert)
                
                alert.view.layer.opacity = 0.5
                
                guard let currentVC = self.getTopViewController() else { return }
                
                currentVC.present(alert, animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func makeNotificationRequest(title: String, subtitle: String, body: String, inMinutes: Int) {
        let request = UNNotificationRequest(
            identifier: "alaram",
            content: self.makeNotificationContent(title: title, subtitle: subtitle, body: body),
            trigger: self.makeNotificationTrigger(inMinutes: inMinutes)
        )
        
        center.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func areNotificationsAvailable(completion: @escaping (Bool?) -> () ) {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            case .denied:
                completion(false)
            case .notDetermined:
                completion(nil)
            default:
                completion(false)
            }
        }
    }

    private func makeNotificationContent(title: String, subtitle: String, body: String) -> UNNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.subtitle = subtitle
        notification.body = body
        notification.sound = .default
        notification.badge = 1
        
        return notification
    }
    
    private func makeNotificationTrigger(inMinutes: Int) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: Double(inMinutes * 60),
                                                 repeats: false)
    }
    
    private func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if let topController = keyWindow?.rootViewController {
            return topController
        }
        
        return nil
    }
}
