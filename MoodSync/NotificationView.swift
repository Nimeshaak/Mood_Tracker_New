import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var notificationVM: NotificationViewModel
    
    var body: some View {
        VStack {
            Text("Your Notifications")
                .font(.headline)
                .padding()

            List(notificationVM.notifications, id: \.self) { notification in
                Text(notification)
                    .padding()
            }
        }
        .navigationTitle("Notifications")
    }
}
