//
//  SignUpNewUser.swift
//  Golympian
//
//  Created by Bernard Scott on 6/18/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct SignUpNewUser: View {
    
    @ObservedObject var emailViewModel = SignInEmailViewModel()
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
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
            
            Button {
                Task {
                    do {
                        try await authenticationViewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                SignInWithAppleButtonViewRepresentable(type: .signUp, style: .whiteOutline)
                    .allowsHitTesting(false)
            }
            .frame(height: 55)
            
            Spacer()
            
            Button {
                Task {
                    do {
                        try await emailViewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Finish Creating Account")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(.buttonBorder)
            }
        }
        .padding()
        .navigationTitle("Create New Account")
    }
}

#Preview {
    NavigationStack {
        SignUpNewUser(showSignInView: .constant(false))
    }
}
