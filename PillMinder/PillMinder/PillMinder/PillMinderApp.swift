//
//  PillMinderApp.swift
//  PillMinder
//
//  Created by Leann Hashishi on 6/25/23.
//

import SwiftUI

@main
struct PillMinderApp: App {
    
    @StateObject var shelvesviewModel: ShelvesviewModel
        
        init() {
            _shelvesviewModel = StateObject(wrappedValue: ShelvesviewModel())
        }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }.environmentObject(shelvesviewModel)
           
        }
    }
}
