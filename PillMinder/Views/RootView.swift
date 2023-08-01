//
//  RootView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/31/23.
//

import SwiftUI
import Foundation

class UserSettings: ObservableObject {
    @Published var isUserSignedIn: Bool {
            didSet {
                UserDefaults.standard.set(isUserSignedIn, forKey: "IsUserSignedIn")
            }
        }

        init() {
            self.isUserSignedIn = UserDefaults.standard.bool(forKey: "IsUserSignedIn")
        }
}

struct RootView: View {
   // @State private var isUserSignedIn = false
    @AppStorage("IsUserSignedIn") private var isUserSignedIn: Bool = false
    
    var body: some View {
        NavigationView {
            if isUserSignedIn {
                        HomescreenView()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3))
                    } else {
                        ContentView(isUserSignedIn: $isUserSignedIn) .transition(.opacity) // Apply transition to the HomescreenView
                            .animation(.easeInOut(duration: 0.3))
                    }
                }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        
        RootView().environmentObject(ShelvesviewModel()).environmentObject(UserSettings())
    }
}
