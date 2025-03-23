//
//  ContentView.swift
//  PillMinder
//
//  Created by Leann Hashishi on 6/25/23.
// Main screen

import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseAuth
import GoogleSignInSwift
import AuthenticationServices


struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func SignInGoogle() async throws {
        
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        let GIDSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = GIDSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = GIDSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        try await AuthenticationHandler.shared.signInWithGoogle(tokens: tokens)
    }
    
    func SignInApple(credential: ASAuthorizationAppleIDCredential) async throws {
            guard let idTokenData = credential.identityToken,
                  let idTokenString = String(data: idTokenData, encoding: .utf8) else {
                throw URLError(.badServerResponse)
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nil)
            try await AuthenticationHandler.shared.signInWithApple(credential: credential)
        }
    
    func saveSignInDate() {
        let signInDate = Date()
        UserDefaults.standard.set(signInDate, forKey: "UserSignInDate")
    }
    
    func retrieveSignInDate() -> String? {
        if let signInDate = UserDefaults.standard.object(forKey: "UserSignInDate") as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short

            return formatter.string(from: signInDate)
        } else {
            return nil
        }
    }
    
}

struct ContentView: View {
    @StateObject private var authenticationviewmodel = AuthenticationViewModel()
    
    let notify = NotificationHandler()
    
    @EnvironmentObject var shelvesviewModel: ShelvesviewModel
    
    @Binding var isUserSignedIn: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color("creme").ignoresSafeArea() // background color
                
                Image("pillsbg") //background image
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
                    
                    Spacer().frame(height: 400)
                    
                    
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)) {
                        Task {
                            do {
                                try await authenticationviewmodel.SignInGoogle()
                                    isUserSignedIn = true
                                    
                                
                            } catch {
                               print(error)
                            }
                        }
                    }.frame(height: 50) // Set a fixed height for consistency
                    .padding(.horizontal, 40)
                    

                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            if let credential = authResults.credential as? ASAuthorizationAppleIDCredential {
                                Task {
                                    do {
                                        try await authenticationviewmodel.SignInApple(credential: credential)
                                        isUserSignedIn = true
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 40)
                    .signInWithAppleButtonStyle(.white)
                        
                    }
                            
                
            }
            
        }.onAppear {
            notify.askPermission()
        }
    }
}
                                   
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let isUserSignedIn = Binding<Bool>(
                    get: { false }, // Set the initial value to false for the preview
                    set: { _ in }
                )

        ContentView(isUserSignedIn: isUserSignedIn).environmentObject(ShelvesviewModel()).environmentObject(UserSettings())
        
        
    }
}
