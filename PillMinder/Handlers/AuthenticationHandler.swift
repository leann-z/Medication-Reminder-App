//
//  AuthenticationHandler.swift
//  PillMinder
//
//  Created by Leann Hashishi on 7/27/23.
//

import Foundation
import Firebase
import GoogleSignIn
import AuthenticationServices

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationHandler {
    static let shared = AuthenticationHandler()
    private init() {}

    let auth = Auth.auth()

    @Published var signedIn = false

    var isSignedIn: Bool {
        return auth.currentUser != nil
    }

   
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = auth.currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel (user: user)
    }


    func signOut() throws {
       try auth.signOut()
    }
}

// google specific functions
extension AuthenticationHandler {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await auth.signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

// Apple specific functions
extension AuthenticationHandler {
    
    @discardableResult
    func signInWithApple(credential: AuthCredential) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await auth.signIn(with: credential)
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            throw error
        }
    }
}

