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
    
    @State private var showingSheet = false
    @State private var habitName = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Habit name")
                    Spacer()
                    Text("Streak")
                    Spacer()
                    Text("Done today")
                }
                .padding()
                HabitListView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        self.showingSheet = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                AddHabitView(habitName: $habitName, showingSheet: $showingSheet) {
                    addItem()
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.streak = 0
            newItem.done = false
            newItem.name = habitName
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

        
        
        
        let itemFormatter: DateFormatter = {
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
        struct AddHabitView_Previews: PreviewProvider {
            static var previews: some View {
                EmptyView() // Kringgå felmeddelandet
            }
        }
    
