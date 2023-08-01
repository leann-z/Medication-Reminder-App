//
//  ProfileView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/25/23.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    func logOut() throws {
        try AuthenticationHandler.shared.signOut()
    }
}

struct ProfileView: View {
    @State private var isSheetPresented = false
    
    @StateObject private var authenticationviewmodel = AuthenticationViewModel()
    
    @EnvironmentObject var shelvesviewModel: ShelvesviewModel
    
    @StateObject private var viewModel = ProfileViewModel()
    
   // @Binding var isUserSignedIn: Bool
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("creme").ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        
                        NavigationLink(destination: HomescreenView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "house").resizable()
                                .frame(width: 25, height: 25).foregroundColor(.black)
                        }
                        
                        Spacer().frame(width: 300)
                    }
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color("beige"))
                    
// !!! BELOW IS THE PROFILE PICKER FUNCTIONALITY. COMMENTED OUT UNTIL THERE ARE PROFILE PICTURES MADE
//                        .overlay(
//                                                Button(action: {
//                                                    isSheetPresented = true
//                                                }, label: {
//                                                    Image(systemName: "pencil.circle")
//                                                        .foregroundColor(.black)
//                                                        .font(.title)
//                                                })
//                                                .padding(8)
//                                                , alignment: .bottomTrailing
//                                            ).sheet(isPresented: $isSheetPresented, content: {
//                                                ProfilePickerView() // Present the View when the sheet is triggered
//                                            })
                    
                    
                    Spacer().frame(height: 450)
                }
                
                VStack {
                    Text("Your Profile").font(.custom(FontsManager.Avenir.heavy, size: 35)).fontWeight(.semibold)
                    
                    Spacer().frame(height: 120)
                 
                }
                
                VStack {
                    
                    Spacer().frame(height: 400)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10) // Rounded Rectangle with corner radius
                            .foregroundColor(Color("lightnavy")) // Background color for the rounded rectangle
                        
                        VStack {
                            
                            
                            Text("Active Medication").font(.custom(FontsManager.Avenir.heavy, size: 17))
                            
                            let activeMedication = shelvesviewModel.items.count
                            
                            Text("\(activeMedication)")
                        }
                        .padding() // Add some padding around the text
                        .foregroundColor(.white)
                    }.padding()
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10) // Rounded Rectangle with corner radius
                            .foregroundColor(Color("lightnavy")) // Background color for the rounded rectangle
                        
                        VStack {
                            
                            
                            Text("Achievements").font(.custom(FontsManager.Avenir.heavy, size: 17))
                            
                            Text("Coming soon!")
                        }
                        .padding() // Add some padding around the text
                        .foregroundColor(.white)
                    }.padding()
                    Spacer().frame(height: 80)
                    
                    Button(action: {
                         
                        Task {
                            do {
                                try viewModel.logOut()
                                UserDefaults.standard.set(false, forKey: "IsUserSignedIn") // Set it to false after logging out
                                
                                print("success")
                            } catch {
                                print("error")
                            }
                        }
                       
                        
                        
                    }, label: {
                        Text("Log Out").font(.custom(FontsManager.Avenir.regular, size: 17)).foregroundColor(.red).underline()
                    })
                    
                    Spacer().frame(height: 80)
                }
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        //let isUserSignedIn = Binding.constant(false)
        
        ProfileView().environmentObject(ShelvesviewModel()).environmentObject(UserSettings())
    }
}
