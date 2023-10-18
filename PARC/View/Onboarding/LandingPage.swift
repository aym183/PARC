//
//  ContentView.swift
//  PARC
//
//  Created by Ayman Ali on 17/10/2023.
//

import SwiftUI

struct LandingPage: View {
    @State private var index = 0
    @State var login_shown = false
    @State var user_home_shown = false
    @State var admin_home_shown = false
    @State var signup_shown = false
    var onboarding_assets = ["shop", "Onboarding_2", "Onboarding_3"]
    var body: some View {
        
        GeometryReader { geometry in
            NavigationStack{
                ZStack {
                    Color("Primary").ignoresSafeArea()
                    VStack {
                        Image("Logo").frame(width: max(0, geometry.size.width), height: 100).padding(.top,40)
                        
                        TabView(selection: $index) {
                            ForEach((0..<3), id: \.self) { index in
                                if index == 0{
                                    VStack {
                                        LottieView(name: onboarding_assets[index], speed: 1.5)
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
                                        .padding(.bottom, 30)
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        
                        Spacer()
                        
                        Button(action: {}) {
                            HStack {
                                Text("Get Started")
                                    .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                    .fontWeight(.bold)
                            }
                            .frame(width: 330, height: 55)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .border(Color.black, width: 1)
                            .cornerRadius(5)
                        }
                        .padding(.bottom, 10)
                        
                        Button(action: { login_shown.toggle() }) {
                            HStack {
                                Text("Log in")
                                    .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                    .fontWeight(.bold)
                            }
                            .frame(width: 330, height: 55)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .border(Color.black, width: 1)
                            .cornerRadius(5)
                        }
                        .padding(.bottom)
                        .sheet(isPresented: $login_shown) {
                            LoginView(login_shown: $login_shown, user_home_shown: $user_home_shown, admin_home_shown: $admin_home_shown).presentationDetents([.height(500)])
                        }
                    }
                    .padding(.bottom)
                    .navigationDestination(isPresented: $user_home_shown) {
                        UserHome().navigationBarHidden(true)
                    }
                }
            }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
