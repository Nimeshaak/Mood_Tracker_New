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
        NavigationView {
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
                .padding(.top, 20)
                
                // Mood Section
                if let todayMood = moods.first(where: { isToday($0.timestamp) }) {
                    // Display today's mood if available
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Last Updated: \(todayMood.lastUpdated?.formatted() ?? "Unknown")")
                                .font(.title2)
                                .fontWeight(.medium)
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
                            .font(.headline)
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
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                } else {
                    // If no mood is selected today, show the emoji selection
                    VStack(alignment: .leading, spacing: 0) {
                        Text("How are You Feeling Today?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading, 16)
                            .foregroundColor(.primary)
                        HStack(spacing: 12) {
                            moodButton(emoji: "😊")
                            moodButton(emoji: "😢")
                            moodButton(emoji: "😡")
                            moodButton(emoji: "😱")
                            moodButton(emoji: "😴")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    }
                }
                
                // Motivational Quotes Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Motivational Quotes")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("“The only way to do great work is to love what you do.” – Steve Jobs")
                        .font(.body)
                        .italic()
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                .frame(height: 150)
                
                // Notifications Section
                HStack {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.orange)
                    Text("You have 3 new notifications")
                        .font(.body)
                        .foregroundColor(.primary)
                    Spacer()
                    NavigationLink(destination: Text("Notifications Page")) {
                        Text("View All")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)

                // Horizontal Scrollable Box Views
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        BoxView(imageName: "IMG1", size: CGSize(width: 160, height: 160))
                        BoxView(imageName: "IMG2", size: CGSize(width: 160, height: 160))
                        BoxView(imageName: "IMG3", size: CGSize(width: 160, height: 160))
                    }
                    .padding()
                }
                .background(Color.gray.opacity(0.1))
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal)

                Spacer()
            }
            .navigationBarHidden(true)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.green.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .onAppear {
                startTimerForMidnightCheck()
                checkIfNewDay()
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

struct BoxView: View {
    let imageName: String
    let size: CGSize
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 6)
        }
        .frame(width: size.width, height: size.height)
        .clipped()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
