//
//  ShelvesviewModel.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/12/23.
//

import Foundation

class ShelvesviewModel: ObservableObject {
    
    @Published var items: [ItemModel] = []
    
    init() {
        getItems()
    }
    
    func getItems() {
        let newItems = [ ItemModel(name: "Acc", freq: "Daily", time: .none), ItemModel(name: "Cheese", freq: "Monthly", time: .none)
        ]
        items.append(contentsOf: newItems)
    }
    
    func deleteItem(indexSet: IndexSet) {
        
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(name: String, freq: String) {
        let newItem = ItemModel(name: name, freq: freq, time: .none)
        items.append(newItem)
    }
}

extension ItemModel: Equatable {
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        // Implement the comparison logic based on the properties of ItemModel
        // Return true if the properties are equal, false otherwise
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.freq == rhs.freq && lhs.time == rhs.time
    }
}
