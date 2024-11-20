import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Mood.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Mood.timestamp, ascending: false)],
        animation: .default
    ) private var moods: FetchedResults<Mood>

    @State private var currentDate = Date()
    @State private var isNewDay = false

    var body: some View {
        TabView {
            NavigationView {
                ScrollView {  // Wrapping the whole view in a ScrollView
                    VStack(spacing: 20) {
                        // Header Section
                        HStack {
                            Text("Home")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(destination: Text("Notifications Page")) {
                                Image(systemName: "bell")
                                    .font(.title)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)  // Reduced top padding to remove extra space
                        
                        // Mood Section
                        if let todayMood = moods.first(where: { isToday($0.timestamp) }) {
                            // Display today's mood if available
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Last Updated: \(todayMood.lastUpdated?.formatted() ?? "Unknown")")
                                        .font(.subheadline)  // Smaller font size for Last Updated
                                        .fontWeight(.light)  // Lighter weight for Last Updated
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: MoodView()) {
                                        Image(systemName: "pencil")
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                                
                                Text("Today's Mood: \(todayMood.selectedEmoji ?? "No mood selected")")
                                    .font(.title)            // Larger font size for Today's Mood
                                    .fontWeight(.semibold)   // Semi-bold for Today's Mood
                                    .foregroundColor(.blue)
                                    .padding(.leading, 16)
                                
                                // Display the note if it exists
                                if let note = todayMood.note, !note.isEmpty {
                                    Text("Note: \(note)")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .padding(.leading, 16)
                                        .padding(.top, 5)
                                }
                            }
                            .padding(.vertical, 40)
                            .background(Color.white) // Pastel blue background
                            .cornerRadius(0)
                        } else {
                            // If no mood is selected today, show the emoji selection
                            VStack(alignment: .leading, spacing: 0) {
                                Text("How are You Feeling Today?")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .padding(.bottom, 0)
                                    .padding(.leading, 16)
                                    .foregroundColor(.primary)
                                    .padding(.top, 20) // Add padding to the top here
                                HStack(spacing: 12) {
                                    moodButton(emoji: "😊")
                                    moodButton(emoji: "😢")
                                    moodButton(emoji: "😡")
                                    moodButton(emoji: "😱")
                                    moodButton(emoji: "😴")
                                }
                                .padding()
                                .background(Color.white) // Pastel blue background
                                .cornerRadius(15)
                            }
                        }

                        Text("Motivational Quotes")
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.top, 0)
                        
                        // Motivational Quotes Section
                        VStack(alignment: .center, spacing: 10) {
                            Text("“The only way to do great work is to love what you do. Success is not the key to happiness. Happiness is the key to success. If you love what you are doing, you will be successful.” – Albert Schweitzer")
                                .font(.body)
                                .italic()
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 20)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.3), Color.blue.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                        .cornerRadius(15)
                        .padding(.horizontal)
                        .frame(height: 180) // Increased height for motivational quotes section

                        // Title for the last card with 3 boxes
                        Text("Your Mood History")
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.top, 10)

                        // Stack views one below another instead of horizontal scroll
                        VStack(spacing: 20) {
                            NavigationLink(destination: DeepBreathingView()) {
                                BoxView(imageName: "IMG1", size: CGSize(width: 320, height: 160), description: "Here is a description of this image")
                            }
                            NavigationLink(destination: DeepBreathingView()) {
                                BoxView(imageName: "IMG2", size: CGSize(width: 320, height: 160), description: "Another description for the second image")
                            }
                            NavigationLink(destination: DeepBreathingView()) {
                                BoxView(imageName: "IMG3", size: CGSize(width: 320, height: 160), description: "This is the description for the third image")
                            }
                        }
                        .padding(.vertical)

                        Spacer()
                    }
                    .background(
                        Color(red: 0.82, green: 0.96, blue: 0.93) // Your specified color (soft pastel blue)
                    )
                    .edgesIgnoringSafeArea(.top)  // This removes the top safe area
                    .onAppear {
                        startTimerForMidnightCheck()
                        checkIfNewDay()
                    }
                }
                .navigationBarHidden(true)
                .background(
                    Color(red: 0.82, green: 0.96, blue: 0.93) // Apply the same background color across the entire screen
                )
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            MoodListView()
                            .tabItem {
                                Image(systemName: "chart.bar.fill")
                                Text("Activity")
                            }
            
            MoodView()
                            .tabItem {
                                Image(systemName: "plus.circle.fill")
                                Text("Add")
                            }
                        
                        // Habit tab with HabitListView
                        HabitListView()
                            .tabItem {
                                Image(systemName: "list.bullet")
                                Text("Habit")
                            }
                        
                        // Profile tab with ProfileView
                        ProfileView()
                            .tabItem {
                                Image(systemName: "person.crop.circle.fill")
                                Text("Profile")
                            }
        }
    }

    private func moodButton(emoji: String) -> some View {
        Button(action: {
            // Save the selected emoji with an optional note
            saveMood(emoji: emoji)
        }) {
            Text(emoji)
                .font(.largeTitle)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }

    private func saveMood(emoji: String) {
        // Create a new Mood object and save it to Core Data
        let newMood = Mood(context: viewContext)
        newMood.selectedEmoji = emoji
        newMood.timestamp = Date() // Timestamp for when the emoji is selected
        newMood.lastUpdated = Date() // Set last updated to current date and time
        
        // Optionally add a note (you can customize how the note is added)
        newMood.note = "Feeling \(emoji)" // Example note, can be modified

        do {
            try viewContext.save()
        } catch {
            print("Failed to save mood: \(error)")
        }
    }

    private func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDateInToday(date)
    }

    private func startTimerForMidnightCheck() {
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: Date())
        
        // Calculate the time interval until midnight
        let timeIntervalUntilMidnight = midnight.addingTimeInterval(24 * 60 * 60).timeIntervalSinceNow
        
        // Schedule the timer to trigger at midnight
        Timer.scheduledTimer(withTimeInterval: timeIntervalUntilMidnight, repeats: false) { _ in
            // Check if it's a new day
            let currentDay = Calendar.current.startOfDay(for: Date())
            if currentDay > calendar.startOfDay(for: self.currentDate) {
                self.isNewDay = true
                self.currentDate = currentDay // Update currentDate to today's date
            }
        }
    }

    // Ensure that if the data is missing (after deletion), we show the emoji selection
    private func checkIfNewDay() {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        // Check if the mood data exists for today
        if moods.first(where: { isToday($0.timestamp) }) == nil {
            isNewDay = true
        } else {
            isNewDay = false
        }
    }
}

// Custom pastel blue color
extension Color {
    static let pastelBlue = Color(red: 0.84, green: 0.92, blue: 1.0) // Soft pastel blue
}

struct BoxView: View {
    let imageName: String
    let size: CGSize
    let description: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 6)

            Text(description)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .padding(.top, 5)
        }
        .frame(width: size.width, height: size.height + 40)
        .padding()  // Padding around the content
        .background(Color.white)  // Background applied to the content itself
        .cornerRadius(15)
        .shadow(radius: 6) // Optional shadow
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
