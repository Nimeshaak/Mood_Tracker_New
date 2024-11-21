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
        NavigationStack {
            TabView {
                // Home tab
                NavigationStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Home")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    Spacer()
                                    NavigationLink(destination: NotificationView()) {
                                        Image(systemName: "bell")
                                            .font(.title)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 10)
                            }
                            
                            // Mood Section
                            if let todayMood = moods.first(where: { isToday($0.timestamp) }) {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Last Updated: \(todayMood.lastUpdated?.formatted() ?? "Unknown")")
                                            .font(.subheadline)
                                            .fontWeight(.light)
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
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                        .padding(.leading, 16)
                                    
                                    if let note = todayMood.note, !note.isEmpty {
                                        Text("Note: \(note)")
                                            .font(.body)
                                            .foregroundColor(.primary)
                                            .padding(.leading, 16)
                                            .padding(.top, 5)
                                    }
                                }
                                .padding(.vertical, 40)
                                .background(Color.white)
                                .cornerRadius(0)
                            } else {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("How are You Feeling Today?")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .padding(.bottom, 0)
                                        .padding(.leading, 16)
                                        .foregroundColor(.primary)
                                        .padding(.top, 20)
                                    
                                    HStack(spacing: 12) {
                                        moodButton(emoji: "😊")
                                        moodButton(emoji: "😢")
                                        moodButton(emoji: "😡")
                                        moodButton(emoji: "😱")
                                        moodButton(emoji: "😴")
                                    }
                                    .padding()
                                    .background(Color.white)
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
                            .frame(height: 180)
                            
                            // Your Mood History
                            Text("Relaxing Activities")
                                .font(.title2)
                                .fontWeight(.medium)
                                .padding(.top, 10)
                            
                            // Stack views one below another
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
                            Color(red: 0.82, green: 0.96, blue: 0.93)
                        )
                        .edgesIgnoringSafeArea(.top)
                        .onAppear {
                            startTimerForMidnightCheck()
                            checkIfNewDay()
                        }
                    }
                    .navigationBarHidden(true)
                    .background(
                        Color(red: 0.82, green: 0.96, blue: 0.93)
                    )
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                        .background(Color.white.opacity(0.5)) // Apply semi-transparent white background for this tab
                        .accentColor(.primary)
                        .onAppear {
                            UITabBar.appearance().backgroundColor = UIColor.white.withAlphaComponent(1.0)
                            UITabBar.appearance().shadowImage = UIImage()
                            UITabBar.appearance().backgroundImage = UIImage()
                        }
                
                MoodListView()
                    .navigationBarBackButtonHidden(true)
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Activity")
                    }
                    .background(Color.white.opacity(1.0)) // Apply background for this tab
                    .accentColor(.primary)
                    .onAppear {
                        UITabBar.appearance().backgroundColor = UIColor.white.withAlphaComponent(1.0)
                        UITabBar.appearance().shadowImage = UIImage()
                        UITabBar.appearance().backgroundImage = UIImage()
                    }
                
                MoodView()
                    .navigationBarBackButtonHidden(true)
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                    .background(Color.white.opacity(0.5)) // Apply background for this tab
                    .accentColor(.primary)
                    .onAppear {
                        UITabBar.appearance().backgroundColor = UIColor.white.withAlphaComponent(0.5)
                        UITabBar.appearance().shadowImage = UIImage()
                        UITabBar.appearance().backgroundImage = UIImage()
                    }
                
                HabitsView()
                    .navigationBarBackButtonHidden(true)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Habit")
                    }
                    .background(Color.white.opacity(1.0)) // Apply background for this tab
                    .accentColor(.primary)
                    .onAppear {
                        UITabBar.appearance().backgroundColor = UIColor.white.withAlphaComponent(1.0)
                        UITabBar.appearance().shadowImage = UIImage()
                        UITabBar.appearance().backgroundImage = UIImage()
                    }
                
                ProfileView()
                    .navigationBarBackButtonHidden(true)
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
                    .background(Color.white.opacity(1.0)) // Apply background for this tab
                    .accentColor(.primary)
                    .onAppear {
                        UITabBar.appearance().backgroundColor = UIColor.white.withAlphaComponent(1.0)
                        UITabBar.appearance().shadowImage = UIImage()
                        UITabBar.appearance().backgroundImage = UIImage()
                    }
            }
        }
    }

    private func moodButton(emoji: String) -> some View {
        Button(action: {
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
        let newMood = Mood(context: viewContext)
        newMood.selectedEmoji = emoji
        newMood.timestamp = Date()
        newMood.lastUpdated = Date()
        newMood.note = "Feeling \(emoji)"

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
        let timeIntervalUntilMidnight = midnight.addingTimeInterval(24 * 60 * 60).timeIntervalSinceNow

        Timer.scheduledTimer(withTimeInterval: timeIntervalUntilMidnight, repeats: false) { _ in
            let currentDay = Calendar.current.startOfDay(for: Date())
            if currentDay > calendar.startOfDay(for: self.currentDate) {
                self.isNewDay = true
                self.currentDate = currentDay
            }
        }
    }

    private func checkIfNewDay() {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        if moods.first(where: { isToday($0.timestamp) }) == nil {
            isNewDay = true
        } else {
            isNewDay = false
        }
    }
}

extension Color {
    static let pastelBlue = Color(red: 0.84, green: 0.92, blue: 1.0)
}

struct BoxView: View {
    let imageName: String
    let size: CGSize
    let description: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: size.width, height: size.height)
                .cornerRadius(15)

            Text(description)
                .font(.body)
                .foregroundColor(.primary)
                .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
