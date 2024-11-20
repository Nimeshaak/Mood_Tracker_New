import SwiftUI
import UserNotifications

@main
struct MoodSyncApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var notificationVM = NotificationViewModel()

    init() {
        // Request notification permission
        requestNotificationPermission()
        // Schedule the hourly notifications
        scheduleHourlyNotifications()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(notificationVM)
            }
        }
    }

    // Request permission to send notifications
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied: \(error?.localizedDescription ?? "No error information")")
            }
        }
    }

    // Schedule the hourly notifications
    private func scheduleHourlyNotifications() {
        // Define the notification content
        let reminderMessages = [
            "Did you add your mood today?",
            "Come check out these stress-releasing tricks!",
            "It's time for your mood update!"
        ]
        
        // Create a notification request for each hourly notification
        let content = UNMutableNotificationContent()
        
        // Randomly select one message every hour
        let randomMessage = reminderMessages.randomElement() ?? "Reminder: Update your mood!"
        
        content.body = randomMessage
        content.title = "MoodSync Reminder"
        content.sound = .default
        
        // Create a time trigger that repeats every hour
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        // Create a notification request
        let request = UNNotificationRequest(identifier: "HourlyReminder", content: content, trigger: trigger)
        
        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                // When notification is scheduled, add to view model
                DispatchQueue.main.async {
                    self.notificationVM.addNotification(message: randomMessage)
                }
                print("Notification scheduled.")
            }
        }
    }
}
