//
//  ContentView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-04-30.
//
//DET HÄR ÄR DEN NYA VERSIONEN

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingSheet = false
    @State private var habitName = ""
    @State private var showingDetail = false
    
    

    var body: some View {
        NavigationView {
            VStack {
                if !showingDetail {
                    HStack {
                        Text("Habit name")
                        Spacer()
                        Text("Streak")
                        Spacer()
                        Text("Done today")
                    }
                    .padding()
                }
                HabitListView(showingDetail: $showingDetail)
                
                //for testing, remove before release
                Button("Add Test Items") {
                    addTestItems()
                }
            }
                
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
    private func addTestItems() {
            // Definiera datumsträngarna
            let dateStrings = ["2024-05-06 12:00:00", "2024-05-05 12:00:00", "2024-05-03 12:00:00"]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let timeZone = TimeZone(identifier: "Europe/Stockholm") {
            dateFormatter.timeZone = timeZone
        } else {
            print("Failed to set timezone")
        }

            withAnimation {
                for dateString in dateStrings {
                    if let date = dateFormatter.date(from: dateString) {
                        let newItem = Item(context: viewContext)
                        newItem.latestDoneDate = date
                        newItem.streak = 0
                        newItem.done = false
                        newItem.name = "Habit on \(dateString)"
                    }
                }
                
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
            if let timeZone = TimeZone(identifier: "Europe/Stockholm") {
                formatter.timeZone = timeZone
            } else {
                print("Failed to set timezone")
            }
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
    
