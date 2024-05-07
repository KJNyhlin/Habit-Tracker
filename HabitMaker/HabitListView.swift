//
//  HabitListView.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-03.
//

import SwiftUI

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        //predicate: NSPredicate(format: "done == %d", false), // om man vill visa ett urval
        animation: .default)
    private var items: FetchedResults<Item>
    var body: some View {
        List {
            ForEach(items) { item in
                HStack{
                    if let name = item.name {
                        Text(name)
                    }
                    Spacer()
                    //if item.streak > 0 { // consider uncommenting before release
                    Text("Streak: " + String(item.streak))
                    Spacer()
                    //} // consider uncommenting before release, see above
                    Button(action: {
                        markDone(item)
                    }) {
                        Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.done ? .green : .gray)
                            //.onTapGesture {
                             //   item.done.toggle()
                            //}
                    }
                }
            }
            .onDelete(perform: deleteItems)
            
        }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func markDone(_ item: Item) {
            withAnimation {
                item.done.toggle()  // Toggle the 'done' state
                if item.done {
                    item.latestDoneDate = Date()  // Update the latestDoneDate to today
                } else {
                    item.latestDoneDate = nil
                }
                saveContext()
                //print(item)
            }
        }

        private func saveContext() {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    
    struct HabitListView_Previews: PreviewProvider {
        static var previews: some View {
            HabitListView()
        }
    }
    
}
