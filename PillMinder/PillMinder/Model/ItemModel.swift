//
//  ItemModel.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/11/23.
//

import Foundation
import SwiftUI

let colors = [ColorAsset(name: "lightgreen"), ColorAsset(name: "lightblue"), ColorAsset(name: "lightyellow")]
var colorIndex = 0

struct ItemModel: Identifiable, Codable {
    let id: String
    var name: String
    var freq: String
    var time: Date?
    var color: Color {
       let index = abs(id.hashValue) % colors.count
       return colors[index].color
     }
      
    
    init(id: String = UUID().uuidString, name: String, freq: String, time: Date?, color: Color) {
        self.id = id
        self.name = name
        self.freq = freq
        self.time = time
        
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, name: name, freq: freq, time: time, color: color)
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



