//
//  AdinAccount.swift
//  PARC
//
//  Created by Ayman Ali on 29/10/2023.
//

import SwiftUI

struct AdminAccount: View {
    @AppStorage("full_name") var fullName: String = ""
    @AppStorage("email") var email: String = ""
    @State var showProfileImagePicker = false
    @Binding var profile_image: UIImage?
    @Binding var init_profile_image: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .center) {
                    HStack {
                        VStack {
                            Button(action: { showProfileImagePicker.toggle() }) {
                                if let image = profile_image {
                                    Image(uiImage: profile_image!)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(100)
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                }
                            }
                            
                            if init_profile_image != profile_image {
                                Button(action: {
                                    UserDefaults.standard.removeObject(forKey: "profile_image")
                                    UpdateDB().updateUserTable(primary_key: "email", primary_key_value: email, table: "users", updated_key: "picture", updated_value: CreateDB().upload_logo_image(image: profile_image!, folder: "profile_images")) { response in
                                    }
                                    withAnimation(.easeOut(duration: 0.25)) {
                                        self.init_profile_image = profile_image
                                    }
                                }) {
                                    ZStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(Color.white)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.black, lineWidth: 1.25)
                                                )
                                                .frame(width: 80, height: 25)
                                            
                                            Text("Confirm Changes")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.022))
                                        }
                                    }
                                    .padding(.top, 5)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(fullName)
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.08))

                            Text("Member since November 2023")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                                .foregroundColor(Color("Custom_Gray"))
                        }
                        .padding(.leading, 10)
                    }
                    .frame(width: max(0, geometry.size.width-40))
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            Text("Set Pin")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            
                            Button(action: {}) {
                                HStack {
                                    Text("Set")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.038))
                                }
                                .frame(width: max(0, geometry.size.width-300), height: 35)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                            }
                            
                        }
                        .padding(.horizontal).padding(.top)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                            .frame(height: 1)
                        
                        HStack {
                            
                            Button(action: {}) {
                                HStack {
                                    Text("Log out")
                                        .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                        .fontWeight(.bold)
                                }
                                .frame(width: max(0, geometry.size.width-233), height: 45)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
//                                .border(Color.black, width: 1)
                                .cornerRadius(5)
                            }
                            
//                            Button(action: {}) {
//                                HStack {
//                                    Text("Withdraw")
//                                        .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
//                                        .fontWeight(.bold)
//                                }
//                                .frame(width: max(0, geometry.size.width-233), height: 45)
//                                .background(Color("Loss"))
//                                .foregroundColor(Color.white)
////                                .border(Color.black, width: 1)
//                                .cornerRadius(5)
//                            }
                            .padding(.leading, 15)
                            
                        }
                        .padding(.top, 40)
                        
                        Spacer()
                    }
                }
                }
                .sheet(isPresented: $showProfileImagePicker) {
                    ImagePicker(image: $profile_image)
                }
                .frame(width: max(0, geometry.size.width-40))
                .multilineTextAlignment(.center)
                .padding(.leading).padding(.top)
                .foregroundColor(.black)
            }
        }
}

//#Preview {
//    AdminAccount()
//}
