//
//  ContentView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 6/25/23.
// Main screen

import SwiftUI
import GoogleSignIn
import Firebase

struct ContentView: View {
    let notify = NotificationHandler()
    @EnvironmentObject var shelvesviewModel: ShelvesviewModel
    
    var body: some View {
        
        NavigationView {
           
            if shelvesviewModel.isSignedIn {
                HomescreenView()
            } else {
                LoginView()
            }
            
            ZStack {
                Color("creme").ignoresSafeArea() // background color
                Image("pills") //background image
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                
                VStack {
                    
                    
                    
                    
                    
                    Text("PILLMINDER") //title of the app
                        .font(.custom(FontsManager.Avenir.heavy, size: 40))
                        .fontWeight(.heavy)
                        .foregroundColor(Color("darknavy"))
                        .multilineTextAlignment(.center).padding(.top, 20)
                    
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) //brings this specific vstack to the top
                
                VStack {
                    
                    Text("Never miss a dose!")
                        .font(.custom(FontsManager.Avenir.heavy, size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color("darknavy"))
                        .padding(.bottom, 5)
                        .padding(.top, 80)
                    
                    
                    
                    Text("Get personalized notifications that remind you when to take your medication so you don’t have to worry again.")
                        .font(.custom(FontsManager.Avenir.heavy, size: 16))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .foregroundColor(Color(.black).opacity(0.5))
                        .padding()
                        .padding()
                    
                }
                
                
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                    
                            Text("Log in                        ")
                            .font(.custom(FontsManager.Avenir.heavy, size: 30))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("lightnavy"))
                                .cornerRadius(40)
                                .padding(.bottom, 10)
                    }.onTapGesture {
                       
                    }
                                   
                    
                    NavigationLink(destination: SignupView().navigationBarBackButtonHidden(true)) {
                        Text("Sign up                    ")
                            .font(.custom(FontsManager.Avenir.heavy, size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("darknavy"))
                            .cornerRadius(40)
                            .padding(.bottom, 10)
                    }
                        
                    }
                    
                    
                
                
                
                
                
                
                
            }
            
        }.onAppear {
            notify.askPermission()
        }
    }
}
                                   
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ShelvesviewModel())
    }
}
