import SwiftUI
import CoreData

struct DeleteAllMoodsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Button(action: {
                deleteAllMoods()
            }) {
                Text("Delete All Moods")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func deleteAllMoods() {
        // Create a fetch request to get all Mood objects
        let fetchRequest: NSFetchRequest<Mood> = Mood.fetchRequest()
        
        do {
            let moods = try viewContext.fetch(fetchRequest)
            
            // Delete all fetched objects
            for mood in moods {
                viewContext.delete(mood)
            }
            
            // Save the context to apply changes
            try viewContext.save()
            print("All moods deleted.")
        } catch {
            print("Failed to delete all moods: \(error.localizedDescription)")
        }
    }
}

struct DeleteAllMoodsView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAllMoodsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
