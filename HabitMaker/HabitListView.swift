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
                //NavigationLink {
                //    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                HStack{
                    if let name = item.name {
                        Text(name)
                    }
                    Spacer()
                    //if item.streak > 0 { // uncomment before release
                    Text("Streak: " + String(item.streak))
                    Spacer()
                    //} // uncomment before release
                    
                    Button(action: {}) {
                        Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.done ? .green : .gray)
                            .onTapGesture {
                                item.done.toggle()
                            }
                    }
                    
                    
                    //label: {
                    //Text(item.timestamp!, formatter: itemFormatter)
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    struct HabitListView_Previews: PreviewProvider {
        static var previews: some View {
            HabitListView()
        }
    }
}
