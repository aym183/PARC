//
//  AdinAccount.swift
//  PARC
//
//  Created by Ayman Ali on 29/10/2023.
//

import SwiftUI

// This view is responsible for handling all interactions when an admin wants to view their account and log out
struct AdminAccount: View {
    @AppStorage("full_name") var full_name: String = ""
    @AppStorage("email") var email: String = ""
    @State var show_profile_image_picker = false
    @State var logged_out = false
    @State var showing_log_out = false
    @State var is_shown_home_page = false
    @Binding var profile_image: UIImage?
    @Binding var init_profile_image: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .center) {
                    HStack {
                        VStack {
                            Button(action: { show_profile_image_picker.toggle() }) {
                                if let image = profile_image {
                                    ZStack {
                                        Image(uiImage: profile_image!)
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(100)
                                        
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "pencil.circle.fill")
                                                    .resizable()
                                                    .foregroundColor(.gray)
                                                    .opacity(0.8)
                                                    .frame(width: 25, height: 25)
                                            }
                                            Spacer()
                                        }
                                        .frame(width: 110, height: 80)
                                    }
                                    
                                } else {
                                    ZStack {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                        
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button(action: {}) {
                                                    Image(systemName: "pencil.circle.fill")
                                                        .resizable()
                                                        .foregroundColor(.gray)
                                                        .opacity(0.8)
                                                }
                                                .frame(width: 25, height: 25)
                                            }
                                            Spacer()
                                        }
                                        .frame(width: 110, height: 80)
                                    }
                                }
                            }
                            
                            if init_profile_image != profile_image {
                                Button(action: {
                                    UserDefaults.standard.removeObject(forKey: "profile_image")
                                    UpdateDB().update_user_table(primary_key: "email", primary_key_value: email, table: "users", updated_key: "picture", updated_value: CreateDB().upload_logo_image(image: profile_image!, folder: "profile_images")) { response in
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
                            Text(full_name)
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
                            
                            Button(action: { showing_log_out.toggle() }) {
                                HStack {
                                    Text("Log out")
                                        .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                        .fontWeight(.bold)
                                }
                                .frame(width: geometry.size.width*0.44, height: 45)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                            }
                            .padding(.leading, 15)
                            
                        }
                        .padding(.top, 40)
                        
                        Spacer()
                    }
                }
            }
            .alert(isPresented: $showing_log_out) {
                Alert(
                    title: Text("Are you sure you want to log out?"),
                    primaryButton: .default(Text("Yes")) {
                        delete_all_user_defaults_data()
                        logged_out.toggle()
                    },
                    secondaryButton: .destructive(Text("No")) {}
                )
            }
            .navigationDestination(isPresented: $logged_out) {
                LandingContent(is_shown_home_page: $is_shown_home_page).navigationBarBackButtonHidden()
            }
            .sheet(isPresented: $show_profile_image_picker) {
                ImagePicker(image: $profile_image)
            }
            .frame(width: max(0, geometry.size.width-40))
            .multilineTextAlignment(.center)
            .padding(.leading).padding(.top)
            .foregroundColor(.black)
        }
    }
}
