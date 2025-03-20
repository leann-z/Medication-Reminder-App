//
//  ItemModel.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/11/23.
//

import Foundation
import SwiftUI

let colors = [Color("lightgreen"), Color("lightblue"), Color("lightyellow")]
var colorIndex = 0

struct ItemModel: Identifiable, Codable {
    let id: String
    var name: String
    var freq: String
    var time: Date?
    var colorIndex: Int
    var color: Color {
        return colors[colorIndex]
    }
    var remindToRefill: Bool // 🔹 Store whether the refill reminder is enabled
    var refillDate: Date? // 🔹 Store the refill
      
    
    init(id: String = UUID().uuidString, name: String, freq: String, time: Date?, colorIndex: Int? = nil, remindToRefill: Bool = false, refillDate: Date? = nil) {
        self.id = id
        self.name = name
        self.freq = freq
        self.time = time
        
        // Assign a color index only when the item is first created
        self.colorIndex = colorIndex ?? Int.random(in: 0..<colors.count)
        
        self.remindToRefill = remindToRefill
        self.refillDate = refillDate
        
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, name: name, freq: freq, time: time, colorIndex: colorIndex, remindToRefill: remindToRefill, refillDate: refillDate)
    }
}

struct ColorAsset {
  let name: String
  let color: Color
  
    init(name: String) {
      self.name = name

      if let uiColor = UIColor(named: name) {
        self.color = Color(uiColor)
      } else {
        self.color = .gray // default
      }

    }
}



