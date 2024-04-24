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
    @State var logged_in_user = true
    @State var logged_in_admin = false
    @State var is_investment_confirmed = false
    @State var is_withdrawal_confirmed = false
    @State var is_shares_listed = false
    @State var user_profile = Profile.empty
    @State var is_shown_home_page = false
    @AppStorage("logged_in") var logged_in: Bool = false
    @AppStorage("email") var email: String = ""
    var body: some View {
        NavigationStack {
            if logged_in && !is_shown_home_page && email == "ayman.ali1302@gmail.com" {
                UserHome(is_investment_confirmed: $is_investment_confirmed, is_withdrawal_confirmed: $is_withdrawal_confirmed, is_shown_home_page: $is_shown_home_page)
            } else if logged_in && !is_shown_home_page && email != "ayman.ali1302@gmail.com" {
                AdminHome()
            } else {
                LandingContent(is_shown_home_page: $is_shown_home_page)
            }
        }
    }
}

// Displays content to new users (i.e. the landing page)
struct LandingContent: View {
    @State private var index = 0
    @State var is_investment_confirmed = false
    @State var is_withdrawal_confirmed = false
    @State var isAuthenticated = false
    @State var is_shares_listed = false
    @State var user_profile = Profile.empty
    @Binding var is_shown_home_page: Bool
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
                    UserHome(is_investment_confirmed: $is_investment_confirmed, is_withdrawal_confirmed: $is_withdrawal_confirmed, is_shown_home_page: $is_shown_home_page).navigationBarHidden(true)
                } else {
                    AdminHome().navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

// The extensions is responsible for initiating and cancelling user sign up/sign in actions
extension LandingContent {
    private func login() {
        Auth0
            .webAuth()
            .start { result in
                
                switch result {
                case .failure(let error):
                    print("Failed with: \(error)")
                    
                case .success(let credentials):
                    self.is_shown_home_page = true
                    self.user_profile = Profile.from(credentials.idToken)
                    UserDefaults.standard.set(self.user_profile.given_name, forKey: "first_name")
                    UserDefaults.standard.set(self.user_profile.family_name, forKey: "family_name")
                    UserDefaults.standard.set(self.user_profile.name, forKey: "full_name")
                    UserDefaults.standard.set(self.user_profile.email, forKey: "email")
                    self.email = self.user_profile.email
                    UserDefaults.standard.set(true, forKey: "logged_in")
                    UserDefaults.standard.set(0, forKey: "net_worth")
                    UserDefaults.standard.set(false, forKey: "onboarding_completed")
                    DispatchQueue.global(qos: .userInteractive).async {
                        CreateDB().create_user(email: self.user_profile.email, first_name: self.user_profile.given_name, last_name: self.user_profile.family_name, full_name: self.user_profile.name, picture: self.user_profile.picture) { response in
                            
                            if response == "User Created" {
                                CreateDB().create_onboarding_email(name: self.user_profile.given_name, email: self.user_profile.email)
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
