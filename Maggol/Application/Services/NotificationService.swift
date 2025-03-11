//
//  NotificationService.swift
//  Maggol
//
//  Created by Lars Beijaard on 05/03/2025.
//

import Foundation
import UserNotifications

final class NotificationService {
    private let center = UNUserNotificationCenter.current()
    
    func activate() {
        Task {
            await askNotificationAuthorization()
        }
    }
}

private extension NotificationService {
    func askNotificationAuthorization() async {
        do {
            if try await center.requestAuthorization(
                options: [.alert, .sound, .badge, .provisional]
            ) {
                activateNotificationService()
            }
        } catch {
            print("Notification authorization failed: \(error)")
        }
    }
    
    func activateNotificationService() {
        SetReleaseNotification().activate()
    }
}
