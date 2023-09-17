//
//  AccountView.swift
//  PubUp
//
//  Created by Shannon Burke on 4/20/23.
//

import SwiftUI
import Firebase

struct AccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State var colorScheme = false
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("\(Auth.auth().currentUser?.email ?? "Anonymous")")
                    .navigationBarBackButtonHidden()
                  
                    Spacer()
                    
                    Button {
                        do {
                            try Auth.auth().signOut()
                            print("Sign Out Successful!")
                                    
                            dismiss()
                        } catch {
                            print("ERROR: Could not sign out!")
                        }
                        
                        } label: {
                            Text("Sign Out")
                        }
                }
                .padding(.horizontal)
                .padding(.top, 30)
                Button("Color Scheme") {
                    colorScheme.toggle()
                }.padding(.top, 1)
                Spacer()
            }
            .preferredColorScheme(colorScheme ? .dark : .light)
        }
        
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountView()
                .environmentObject(HomeViewModel())
        }
    }
}


//Cards
//    .frame(maxWidth: .infinity)
//    .frame(height: 300)
//    .background(LinearGradient(gradient: Gradient(colors: [Color("menuStart"), Color("menuEnd")]), startPoint: .top, endPoint: .bottom))
//    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
//    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
//    .padding(.horizontal, 30)
