//
//  ContentView.swift
//  PARC
//
//  Created by Ayman Ali on 17/10/2023.
//

import SwiftUI
import Auth0


// Decides which view is displayed whether it is a (i) New user, (ii) Logged in user, or (iii) Logged in admin
struct LandingPage: View {
    @State var loggedInUser = true
    @State var loggedInAdmin = false
    @State var isInvestmentConfirmed = false
    @State var isWithdrawalConfirmed = false
    @State var isSharesListed = false
    @State var userProfile = Profile.empty
    @State var isShownHomePage = false
    @AppStorage("logged_in") var logged_in: Bool = false
    @AppStorage("email") var email: String = ""
    var body: some View {
        NavigationStack {
            if logged_in && !isShownHomePage && email == "ayman.ali1302@gmail.com" {
                UserHome(isInvestmentConfirmed: $isInvestmentConfirmed, isWithdrawalConfirmed: $isWithdrawalConfirmed, isShownHomePage: $isShownHomePage)
            } else if logged_in && !isShownHomePage && email != "ayman.ali1302@gmail.com" {
                AdminHome()
            } else {
                LandingContent(isShownHomePage: $isShownHomePage)
            }
        }
    }
}

// Displays content to new users (i.e. the landing page)
struct LandingContent: View {
    @State private var index = 0
    @State var isInvestmentConfirmed = false
    @State var isWithdrawalConfirmed = false
    @State var isAuthenticated = false
    @State var isSharesListed = false
    @State var userProfile = Profile.empty
    @Binding var isShownHomePage: Bool
    @State var email = ""
    var onboarding_assets = ["shop", "Onboarding_2", "Onboarding_3"]
    @AppStorage("logged_in") var logged_in: Bool = false
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
                        .frame(width: max(0, geometry.size.width-50), height: 60)
                        .background(Color("Secondary"))
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                    }
                    .padding(.bottom)
                    
                    Text("*Your capital is at risk").font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.032)).foregroundColor(Color("Custom_Gray"))
                    
                }
                .padding(.bottom)
            }
            .navigationDestination(isPresented: $logged_in) {
                if email == "ayman.ali1302@gmail.com" {
                    UserHome(isInvestmentConfirmed: $isInvestmentConfirmed, isWithdrawalConfirmed: $isWithdrawalConfirmed, isShownHomePage: $isShownHomePage).navigationBarHidden(true)
                } else {
                    AdminHome().navigationBarBackButtonHidden(true)
                }
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
                    self.isShownHomePage = true
                    self.userProfile = Profile.from(credentials.idToken)
                    UserDefaults.standard.set(self.userProfile.given_name, forKey: "first_name")
                    UserDefaults.standard.set(self.userProfile.family_name, forKey: "family_name")
                    UserDefaults.standard.set(self.userProfile.name, forKey: "full_name")
                    UserDefaults.standard.set(self.userProfile.email, forKey: "email")
                    self.email = self.userProfile.email
                    UserDefaults.standard.set(true, forKey: "logged_in")
                    UserDefaults.standard.set(0, forKey: "net_worth")
                    UserDefaults.standard.set(false, forKey: "onboarding_completed")
                    DispatchQueue.global(qos: .userInteractive).async {
                        CreateDB().create_user(email: self.userProfile.email, first_name: self.userProfile.given_name, last_name: self.userProfile.family_name, full_name: self.userProfile.name, picture: self.userProfile.picture) { response in
                            
                            if response == "User Created" {
                                CreateDB().create_onboarding_email(name: self.userProfile.given_name, email: self.userProfile.email)
                            } else if response == "User already exists" {
                                UserDefaults.standard.set(true, forKey: "onboarding_completed")
                            }
                        }
                    }
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
                    UserDefaults.standard.set(false, forKey: "logged_in")
                }
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
