import SwiftUI

struct HabitFormView: View {
    @State private var habitName: String = ""
    @State private var habitDescription: String = ""
    @State private var selectedDays: [Bool] = Array(repeating: false, count: 7)
    @State private var reminderTime: Date = Date()
    @State private var reminderNote: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Add Habit Icon
                Button(action: {
                    // Action for adding an icon
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .shadow(radius: 5)
                        
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                }
                
                // Habit Name Field
                TextField("Add Habit Name Here...", text: $habitName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                
                // Habit Description Field
                TextField("Add Habit Description Here...", text: $habitDescription)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                
                // Repeat On Section
                VStack(alignment: .leading) {
                    Text("Repeat On")
                        .font(.headline)
                    
                    HStack(spacing: 10) {
                        ForEach(0..<7, id: \.self) { index in
                            Button(action: {
                                selectedDays[index].toggle()
                            }) {
                                Text(["S", "M", "T", "W", "T", "F", "S"][index])
                                    .frame(width: 40, height: 40)
                                    .background(selectedDays[index] ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                // Reminder Section
                VStack(alignment: .leading) {
                    Text("Reminder On")
                        .font(.headline)
                    
                    HStack {
                        DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        
                        Button(action: {
                            // Action to add reminder
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                    }
                }
                
                // Reminder Note Field
                TextField("Add Note Here...", text: $reminderNote)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                
                // Save and Cancel Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        // Action for saving
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        // Action for cancel
                    }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color(red: 0.9, green: 0.96, blue: 1))
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                // Action for back
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            })
        }
    }
}

struct HabitFormView_Previews: PreviewProvider {
    static var previews: some View {
        HabitFormView()
    }
}
