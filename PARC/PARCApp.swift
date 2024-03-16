//
//  PARCApp.swift
//  PARC
//
//  Created by Ayman Ali on 17/10/2023.
//

import SwiftUI
import FirebaseCore
import LocalAuthentication

@main
struct PARCApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isUnlocked = false
    
    var body: some Scene {
        WindowGroup {
            LandingPage().preferredColorScheme(.light)
                .onAppear() {
                    UserDefaults.standard.set(false, forKey: "is_unlocked")
                    authenticate()
                }
        }
    }
    
    // Reference - https://www.youtube.com/watch?v=0Bcui9hyXhY
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to secure your app from being accessed by unauthorised parties"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                    UserDefaults.standard.set(true, forKey: "is_unlocked")
                } else {
                    // Unsuccessful auth
                }
            }
        } else {
            UserDefaults.standard.set(true, forKey: "is_unlocked")
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

