//
//  ShelvesView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/12/23.
//

import SwiftUI

struct ShelvesView: View {
    
    let item: ItemModel
    @EnvironmentObject var shelvesviewModel: ShelvesviewModel
    @GestureState private var isLongPressing = false
    
    @State private var showEditMedicineView = false // 🔹 State for showing sheet
   
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(item.color)
                .frame(width: 150, height: 150)
                .overlay(Text(item.name).font(.custom(FontsManager.Avenir.regular, size: 30)))
                .contextMenu {
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            // Delete medicine item
                            if let index = shelvesviewModel.items.firstIndex(of: item) {
                                shelvesviewModel.deleteItem(indexSet: IndexSet([index]))
                            }
                        }
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                    Button(action: {
                        self.showEditMedicineView = true // 🔹 Open Edit View in a sheet
                    }) {
                        HStack {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                    }
                }
                .onLongPressGesture {
                    // Handle long press gesture if needed
                }
        }
        .sheet(isPresented: $showEditMedicineView) {
            EditmedicineView(item: item)
        }
    }
}

struct ShelvesView_Previews: PreviewProvider {
    
    static var item1 = ItemModel(name: "Accutane", freq: "Daily", time: .none)
    static var item2 = ItemModel(name: "Zenatane", freq: "Weekends", time: .none)
    
    static var previews: some View {
        Group {
            ShelvesView(item: item1)
            ShelvesView(item: item2)
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(ShelvesviewModel())
        .environmentObject(UserSettings())
    }
}
