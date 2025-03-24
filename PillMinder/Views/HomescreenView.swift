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
        get: { false },
        set: { _ in }
    )
    
    @State private var showAddMedicine = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("creme").ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: ProfileView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color("beige"))
                                .padding(.trailing)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Hi! 👋")
                            .font(.custom(FontsManager.Avenir.heavy, size: 40))
                            .fontWeight(.heavy)
                            .foregroundColor(Color("darknavy"))
                        
                        Text("Welcome to PillMinder!")
                            .font(.custom(FontsManager.Avenir.light, size: 16))
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Your")
                                    .font(.custom(FontsManager.Avenir.light, size: 28))
                                    .foregroundColor(Color("darknavy"))
                                
                                Text("Medicine")
                                    .font(.custom(FontsManager.Avenir.heavy, size: 28))
                                    .foregroundColor(Color("darknavy"))
                            }
                            .padding(.leading)
                            
                            Spacer()
                            
                            Button(action: { showAddMedicine = true }) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().fill(Color("beige")))
                            }
                            .padding(.trailing)
                        }
                        .padding(.top)
                        
                        if shelvesviewModel.items.isEmpty {
                            Spacer()
                            Text("No medicine to remind you to take yet... click + now!")
                                .font(.custom(FontsManager.Avenir.heavy, size: 24))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("darknavy"))
                                .padding()
                            Spacer()
                        } else {
                            ScrollView {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    ForEach(shelvesviewModel.items) { item in
                                        ShelvesView(item: item)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showAddMedicine) {
            AddmedicineView()
        }
    }
}

struct HomescreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomescreenView()
        }
        .environmentObject(ShelvesviewModel())
        .environmentObject(UserSettings())
    }
}
