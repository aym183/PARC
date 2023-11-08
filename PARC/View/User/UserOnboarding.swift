//
//  UserOnboarding.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import SwiftUI

struct UserOnboarding: View {
    @State var isShowingVerificationHint = false
    @State var isShowingCardHint = false
    @State private var selectedBackground: DropdownMenuOption? = nil
    @State var selectedYes = false
    @State var selectedNo = false
    @Binding var isShownOnboarding: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
//                    .blur(radius: 10)
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .center) {
                                
                                HStack {
                                    Text("A few final details")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.08))
                                        .padding(.bottom, 10)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("What is your background?")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                
                                DropdownMenu(selectedOption: self.$selectedBackground, placeholder: "Select", options: DropdownMenuOption.testAllValues)
                                    .padding(.bottom, 15).padding(.top, -10)
                                    .frame(width: max(0, geometry.size.width - 80))
                                
                                // print(selectedBackground?.option) to get the option selected by user
                               
                                HStack {
                                    Text("Have you ever invested before?")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 10)
                                
                                
                                HStack{
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black, lineWidth: 1.5)
                                            )
                                            
                                        Button(action: {
                                            if self.selectedNo == true {
                                                self.selectedNo.toggle()
                                            }
                                            self.selectedYes.toggle()
                                        }) {
                                            Text("Yes")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                                .frame(width: 135, height: 45)
                                                .background(selectedYes ? Color("Secondary") : .white)
                                                .foregroundColor(selectedYes ? .white : .black)
    //                                        .background(Color("Secondary"))
                                        }
                                        .cornerRadius(5)
                                    }
                                    .frame(width: 135, height: 45)
                                    
                                    Spacer()
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black, lineWidth: 1.5)
                                            )
                                            
                                        Button(action: { 
                                            if self.selectedYes == true {
                                                self.selectedYes.toggle()
                                            }
                                            self.selectedNo.toggle()
                                        }) {
                                            Text("No")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                                .frame(width: 135, height: 45)
                                                .background(selectedNo ? Color("Secondary") : .white)
                                                .foregroundColor(selectedNo ? .white : .black)
    //                                        .background(Color("Secondary"))
                                        }
                                        .cornerRadius(5)
                                    }
                                    .frame(width: 135, height: 45)
                                }
                                .padding(.top, -10)
                                
                                
                                HStack {
                                    Text("Identity Verification")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                    
                                    Button(action: {
                                        withAnimation(.easeOut(duration: 0.5)) { isShowingVerificationHint.toggle() }
                                    }) {
                                        Image(systemName: "questionmark")
                                            .background(Circle().fill(.gray).font(.system(size: 12)).frame(width: 25, height: 25).opacity(0.3))
                                            .fontWeight(.semibold).padding(.vertical).padding(.leading, 5).padding(.top, -3)
                                    }
                                    Spacer()
                                }
                                if isShowingVerificationHint {
                                    CardView(hint: "Allowed documents - Passport, Residency Permit, or Proof of Address")
                                        .transition(.scale)
                                        .padding(.top, -25)
                                        .padding(.leading, 120)
                                        .padding(.bottom)
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 1.25)
                                        )
                                        .frame(width: max(0, geometry.size.width - 80), height: 45)
                                    
                                    Button(action: {}) {
                                        HStack {
                                            Text("Upload")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                        }
                                        .frame(width: max(0, geometry.size.width - 80), height: 45)
                                        .background(Color("Secondary"))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(5)
                                    }
                                }
                                .padding(.top, -20)
                                
                                Spacer()
                                
                                HStack {
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black, lineWidth: 1.25)
                                            )
                                        
                                        Button(action: { 
                                            print(selectedBackground?.option)
                                            if selectedNo {
                                                print("Not Invested")
                                            } else {
                                                print("Has Invested")
                                            }
                                            
                                        }) {
                                                Text("Submit")
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                                    .frame(width: 135, height: 45)
                                        }
                                        .background(Color("Secondary"))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(5)
                                    }
                                    .frame(width: 135, height: 45)
                                
                                    Spacer()
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black, lineWidth: 1.25)
                                            )
                                            
                                        Button(action: { 
                                            UserDefaults.standard.set(true, forKey: "onboarding_completed")
                                            isShownOnboarding.toggle()
                                        }) {
                                            Text("Skip")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                                .frame(width: 135, height: 45)
                                        }
                                        .foregroundColor(Color.black)
                                        .cornerRadius(5)
                                    }
                                    .frame(width: 135, height: 45)
                                }
                                .padding(.horizontal, 0)
                                //                            HStack {
                                //                                Text("Card Details")
                                //                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                //
                                //                                Button(action: {
                                //                                    withAnimation(.easeOut(duration: 0.5)) { isShowingCardHint.toggle() }
                                //                                    }) {
                                //                                    Image(systemName: "questionmark")
                                //                                        .background(Circle().fill(.gray).font(.system(size: 12)).frame(width: 25, height: 25).opacity(0.3))
                                //                                        .fontWeight(.semibold).padding(.vertical).padding(.leading, 5).padding(.top, -3)
                                //                                }
                                //                                Spacer()
                                //
                                //                            }
                                //
                                //
                                //                            if isShowingCardHint {
                                //                                CardView(hint: "This is needed to verify your card details and ensure a smooth investing experience")
                                //                                    .transition(.scale)
                                //                                    .padding(.top, -25)
                                //                                    .padding(.leading, 110)
                                //                            }
                                //
                                //                            Button(action: {  }) {
                                //                                HStack {
                                //                                    Text("Upload")
                                //                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                //                                }
                                //                                .frame(width: 320, height: 45)
                                //                                .background(Color("Secondary"))
                                //                                .foregroundColor(Color.white)
                                //                                .border(Color.black, width: 1)
                                //                                .cornerRadius(5)
                                //                            }
                                //
                            }
                            .padding(10)
                            .frame(height: max(0, geometry.size.height-300))
                    }
                    .frame(width: max(0, geometry.size.width - 70))
                    }
                    .frame(width: max(0, geometry.size.width - 40), height: max(0, geometry.size.height-280))
//                    Spacer()
//                    Text("Hello")
//                    Spacer()
                }
                .foregroundColor(.black)
                .cornerRadius(10)
                
                
            }
            
        }
    }
}

struct CardView: View {
    let hint: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("TextField"))
            .foregroundColor(.white)
            .frame(width: 180, height: 70)
            .overlay(Text(hint).foregroundColor(.black).font(Font.custom("Nunito-Medium", size: 12)).padding(10))
    }
}

//#Preview {
//    UserOnboarding()
//}