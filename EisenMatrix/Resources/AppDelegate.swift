//
//  AppDelegate.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/23/24.
//

import BackgroundTasks
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    let taskId = "EisenMatrixBackground" // Info.plist 와 일치

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization()
        registerBackgroundTasks()
        UNUserNotificationCenter.current().setBadgeCount(NotificationService.count, withCompletionHandler: nil)
//        sendNotification(seconds: 5)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UNUserNotificationCenter.current().setBadgeCount(0)
        NotificationService.count = 0
    }

    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("알림을 보낼 수 있는 권한이 허가되었습니다.")
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }

    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
            guard let task = task as? BGProcessingTask else { return }
            self.handleBackgroundTask(task: task)
        }
    }

    /// Test Send Notification
    func sendNotification(seconds: Double) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "알림 테스트"
        notificationContent.body = "이것은 알림을 테스트 하는 것이다"
        notificationContent.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }

    func handleBackgroundTask(task: BGProcessingTask) {
        task.setTaskCompleted(success: true)
    }

    private func submitBackgroundTask() {
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            guard requests.isEmpty else { return }
            let request = BGProcessingTaskRequest(identifier: self.taskId)
            request.requiresNetworkConnectivity = false
            request.requiresExternalPower = false

            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Unable to schedule background task: \(error.localizedDescription)")
            }
        }
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = AppDelegate.self
        return sceneConfig
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Here we actually handle the notification
        print("willPresent - identifier: \(notification.request.identifier)")
        print("willPresent - UserInfo: \(notification.request.content.userInfo)")

        // 이 부분은 앱이 열려있는 상태에서도 Local Notification이 오도록 함
        // 제거할 경우 앱이 열려있는 상태에서는 Local Notification이 나타나지 않음 (나머자 부분은 실행됨)
        UNUserNotificationCenter.current().setBadgeCount(0)
        NotificationService.count = 0

        completionHandler([.list, .banner, .sound])
    }

    // 메시지를 클릭(터치)했을 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        let userInfo = response.notification.request.content.userInfo
        print("didReceive - identifier: \(identifier)")
        print("didReceive - UserInfo: \(userInfo)")

        UNUserNotificationCenter.current().setBadgeCount(0)
        NotificationService.count = 0

        completionHandler()
    }
}
