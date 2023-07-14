//
//  ItemModel.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/11/23.
//

import Foundation

struct ItemModel: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let freq: String
    let time: Date?
}
