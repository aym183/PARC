//
//  UserOnboarding.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import SwiftUI

// This is the onboarding process a users goes through to gauge their financial stability and experience investing
struct UserOnboarding: View {
    @State var is_showing_verification_hint = false
    @State var is_showing_card_hint = false
    @State private var selected_background: DropdownMenuOption? = nil
    @State var selected_yes = false
    @State var selected_no = false
    @State var show_verification_image_picker = false
    @State var net_worth = ""
    @State var is_valid_input = true
    @State var verification_image: UIImage?
    @AppStorage("email") var email: String = ""
    @Binding var is_shown_onboarding: Bool
    var is_net_worth_valid: Bool {
        net_worth.count>0 && Int(net_worth)!>0 && (selected_no || selected_yes) && self.verification_image != nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
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
                                    Text("Estimated net worth")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                    
                                    Spacer()
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 1.25)
                                        )
                                        .frame(width: max(0, geometry.size.width - 80), height: 50)
                                        .opacity(0.5)
                                    
                                    TextField("", text: $net_worth, prompt: Text("500000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-80), height: 50)
                                        .cornerRadius(5)
                                        .font(Font.custom("Nunito-Bold", size: 16))
                                        .keyboardType(.numberPad)
                                        .onChange(of: self.net_worth, perform: { value in
                                            withAnimation(.easeOut(duration: 0.2)) {
                                                if self.net_worth.count > 0 {
                                                    if Int(self.net_worth)! == 0 { is_valid_input = false }
                                                } else { is_valid_input = true }
                                            }
                                        })
                                }
                                .padding(.top, -10).padding(.bottom, 5)
                                
                                if !is_valid_input {
                                    HStack {
                                        Spacer()
                                        Text("Amount should be greater than 0").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                                    }
                                }
                                
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
                                            if self.selected_no == true {
                                                self.selected_no.toggle()
                                            }
                                            self.selected_yes.toggle()
                                        }) {
                                            Text("Yes")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                                .frame(width: 135, height: 45)
                                                .background(selected_yes ? Color("Secondary") : .white)
                                                .foregroundColor(selected_yes ? .white : .black)
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
                                            if self.selected_yes == true {
                                                self.selected_yes.toggle()
                                            }
                                            self.selected_no.toggle()
                                        }) {
                                            Text("No")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                                .frame(width: 135, height: 45)
                                                .background(selected_no ? Color("Secondary") : .white)
                                                .foregroundColor(selected_no ? .white : .black)
                                        }
                                        .cornerRadius(5)
                                    }
                                    .frame(width: 135, height: 45)
                                }
                                .padding(.top, -10).padding(.bottom, 5)
                                
                                
                                HStack {
                                    Text("Identity Verification")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                    
                                    if let image = self.verification_image {
                                        Text("✅").padding(.vertical)
                                    } else {
                                        Button(action: {
                                            withAnimation(.easeOut(duration: 0.5)) { is_showing_verification_hint.toggle() }
                                        }) {
                                            Image(systemName: "questionmark")
                                                .background(Circle().fill(.gray).font(.system(size: 12)).frame(width: 25, height: 25).opacity(0.3))
                                                .fontWeight(.semibold).padding(.vertical).padding(.leading, 5).padding(.top, -3)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                if is_showing_verification_hint {
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
                                    
                                    Button(action: { show_verification_image_picker.toggle() }) {
                                        HStack {
                                            Text("Upload")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                        }
                                        .frame(width: max(0, geometry.size.width - 80), height: 45)
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
                                            UserDefaults.standard.set(true, forKey: "onboarding_completed")
                                            UserDefaults.standard.set(true, forKey: "verification_completed")
                                            UserDefaults.standard.set(Int(net_worth)!, forKey: "net_worth")
                                            is_shown_onboarding.toggle()
                                        }) {
                                            Text("Submit")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                                .frame(width: 135, height: 45)
                                        }
                                        .background(Color("Secondary"))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(5)
                                        .disabled(is_net_worth_valid ? false : true)
                                        .opacity(is_net_worth_valid ? 1 : 0.75)
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
                                        
                                        Button(action: { is_shown_onboarding.toggle() }) {
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
                            }
                            .padding(10)
                            .frame(height: max(0, geometry.size.height-300))
                        }
                        .frame(width: max(0, geometry.size.width - 70))
                    }
                    .sheet(isPresented: $show_verification_image_picker) {
                        ImagePicker(image: $verification_image)
                    }
                    .frame(width: max(0, geometry.size.width - 40), height: max(0, geometry.size.height-280))
                }
                .foregroundColor(.black)
                .cornerRadius(10)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .ignoresSafeArea(.keyboard)
            
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

#Preview {
    UserOnboarding(is_shown_onboarding: .constant(true))
}
