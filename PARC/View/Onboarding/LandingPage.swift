//
//  ContentView.swift
//  PARC
//
//  Created by Ayman Ali on 17/10/2023.
//

import SwiftUI
import Auth0

struct LandingPage: View {
    @State var loggedInUser = true
    @State var loggedInAdmin = false
    @State var isInvestmentConfirmed = false
    @State var isAuthenticated = false
    @State var userProfile = Profile.empty
    @State var isShownHomePage = true
    
    var body: some View {
        NavigationStack {
//            if email
//            if loggedInUser {
//                UserHome(isInvestmentConfirmed: $isInvestmentConfirmed)
//            } else {
//                LandingContent()
//            }
//            if loggedInAdmin {
//                AdminHome()
//            } else {
            if isAuthenticated {
                UserHome(isInvestmentConfirmed: $isInvestmentConfirmed, isShownHomePage: $isShownHomePage)
            } else {
                LandingContent(isAuthenticated: $isAuthenticated)
            }
//            }
        }
    }
    
//    init() {
//        for familyName in UIFont.familyNames {
//            for fontname in UIFont.fontNames(forFamilyName: familyName) {
//                print("\(familyName) \(fontname)")
//            }
//        }
//    }
}

struct LandingContent: View {
    @State private var index = 0
    @State var login_shown = false
    @State var user_home_shown = false
    @State var admin_home_shown = false
    @State var signup_shown = false
    @State var isInvestmentConfirmed = false
    @Binding var isAuthenticated: Bool
    @State var userProfile = Profile.empty
    var onboarding_assets = ["shop", "Onboarding_2", "Onboarding_3"]
    var body: some View {
        
        GeometryReader { geometry in
                ZStack {
                    Color("Primary").ignoresSafeArea()
                    VStack {
                        Image("Logo").frame(width: max(0, geometry.size.width), height: 100).padding(.top,40)
                        
                        TabView(selection: $index) {
                            ForEach((0..<3), id: \.self) { index in
                                if index == 0{
                                    VStack {
                                        LottieView(name: onboarding_assets[index], speed: 1.5, loop: true)
                                        Text("Start investing in franchises with only $100!").font(Font.custom("Nunito-Black", size: min(geometry.size.width, geometry.size.height) * 0.058))
                                            .fontWeight(.bold)
                                    }
                                    .frame(width: 320, height: 300)
                                    .foregroundColor(Color("Secondary"))
                                    .multilineTextAlignment(.center)
                                    
                                } else {
                                    Image(onboarding_assets[index])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: max(0, geometry.size.width-70), height: max(0, geometry.size.height-80))
                                        .padding(.bottom, 40)
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        
                        Spacer()
                        
                        Button(action: { login() }) {
                            HStack {
                                Text("Get Started")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.075))
                            }
                            .frame(width: 320, height: 60)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .border(Color.black, width: 1)
                            .cornerRadius(5)
                        }
                        .padding(.bottom, 10)
                        
//                        Button(action: { login_shown.toggle() }) {
//                            HStack {
//                                Text("Log in")
//                                    .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
//                                    .fontWeight(.bold)
//                            }
//                            .frame(width: 330, height: 55)
//                            .background(Color("Secondary"))
//                            .foregroundColor(Color.white)
//                            .border(Color.black, width: 1)
//                            .cornerRadius(5)
//                        }
//                        .padding(.bottom)
//                        .sheet(isPresented: $login_shown) {
//                            LoginView(login_shown: $login_shown, user_home_shown: $user_home_shown, admin_home_shown: $admin_home_shown).presentationDetents([.height(500)])
//                        }
                    }
                    .padding(.bottom)
//                    .navigationDestination(isPresented: $user_home_shown) {
//                        UserHome(isInvestmentConfirmed: $isInvestmentConfirmed).navigationBarHidden(true)
//                    }
//                    .navigationDestination(isPresented: $admin_home_shown) {
//                        AdminHome().navigationBarHidden(true)
//                    }
                }
            }
    }
}

extension LandingContent {
    private func login() {
        Auth0
            .webAuth()
            .start { result in
                
                switch result {
                  case .failure(let error):
                    print("Failed with: \(error)")
                  
                  case .success(let credentials):
                    self.isAuthenticated = true
                    self.userProfile = Profile.from(credentials.idToken)
                    UserDefaults.standard.set(self.userProfile.given_name, forKey: "first_name")
                    UserDefaults.standard.set(self.userProfile.family_name, forKey: "family_name")
                    UserDefaults.standard.set(self.userProfile.name, forKey: "full_name")
                    UserDefaults.standard.set(self.userProfile.email, forKey: "email")
                    UserDefaults.standard.set(self.userProfile.picture, forKey: "picture")
                }
                
            }
    }
    
    private func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                    case .failure(let error):
                        print("Failed with: \(error)")
                        
                    case .success:
                        self.isAuthenticated = false
                }
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
