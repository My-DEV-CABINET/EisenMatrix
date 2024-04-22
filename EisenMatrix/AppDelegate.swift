//
//  AppDelegate.swift
//  EisenMatrix
//
//  Created by 준우의 MacBook 16 on 4/23/24.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        return true
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
