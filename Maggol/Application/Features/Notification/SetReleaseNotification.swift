//
//  SetReleaseNotification.swift
//  Maggol
//
//  Created by Lars Beijaard on 05/03/2025.
//

import Foundation
import UserNotifications

final class SetReleaseNotification {
    func activate() {
        Task {
            let notifications = await fetchNotifications()
            for notification in notifications ?? [] {
                await scheduleNotification(for: notification)
            }
        }
    }
}

private extension SetReleaseNotification {
    struct NotificationModel: Decodable {
        let name: String
        let release: String
        let year: Int
        let month: Int
        let day: Int
        
        // Primarily used for debugging purposes
        let hour: Int?
        let minute: Int?
        let second: Int?
    }
    
    func fetchNotifications() async -> [NotificationModel]? {
        let rawURL = "https://maggol-events.serverjoris.nl/events"
        guard let url = URL(string: rawURL) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([NotificationModel].self, from: data)
            return decoded
        } catch {
            return nil
        }
    }
    
    func scheduleNotification(for model: NotificationModel) async {
        let content = UNMutableNotificationContent()
        content.title = "Nieuw: \(model.name)"
        content.body = "Aangekondigd voor release op \(model.release)"
        
        var dateComponents = DateComponents(
            calendar: Calendar.current,
            year: model.year,
            month: model.month,
            day: model.day
        )
        dateComponents.hour = model.hour ?? 0
        dateComponents.minute = model.minute ?? 0
        dateComponents.second = model.second ?? 0
        
        let uuid = UUID(uuidString: model.name)?.uuidString ?? UUID().uuidString
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        do {
            try await notificationCenter.add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }
}
