//
//  UserAccount.swift
//  PARC
//
//  Created by Ayman Ali on 19/10/2023.
//

import SwiftUI
import URLImage

struct UserAccount: View {
    @Binding var payoutsValue: Int
    @Binding var secondaryTransactionsValue: Int
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
                            Text("Verification Status")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Text("Completed")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                                .foregroundColor(Color("Profit"))
                        }
                        .padding(.horizontal).padding(.top, 10)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                            .frame(height: 1)
                        
                        HStack {
                            Text("Transaction History")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Button(action: {}) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 1.25)
                                        )
                                        .frame(width: 100, height: 35)
                                    
                                    Text("Check")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                }
                            }
                        }
                        .padding(.horizontal).padding(.top, 10)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                            .frame(height: 1)
                            
                        
                        HStack {
                            Text("Set Pin")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Button(action: {}) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 1.25)
                                        )
                                        .frame(width: 100, height: 35)
                                    
                                    Text("Set Pin")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                }
                            }
                        }
                        .padding(.horizontal).padding(.top, 10)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                            .frame(height: 1)
                        
                        HStack {
                            Text("Balance")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Text("£\(formattedNumber(input_number: payoutsValue+secondaryTransactionsValue))")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                                .foregroundColor(.black)
                                .padding(.trailing, 13)
                        }
                        .padding(.leading).padding(.trailing).padding(.top, 10)
                    }
                    .padding(.top)
                    .foregroundColor(Color("Custom_Gray"))
                
                    HStack {
                        
                        Button(action: {}) {
                            HStack {
                                Text("Log out")
                                    .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                    .fontWeight(.bold)
                            }
                            .frame(width: max(0, geometry.size.width-260), height: 45)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Text("Withdraw")
                                    .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                    .fontWeight(.bold)
                            }
                            .frame(width: max(0, geometry.size.width-260), height: 45)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                        }
                        .padding(.leading, 15)
                        
                    }
                    .padding(.top)
                    
                    Spacer()
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

//struct UserAccount_Previews: PreviewProvider {
//    static var previews: some View {
//        UserAccount(payoutsValue: .constant(100))
//    }
//}
