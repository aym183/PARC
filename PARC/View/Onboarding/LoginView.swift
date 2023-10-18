//
//  LoginView.swift
//  PARC
//
//  Created by Ayman Ali on 18/10/2023.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isEmailValid: Bool = true
    @Binding var login_shown: Bool
    @Binding var user_home_shown: Bool
    @Binding var admin_home_shown: Bool
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color("Primary").ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Login").font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.1))

                            Spacer()
                            Button(action: { login_shown.toggle() }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        .foregroundColor(Color("Secondary"))
                        
                        TextField("", text: $email, prompt: Text("Email").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 70).background(.white)
                            .cornerRadius(5)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .font(Font.custom("Nunito-Bold", size: 16))
                            .onChange(of: email) { newValue in
                                withAnimation(.easeOut(duration: 0.2)) {
                                    validateEmail()
                                }
                            }
                        
                        if !isEmailValid {
                            HStack {
                                Spacer()
                                Text("Invalid Email").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                            }
                        }
                        
                        SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16)))
                            .padding()
                            .frame(width: max(0, geometry.size.width-40), height: 70)
                            .background(.white)
//                            .border(.black, width: 1)
                            .cornerRadius(5)
                            .font(Font.custom("Nunito-Bold", size: 16))
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .padding(.top,10)
                        
                        Text("By continuing you agree to PARC's Terms of Service")
                            .font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035))
                            .padding(.top, 5)
                            .padding(.leading, 0.5)
                            .foregroundColor(Color("Secondary"))
                        
                        Spacer()
                        
                        Button(action: {
                            print("Logged in")
                            login_shown.toggle()
                            user_home_shown.toggle()
                        }) {
                            HStack {
                                Text("Log in")
                                    .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.07))
                                    .fontWeight(.bold)
                            }
                            .frame(width: max(0, geometry.size.width-40), height: 55)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .border(Color.black, width: 1)
                            .cornerRadius(5)
                        }
                        .padding(.bottom)
                        
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                }
        }
    }
    
    private func validateEmail() {
            let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            isEmailValid = emailPredicate.evaluate(with: email)
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
