//
//  AccountView.swift
//  PubUp
//
//  Created by Shannon Burke on 4/19/23.
//

import SwiftUI
import Firebase

struct TabBarView: View {
    @State private var selection = 1
    @State var showAccount = false
    @State private var angle: Double = 0
   
    
    var body: some View {
        TabView(selection: $selection) {
            
            HomeView().tabItem {
                HStack {
                    VStack(alignment: .center) {
                        if selection == 1 {
                            Image(systemName: "house.fill")
                        } else {
                            Image(systemName: "house")
                                .environment(\.symbolVariants, .none) // stops icon being filled by default
                        }
                    }
                }
                
            }
            .tag(1)
        
            FavoritesView()
                .tabItem {
                    VStack(alignment: .center) {
                        if selection == 2 {
                            Image(systemName: "heart.fill")
                            
                        } else {
                            Image(systemName: "heart")
                                .environment(\.symbolVariants, .none) // stops icon being filled by default
                        }
                    }
                }
                .tag(2)
            
            AccountView()
                .tabItem {
                    VStack(alignment: .center) {
                        if selection == 3 {
                            
                            Image(systemName: "person.crop.circle.fill")
                            
                        } else {
                            Image(systemName: "person.crop.circle")
                                .environment(\.symbolVariants, .none) // stops icon being filled by default
                            
                        }
                    }
                    
                    
                }
                .tag(3)
            
        }
        .tint(Color("login"))
        .navigationBarBackButtonHidden()
        
        
        //        VStack {
        //            Spacer()
        //            VStack(spacing: 16) {
        //               MenuRow(title: "Account", icon: "person.circle.fill")
        //
        //                Button {
        //                    do {
        //                        try Auth.auth().signOut()
        //                        print("Sign Out Successful!")
        //
        //                        dismiss()
        //                    } catch {
        //                        print("ERROR: Could not sign out!")
        //                    }
        //                } label: {
        //                    MenuRow(title: "Sign Out", icon: "arrow.left.circle.fill")
        //                }
        //
        //                Button {
        //
        //                } label: {
        //                    MenuRow(title: "Favorites", icon: "heart.circle.fill")
        //                }
        //                .navigationDestination(for: String.self) { view in
        //                    if view == "ListView" {
        //                       FavoritesView()
        //                    }
        //                }
        //            }
        //            .frame(maxWidth: .infinity)
        //            .frame(height: 300)
        //            .background(LinearGradient(gradient: Gradient(colors: [Color("menuStart"), Color("menuEnd")]), startPoint: .top, endPoint: .bottom))
        //            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        //            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
        //            .padding(.horizontal, 30)
        //        }
        //        .padding(.bottom, 30)
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabBarView()
                .environmentObject(HomeViewModel())
        }
    }
}
