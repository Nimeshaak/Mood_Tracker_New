import SwiftUI

class NotificationViewModel: ObservableObject {
    @Published var notifications: [String] = []

    // Function to add new notifications
    func addNotification(message: String) {
        notifications.append(message)
    }
}
