//
//  PillMinderApp.swift
//  PillMinder
//
//  Created by Leann Hashishi on 6/25/23.
//

import SwiftUI
import SwiftUIIntrospect
import Firebase
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

enum AppScreen: String, CaseIterable {
    case contentView = "ContentView"
    case signupView = "SignupView"
    case loginView = "LoginView"
    case homescreenView = "HomescreenView"
    case addmedicineView = "AddmedicineView"
    case shelvesView = "ShelvesView"
    case editmedicineView = "EditmedicineView"
    case profileView = "ProfileView"
    case profilepickerView = "ProfilePickerView"
    // Add more screens as needed
}


@main
struct PillMinderApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var shelvesviewModel: ShelvesviewModel
    
    
    @AppStorage("lastView") var lastView: AppScreen?
    
        
        init() {
            _shelvesviewModel = StateObject(wrappedValue: ShelvesviewModel())
        }
    
   
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                switchContentView()
            }.environmentObject(shelvesviewModel)
              
            
           
        }
        
    }
    @ViewBuilder
        func switchContentView() -> some View {
            // If there's a lastView saved, switch to the appropriate screen
            if let lastView = lastView {
                switch lastView {
                case .contentView:
                    NavigationView {
                        ContentView()
                    }.environmentObject(shelvesviewModel)
                case .signupView:
                    NavigationView {
                        SignupView()
                    }.environmentObject(shelvesviewModel)
                case .loginView:
                    NavigationView {
                        LoginView()
                    }.environmentObject(shelvesviewModel)
                case .homescreenView:
                    NavigationView {
                        HomescreenView()
                    }.environmentObject(shelvesviewModel)
                case .addmedicineView:
                    NavigationView {
                        AddmedicineView()
                    }.environmentObject(shelvesviewModel)
                case .shelvesView:
                    NavigationView {
                        let selectedItem = shelvesviewModel.items.first ?? ItemModel(name: "", freq: "", time: .none, color: .clear)
                        ShelvesView(item: selectedItem)
                    }.environmentObject(shelvesviewModel)
                case .editmedicineView:
                    NavigationView {
                        let selectedItem = shelvesviewModel.items.first ?? ItemModel(name: "", freq: "", time: .none, color: .clear)
                        EditmedicineView(item: selectedItem)
                    }.environmentObject(shelvesviewModel)
                case .profileView:
                    NavigationView {
                        ProfileView()
                    }.environmentObject(shelvesviewModel)
                case .profilepickerView:
                    NavigationView {
                        ProfilePickerView()
                    }.environmentObject(shelvesviewModel)
                }
            } else {
                // If there's no lastView or the lastView is not recognized, show ContentView by default
                NavigationView {
                    ContentView()
                }.environmentObject(shelvesviewModel)
            }
        }
    }
    

    
    


