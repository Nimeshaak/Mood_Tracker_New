import SwiftUI
import UserNotifications

struct NotificationView: View {
    @State private var notifications: [String] = []

    var body: some View {
        NavigationView {
            List(notifications, id: \.self) { notification in
                Text(notification)
            }
            .navigationTitle("Notifications")
            .onAppear {
                fetchNotifications()
            }
        }
    }

    private func fetchNotifications() {
        // Retrieve saved notifications from UserDefaults
        if let savedNotifications = UserDefaults.standard.stringArray(forKey: "notifications") {
            self.notifications = savedNotifications.isEmpty ? ["No notifications yet."] : savedNotifications
            print("Fetched notifications: \(self.notifications)") // Debugging log
        }
    }
}
