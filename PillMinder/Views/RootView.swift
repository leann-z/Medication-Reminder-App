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
            if isUserSignedIn { // Step 3: Use NavigationView to handle navigation
                        HomescreenView()
                    } else {
                        ContentView(isUserSignedIn: $isUserSignedIn) // Pass the @State variable to the SignInView
                    }
                }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let isUserSignedIn = Binding<Bool>(
                    get: { false }, // Set the initial value to false for the preview
                    set: { _ in }
                )
        RootView().environmentObject(ShelvesviewModel()).environmentObject(UserSettings())
    }
}
