//
//  Daily_VocabApp.swift
//  Daily Vocab
//
//  Created by Gursewak Sandhu on 2025-01-06.
//
import SwiftUI
import UserNotifications

@main
struct DailyVocabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [weak self] granted, error in
            if granted {
                self?.scheduleDailyNotification()
            }
        }
        return true
    }

    private func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "DailyVocab Word of the Day"
        content.body = "Tap to discover today’s word!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 9

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyVocabNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
