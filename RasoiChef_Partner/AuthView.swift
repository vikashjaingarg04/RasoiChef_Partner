//
//  AuthView.swift
//  RasoiChef_Partner
//
//  Created by Ankit Jain on 18/05/25.
//

import SwiftUI

struct AuthView: View {
    @State private var isLogin = true

    var body: some View {
        NavigationView {
            VStack {
                Text(isLogin ? "Partner Login" : "Chef Registration")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 40)

                if isLogin {
                    LoginView()
                } else {
                    SignupView()
                }

                Button(action: {
                    isLogin.toggle()
                }) {
                    Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Log In")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }
            }
            .padding()
        }
    }
}
