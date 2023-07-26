//
//  ProfileView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/25/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var isSheetPresented = false
    var body: some View {
        NavigationView {
            ZStack {
                Color("creme").ignoresSafeArea()
                
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color("beige"))
                        .overlay(
                                                Button(action: {
                                                    isSheetPresented = true
                                                }, label: {
                                                    Image(systemName: "pencil.circle")
                                                        .foregroundColor(.black)
                                                        .font(.title)
                                                })
                                                .padding(8)
                                                , alignment: .bottomTrailing 
                                            ).sheet(isPresented: $isSheetPresented, content: {
                                                ProfilePickerView() // Present the View when the sheet is triggered
                                            })
                    
                    Spacer().frame(height: 450)
                }
                
                VStack {
                    Text("Your Profile").font(.custom(FontsManager.Avenir.heavy, size: 35)).fontWeight(.semibold)
                    
                    Spacer().frame(height: 120)
                 
                }
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(ShelvesviewModel())
    }
}
