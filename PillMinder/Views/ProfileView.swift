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
    
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("creme").ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Label("", systemImage: "house").foregroundColor(.black)
                        }
                        
                        Spacer()
                    }.padding(.top, 10)
                        .padding(.horizontal)
                    
        // Profile image
                            VStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(Color("beige"))

                                Text("Your Profile")
                                    .font(.custom(FontsManager.Avenir.heavy, size: 35))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("darknavy"))

                               
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 30)

                            //Spacer()

                            // Info boxes
                    VStack(spacing: 16) {
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("lightnavy"))
                                .frame(width: 280, height: 80)
                                .overlay(
                                    VStack {
                                        Text("Active Medication")
                                            .font(.custom(FontsManager.Avenir.heavy, size: 17))
                                        Text("\(shelvesviewModel.items.count)")
                                    }
                                    .foregroundColor(.white)
                                )
                            Spacer()
                        }

                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("lightnavy"))
                                .frame(width: 280, height: 80)
                                .overlay(
                                    VStack {
                                        Text("Achievements")
                                            .font(.custom(FontsManager.Avenir.heavy, size: 17))
                                        Text("Coming soon!")
                                    }
                                    .foregroundColor(.white)
                                )
                            Spacer()
                        }
                    }
                            .padding(.horizontal)

                            Spacer()

                            // Log Out
                            Button(action: {
                                Task {
                                    do {
                                        try viewModel.logOut()
                                        UserDefaults.standard.set(false, forKey: "IsUserSignedIn")
                                        print("success")
                                    } catch {
                                        print("error")
                                    }
                                }
                            }) {
                                Text("Log Out")
                                    .font(.custom(FontsManager.Avenir.regular, size: 17))
                                    .foregroundColor(.red)
                                    .underline()
                            }
                            .padding(.bottom, 40)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .navigationBarHidden(true)
                }
            }
        }

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        //let isUserSignedIn = Binding.constant(false)
        
        ProfileView().environmentObject(ShelvesviewModel()).environmentObject(UserSettings())
    }
}
