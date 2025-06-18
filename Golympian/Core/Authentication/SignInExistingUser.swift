//
//  NEWAuthenticationView.swift
//  Golympian
//
//  Created by Bernard Scott on 6/18/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SignInExistingUser: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var emailViewModel = SignInEmailViewModel()
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @State private var alertToSignUp: Bool = false
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email", text: $emailViewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(.buttonBorder)
            
            SecureField("Password", text: $emailViewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(.buttonBorder)
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await authenticationViewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            Spacer()
            
            NavigationLink {
                SignUpNewUser(showSignInView: $showSignInView)
            } label: {
                Text("Create Account")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(.buttonBorder)
            }
            
            Button {
                Task {
                    do {
                        try await emailViewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        alertToSignUp = true
                    }
                }
            } label: {
                Text("Sign in")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(.buttonBorder)
            }
        }
        .padding()
        .navigationTitle("Sign Into Golympians")
        .alert("No Account Found", isPresented: $alertToSignUp) {
//            Button("Create Account", action: {
//                SignUpNewUser()
//            })
            NavigationLink("Create New Account") {
                SignUpNewUser(showSignInView: $showSignInView)
            }
            Button("Try again", role: .cancel, action:{})
        } message: {
            Text("No account with that email found. Create a new account or try a different email.")
        }
    }
}

#Preview {
    NavigationStack {
        SignInExistingUser(showSignInView: .constant(false))
    }
}
