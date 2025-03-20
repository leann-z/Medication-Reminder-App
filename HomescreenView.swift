//
//  HomescreenView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/3/23.
//

import SwiftUI
import NavigationTransitions
import Firebase
import GoogleSignIn

struct HomescreenView: View {
     
    @EnvironmentObject var shelvesviewModel: ShelvesviewModel
    
    var name = Auth.auth().currentUser?.displayName
    
    let isUserSignedIn = Binding<Bool>(
                get: { false }, // Set the initial value to false for the preview
                set: { _ in }
            )
  
    var body: some View {
       
        NavigationView {
            ZStack {
                Color("creme").ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                       
                        Spacer().frame(width: 300)
                        
                        NavigationLink(destination: ProfileView().navigationBarBackButtonHidden(true)) { // Wrap the Image with NavigationLink
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(Color("beige"))
                                        }
                    }
                    
                    
                    
                    Text("Hi! 👋").fontWeight(.heavy).frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding().font(.custom(FontsManager.Avenir.heavy, size: 40)).padding(.bottom, -20).foregroundColor(Color("darknavy"))
                    
                    
                    
                    Text("Welcome to PillMinder!").frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding().foregroundColor(.gray).font(.custom(FontsManager.Avenir.light, size: 16))
                    
                    Spacer().frame(height: 550)
                    
                }
                
                VStack {
                    
                    Spacer().frame(height: 90)
                    
                    VStack {
                        
                        HStack(spacing: -10) {
                            Group {
                                Text("Your").padding(.leading, 20).foregroundColor(Color("darknavy"))
                                Text("Medicine").fontWeight(.bold).frame(maxWidth: .infinity, alignment: .topLeading)
                                    .padding().foregroundColor(Color("darknavy"))
                                
                            }.font(.custom(FontsManager.Avenir.light, size: 28))
                            
                            
                            Spacer()
                            
                            NavigationLink(destination: AddmedicineView().navigationBarBackButtonHidden(true)) {
                                Image(systemName: "plus").background(Color("beige")).font(.largeTitle).cornerRadius(15).padding(20).padding(.trailing, 40).foregroundColor(.white)
                            }
                            
                            
                        }.padding(.top, 80)
                        
                    }
                        
                        VStack {
                            
                            
                            
                            if (shelvesviewModel.items.isEmpty) {
                                
                                Text("No medicine to remind you to take yet... click + now!").font(.custom(FontsManager.Avenir.heavy, size: 30))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("darknavy")).padding().padding().padding().fontWidth(.condensed)
                                Spacer()
                            }
                            
                            else {
                                ScrollView {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                        
                                        ForEach(shelvesviewModel.items) { item in
                                           
                                            
                                            ShelvesView(item: item)
                                            
                                            
                                        }
                                    }.padding()
                                }
                            }
                        
                    }
                
            }
                }
                
                
        }
            
        }
        
        
    }


struct HomescreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            HomescreenView()
        }.environmentObject(ShelvesviewModel()).environmentObject(UserSettings())
        
       
    }
}
