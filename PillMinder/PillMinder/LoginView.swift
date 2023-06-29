//
//  LoginView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 6/29/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        NavigationView {
            
            
            ZStack {
                
                
                Color("creme").ignoresSafeArea() // background color
                VStack {
                    Image("pills")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    
                    
                    Spacer()
                    
                    
                    
                }.edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Spacer().frame(height: 200)
                    
                    Text("Welcome back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("darknavy"))
                    
                    Text("Please enter your details below to continue.")
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "envelope").padding().foregroundColor(.gray)
                        
                        TextField("Email", text: $email).padding()
                    }.overlay(Divider().frame(width: 300), alignment: .bottom)
                    
                    
                    
                    HStack {
                        Image(systemName: "key").padding().foregroundColor(.gray)
                        
                        SecureField("Password", text: $password).padding()
                    }.overlay(Divider().frame(width: 300), alignment: .bottom)
                    
                    
                    
                    
                    
                    
                    Spacer().frame(height: 50)
                    
                    Button(action: {
                        // Button action
                    }) {
                        Text("Log in                        ")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("darknavy"))
                            .padding()
                            .background(Color("beige"))
                            .cornerRadius(40)
                            .padding(.bottom, 10)
                    }
                    
                    Text("New to PillMinder?").foregroundColor(.gray)
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Sign up")
                            .foregroundColor(Color("darknavy"))
                            .underline()
                    }
                        
                    
                    
                }
                
                
                
            }
            
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
