import SwiftUI

class NotificationViewModel: ObservableObject {
    @Published var notifications: [String] = [] // Store notification messages

    // Add a notification to the list
    func addNotification(message: String) {
        notifications.append(message)
    }
}
