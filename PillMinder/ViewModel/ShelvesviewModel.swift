//
//  ShelvesviewModel.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/12/23.
//

import Foundation

class ShelvesviewModel: ObservableObject {
    @Published var someStateProperty: String = ""
    
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    let itemsKey: String = "items_key"
    
    init() {
        getItems()
    }
    
    func getItems() {

        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
        else { return }
        
        self.items = savedItems
        
    }
    
    func deleteItem(indexSet: IndexSet) {
        
        items.remove(atOffsets: indexSet)
        
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(name: String, freq: String, time: Date) {
        let newItem = ItemModel(name: name, freq: freq, time: time, color: .clear)
        items.append(newItem)
    }
    
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: {$0.id == item.id}) {
            items[index] = item.updateCompletion()
        }
        
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
}

extension ItemModel: Equatable {
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        // Implement the comparison logic based on the properties of ItemModel
        // Return true if the properties are equal, false otherwise
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.freq == rhs.freq && lhs.time == rhs.time
    }
}


