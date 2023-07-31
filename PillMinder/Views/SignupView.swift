//
//  SignupView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 6/29/23.
//

import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var shelvesviewModel: ShelvesviewModel
    
    
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
                    
                    Text("Hello!")
                        .font(.custom(FontsManager.Avenir.heavy, size: 30))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("darknavy"))
                    
                    Text("Please enter your details below to continue.")
                        .font(.custom(FontsManager.Avenir.light, size: 16))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "envelope").padding().foregroundColor(.gray)
                        
                        TextField("Email", text: $email)
                            .disableAutocorrection(true).autocapitalization(.none)
                                .padding()
                                .font(.custom(FontsManager.Avenir.light, size: 17))
                    }.overlay(Divider().frame(width: 300), alignment: .bottom)
                    
                    
                    
                    HStack {
                        Image(systemName: "key").padding().foregroundColor(.gray)
                        
                        SecureField("Password", text: $password).disableAutocorrection(true).autocapitalization(.none).padding().font(.custom(FontsManager.Avenir.light, size: 17))
                    }.overlay(Divider().frame(width: 300), alignment: .bottom)
                    
                    
                    
                    
                    
                    
                    Spacer().frame(height: 50)
                    
                    
                    NavigationLink(destination: HomescreenView().onAppear {
                        
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                        
                        shelvesviewModel.signUp(email: email, password: password)
                        
                    }.navigationBarBackButtonHidden(true)) {
                        
                                Text("Sign up                        ")
                            .font(.custom(FontsManager.Avenir.heavy, size: 30))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("darknavy"))
                                    .padding()
                                    .background(Color("beige"))
                                    .cornerRadius(40)
                                    .padding(.bottom, 10)
                                    
                            }
                        
                    
                    
                    Text("Already have an account?").foregroundColor(.gray).font(.custom(FontsManager.Avenir.regular, size: 14))
                    
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                        Text("Log in")
                            .foregroundColor(Color("darknavy"))
                            .underline().font(.custom(FontsManager.Avenir.heavy, size: 14))

                    }
                                            
                    
                    
                    
                }
                
                
                
            }
            
        }
    }
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView().environmentObject(ShelvesviewModel())
    }
}
