//
//  LoginView.swift
//  PubUp
//
//  Created by Shannon Burke on 4/11/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    @State private var buttonsDisabled = true
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
            ZStack {
                Color("loginCard").ignoresSafeArea()
                VStack {
                    Text("PubUp")
                        .font(Font.custom("ClimateCrisis-Regular", size: 50))
                        .foregroundColor(Color("loginFont"))
                        .offset(x: -6,y: 80)
                        .shadow(radius: 20)
                    Text("PubUp")
                        .font(Font.custom("ClimateCrisis-Regular", size: 50))
                        .foregroundColor(Color("loginCard"))
                    Group {
                        TextField("Email", text: $email)
                            .frame(width: 250, height: 30)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .submitLabel(.next)
                            .focused($focusField, equals: .email) // field is bound to the email case
                            .onSubmit {
                                focusField = .password // will move to password field
                            }
                            .onChange(of: email) { _ in
                                enableButtons()
                            }
                        
                        SecureField("Password", text: $password)
                            .frame(width: 250, height: 30)
                            .textInputAutocapitalization(.never)
                            .submitLabel(.done)
                            .focused($focusField, equals: .password) // field is bound to the password case
                            .onSubmit {
                                focusField = nil // will dismiss the keyboard
                            }
                            .onChange(of: password) { _ in
                                enableButtons()
                            }
                            .padding()
                        
                    }
                    .textFieldStyle(.roundedBorder)
                    
                    
                    HStack {
                        Button {
                            register()
                        } label : {
                            Text("Sign Up")
                        }
                        .padding(.trailing)
                        
                        Button {
                            login()
                        } label : {
                            Text("Sign In")
                        }
                        .padding(.leading)
                        
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                    .font(.title2)
                    .padding()
                    .disabled(buttonsDisabled).foregroundColor(.white)
                  
                    
                    Spacer()
                    
                }
                .frame(width: 300, height: 400)
                .background(Color("login"))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .shadow(color: Color("loginFont").opacity(0.3), radius: 20, x: 0, y: 10)
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            
        }
        
        .onAppear {
            // if user is already logged in, navigate to the new screen & skip login screen
            if Auth.auth().currentUser != nil {
                print("Login Successful!")
                presentSheet = true
            }
            
        }
        .fullScreenCover(isPresented: $presentSheet) {
            TabBarView()
            
        }
        
    }
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { // sign-up error occured
                print("SIGN-UP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGN-UP ERROR: \(error.localizedDescription)"
                showAlert = true
            } else {
                print("Registration Successful!")
               presentSheet = true
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { // login error occured
                print("LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showAlert = true
            } else {
                print("Login Successful!")
                presentSheet = true
                viewModel.requestPermision()
            }
        }
    }
    
    func enableButtons() {
        let goodEmail = email.count >= 6 && email.contains("@")
        let goodPassword = password.count > 8
        buttonsDisabled = (goodEmail && goodPassword)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
