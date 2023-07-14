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
    
    
    var body: some View {
        let colors = ["lightgreen", "lightyellow", "lightblue"].map { Color($0) }
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(width: 150, height: 150)
            
            
            
            VStack {
                Text(item.name)
                Text(item.freq)
                
                
                    .contextMenu {
                        Button(action: {
                            if let index = shelvesviewModel.items.firstIndex(of: item) {
                                shelvesviewModel.deleteItem(indexSet: IndexSet([index]))
                            }
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        Button(action: {
                            if let index = shelvesviewModel.items.firstIndex(of: item) {
                                shelvesviewModel.deleteItem(indexSet: IndexSet([index]))
                            }
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                    .onLongPressGesture {
                        // Handle the long press gesture if needed
                        
                    }
            }
        }
        
    }
    
    
    
    
    struct ShelvesView_Previews: PreviewProvider {
        
        static var item1 = ItemModel(name: "Accutane", freq: "Daily", time: .none)
        static var item2 = ItemModel(name: "Zenatane", freq: "Monthly", time: .none)
        static var previews: some View {
            Group {
                ShelvesView(item: item1)
                ShelvesView(item: item2)
            }.previewLayout(.sizeThatFits).environmentObject(ShelvesviewModel())
            
        }
    }
}
