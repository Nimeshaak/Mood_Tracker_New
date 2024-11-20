import SwiftUI
import CoreData

struct MoodListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Mood.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Mood.timestamp, ascending: false)],
        animation: .default
    ) private var moods: FetchedResults<Mood>

    var body: some View {
        NavigationView {
            List {
                ForEach(moods) { mood in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mood: \(mood.selectedEmoji ?? "Unknown")")
                            .font(.headline)
                        
                        if let note = mood.note, !note.isEmpty {
                            Text("Note: \(note)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if let timestamp = mood.timestamp {
                            Text("Date: \(timestamp.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onDelete(perform: deleteMoods)
            }
            .navigationTitle("Mood History")
            .toolbar {
                EditButton()
            }
        }
    }

    private func deleteMoods(offsets: IndexSet) {
        withAnimation {
            offsets.map { moods[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("Failed to delete mood: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MoodListView()
}
