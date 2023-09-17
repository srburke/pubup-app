//
//  PubUpApp.swift
//  PubUp
//
//  Created by Shannon Burke on 4/11/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct PubUpApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let viewModel = HomeViewModel()
  
    
  
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, viewModel.container.viewContext)
                
        }
    }
}
