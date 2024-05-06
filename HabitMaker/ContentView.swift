//
//  ContentView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-04-30.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack {
                HabitListView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        
        Text("Select an item")
    }
    
    
    private func addItem() {
        withAnimation {
            // Varje cell ska visa namnet på vanan och streak (OBS alltså inte datumet då det skapades) samt en knapp för "done". Man kan också klicka på texten för att komma till en sida som visar komplett info om den vanan (Infosida).
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.streak = 0
            newItem.done = false
            //TODO: här ska man få ange namn
            newItem.name = "another habit"
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}



private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    //formatter.dateStyle = .short
    //formatter.timeStyle = .none
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
