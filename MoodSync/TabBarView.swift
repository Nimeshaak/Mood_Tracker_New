import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            // Home Tab
            NavigationView {
                HomeView() // Link to the actual HomeView
                    .navigationTitle("Home")
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            // Activity Tab
            NavigationView {
                HomeView() // Replace with your actual ActivityView content
                    .navigationTitle("Activity")
            }
            .tabItem {
                Label("Activity", systemImage: "figure.walk")
            }
            
            // Add Tab
            NavigationView {
                HomeView() // Replace with your actual AddView content
                    .navigationTitle("Add")
            }
            .tabItem {
                Label("Add", systemImage: "plus.circle.fill")
            }
            
            // Habits Tab
            NavigationView {
                HomeView() // Replace with your actual HabitsView content
                    .navigationTitle("Habits")
            }
            .tabItem {
                Label("Habits", systemImage: "checkmark.circle.fill")
            }
            
            // Profile Tab
            NavigationView {
                HomeView() // Replace with your actual ProfileView content
                    .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
        }
        .frame(height: 100) // Adjust the height of the tab bar
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
