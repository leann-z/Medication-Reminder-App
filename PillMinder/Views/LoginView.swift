//
//  LoginView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 6/29/23.
//

import SwiftUI
import FirebaseAuth



struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State var items: [ItemModel] = []
    
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
                    
                    Text("Welcome back!")
                        .font(.custom(FontsManager.Avenir.heavy, size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color("darknavy"))
                    
                    Text("Please enter your details below to continue.")
                        .font(.custom(FontsManager.Avenir.light, size: 16))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "envelope").padding().foregroundColor(.gray)
                        
                        TextField("Email", text: $email).disableAutocorrection(true).autocapitalization(.none).padding()
                    }.overlay(Divider().frame(width: 300), alignment: .bottom).font(.custom(FontsManager.Avenir.light, size: 17))
                    
                    
                    
                    HStack {
                        Image(systemName: "key").padding().foregroundColor(.gray)
                        
                        SecureField("Password", text: $password).disableAutocorrection(true).autocapitalization(.none).padding()
                    }.overlay(Divider().frame(width: 300), alignment: .bottom).font(.custom(FontsManager.Avenir.light, size: 17))
                    
                    
                    
                    
                    
                    
                    Spacer().frame(height: 50)
                    
                    
                    
                    NavigationLink(destination: HomescreenView().onAppear {
                        // make sure email and pass is not empty
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                        // call log in here
                        
                        shelvesviewModel.signIn(email: email, password: password)
                    }.navigationBarBackButtonHidden(true)) {
                        Text("Log in                        ")
                            .font(.custom(FontsManager.Avenir.heavy, size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color("darknavy"))
                            .padding()
                            .background(Color("beige"))
                            .cornerRadius(40)
                            .padding(.bottom, 10)
                            
                    }
                    
                    Text("New to PillMinder?").foregroundColor(.gray).foregroundColor(.gray).font(.custom(FontsManager.Avenir.regular, size: 14))
                    
                    NavigationLink(destination: SignupView().navigationBarBackButtonHidden(true)) {
                        Text("Sign up")
                            .foregroundColor(Color("darknavy"))
                            .underline().font(.custom(FontsManager.Avenir.heavy, size: 14))

                    }
                        
                    
                    
                }
                
                
                
            }
            
        }
            
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(ShelvesviewModel())
    }
}
