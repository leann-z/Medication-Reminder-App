//
//  ContentView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 6/25/23.
// Main screen

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            
            
            ZStack {
                Color("creme").ignoresSafeArea() // background color
                Image("pills") //background image
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                
                VStack {
                    
                    
                    
                    Text("PILLMINDER") //title of the app
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color("darknavy"))
                        .multilineTextAlignment(.center).padding(.top, 20)
                    
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) //brings this specific vstack to the top
                
                VStack {
                    
                    Text("Never miss a dose!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("darknavy"))
                        .padding(.bottom, 10)
                        .padding(.top, 80)
                    
                    
                    
                    Text("Get personalized notifications that remind you when to take your medication so you don’t have to worry again.")
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .foregroundColor(Color(.black).opacity(0.5))
                    
                }
                
                
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: LoginView()) {
                    
                            Text("Log in                        ")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("lightnavy"))
                                .cornerRadius(40)
                                .padding(.bottom, 10)
                    }
                                   
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Sign up                    ")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("darknavy"))
                            .cornerRadius(40)
                    }
                        
                    }
                    
                    
                
                
                
                
                
                
                
            }
            
        }
    }
}
                                   
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
