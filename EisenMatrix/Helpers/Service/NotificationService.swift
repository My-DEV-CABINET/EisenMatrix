//
//  NotificationService.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/23/24.
//

import UIKit
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    static var count = 0

    // PushNotificationHelper.swfit > PushNotificationHelper
    func pushNotification(date: Date, task: Task) {
        let content = UNMutableNotificationContent()
        content.title = "\(switchNotificationSymbol(for: task.taskType)): " + task.taskTitle
        content.body = task.taskMemo ?? "N/A"
        content.badge = NSNumber(value: NotificationService.count + 1)
        content.sound = UNNotificationSound.default

        NotificationService.count += 1
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림을 스케줄링하는 중 에러가 발생했습니다: \(error)")
            } else {
                print("알림이 성공적으로 설정되었습니다.")
            }
        }
    }

    func removeNotification(task: Task) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [task.id.uuidString])
    }

    func switchNotificationSymbol(for data: String) -> String {
        switch data {
        case Matrix.Do.info:
            return "🟢"
        case Matrix.Decide.info:
            return "🔵"
        case Matrix.Delegate.info:
            return "🟠"
        case Matrix.Delete.info:
            return "🔴"
        default:
            return "n/a"
        }
    }
}
