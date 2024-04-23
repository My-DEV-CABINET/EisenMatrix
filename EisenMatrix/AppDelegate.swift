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
    let taskId = "EisenMatrixBackground"

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Setup notification on launch
        setupNotification(application: application)

        // Register background tasks
        registerBackgroundTasks()

        return true
    }

    func setupNotification(application: UIApplication) {
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (didAllow, e) in
            // Optionally handle error or success
        }
        notiCenter.delegate = self

        if #available(iOS 11.0, *) {
            // iOS 11 or later specific code, if necessary

        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }

    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
            guard let task = task as? BGProcessingTask else { return }
            self.handleBackgroundTask(task: task)
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

        completionHandler()
    }
}
