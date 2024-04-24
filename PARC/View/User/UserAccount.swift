//
//  UserAccount.swift
//  PARC
//
//  Created by Ayman Ali on 19/10/2023.
//

import SwiftUI
import URLImage

// Shows the users their account with details such as withdrawable balance and transactio history
struct UserAccount: View {
    @Binding var payouts_value: Int
    @Binding var secondary_transactions_value: Int
    @AppStorage("full_name") var full_name: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("verification_completed") var verification_completed: Bool = false
    @State var show_profile_image_picker = false
    @State var logged_out = false
    @State var withdraw_request = false
    @State var withdraw_request_confirmed = false
    @State var showing_log_out = false
    @State var is_shown_home_page = false
    @State var is_investment_confirmed = false
    @State var is_withdrawal_confirmed = false
    @State var transaction_history_shown = false
    @Binding var profile_image: UIImage?
    @Binding var init_profile_image: UIImage?
    @Binding var user_holdings: [[String: String]]
    @Binding var user_holdings_sold: [[String: String]]
    @State var sorted_user_holdings: [[String: String]] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .center) {
                    HStack {
                        VStack {
                            Button(action: { show_profile_image_picker.toggle() }) {
                                if let image = profile_image {
                                    // Fetching the profile image
                                    ZStack {
                                        Image(uiImage: image)
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
                                    // Displaying a static icon if no profile image uploaded
                                    ZStack {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                        
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button(action: { show_profile_image_picker.toggle() }) {
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
                            
                            // Logic for handling upload of new images
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
                        .padding(.leading, -10)
                        
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
                            Text("Verification Status")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            
                            if verification_completed == true {
                                Text("Completed")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                                    .foregroundColor(Color("Profit"))
                            } else {
                                Text("Incomplete")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                                    .foregroundColor(Color("Loss"))
                            }
                        }
                        .padding(.horizontal).padding(.top, 10)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                            .frame(height: 1)
                        
                        // Button to check a user's transaction history
                        HStack {
                            Text("Transaction History")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Button(action: {
                                self.sorted_user_holdings = sort_array_by_date(inputArray: user_holdings + user_holdings_sold, field_name: "transaction_date", date_type: "dd/MM/yyyy")
                                transaction_history_shown.toggle()
                            }) {
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
                            Text("Balance")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Text("£\(formatted_number(input_number: payouts_value+secondary_transactions_value))")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                                .foregroundColor(.black)
                                .padding(.trailing, 13)
                        }
                        .padding(.horizontal).padding(.top, 10)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                            .frame(height: 1)
                        
                        // Button to show the platform's Data Privacy laws
                        HStack {
                            Text("Data Privacy")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Button(action: {  UIApplication.shared.open(URL(string: "https://docs.google.com/document/d/1oWR6Uc1m2JdHRmBzIMflfTg4N7gzNmzGyhujgn1c9wo/edit?usp=sharing")!) }) {
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
                        
                    }
                    .padding(.top)
                    .foregroundColor(Color("Custom_Gray"))
                    
                    HStack {
                        Button(action: { showing_log_out.toggle() }) {
                            HStack {
                                Text("Log out")
                                    .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                    .fontWeight(.bold)
                            }
                            .frame(width: geometry.size.width*0.4, height: 45)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                        }
                        
                        // Button to initiate withdrawal procedure
                        Button(action: { withdraw_request.toggle() }) {
                            HStack {
                                Text("Withdraw")
                                    .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                    .fontWeight(.bold)
                            }
                            .frame(width: geometry.size.width*0.4, height: 45)
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
            .sheet(isPresented: $transaction_history_shown) {
                UserTransactionHistory(user_holdings: $sorted_user_holdings)
            }
            // Confirmation window for logout
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
            // Confirmation window for withdrawal
            .alert(isPresented: $withdraw_request) {
                Alert(
                    title: Text("Are you sure you want to withdraw?"),
                    primaryButton: .default(Text("Yes")) {
                        DispatchQueue.global(qos: .userInteractive).async {
                            CreateDB().create_withdrawal_confirmation(email: email, amount: formatted_number(input_number: payouts_value+secondary_transactions_value))
                        }
                        withdraw_request_confirmed.toggle()
                    },
                    secondaryButton: .destructive(Text("No")) {}
                )
            }
            .navigationDestination(isPresented: $logged_out) {
                LandingContent(is_shown_home_page: $is_shown_home_page).navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $withdraw_request_confirmed) {
                UserHome(is_investment_confirmed: $is_investment_confirmed, is_withdrawal_confirmed: $is_withdrawal_confirmed, is_shown_home_page: $is_shown_home_page).navigationBarBackButtonHidden(true)
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
