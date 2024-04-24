//
//  UserListShares.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

// This is the form where users list shares they want to sell on the secondary market page
struct UserListShares: View {
    @Binding var franchise_data: [DropdownMenuOption]
    @Binding var holding_data: [DropdownMenuOption]
    @State var franchise = ""
    @State var no_of_shares = ""
    @State var asking_price = ""
    @State var is_on = false
    @Binding var marketplace_shown: Bool
    @State var is_investment_confirmed = false
    @State var is_shares_listed = true
    @State var is_shown_home_page = false
    @State var is_withdrawal_confirmed = false
    @State private var selected_franchise: DropdownMenuOption? = nil
    @State private var selected_holding: DropdownMenuOption? = nil
    var valid_form_inputs: Bool { selected_holding != nil && asking_price.count>0 && is_on }
    @State var is_valid_input = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        
                        Text("List Shares")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            .padding(.bottom, -5)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                        
                        Text("Holding").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top).padding(.bottom, -5)
                        
                        // The dropdown that shows users all their owned shares
                        DropdownMenu(selected_option: self.$selected_holding, placeholder: "Select", options: holding_data)
                            .frame(width: max(0, geometry.size.width - 40), height: 50)
                            .padding(.top, 0.5)
                        
                        Text("Asking Price (£)").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5)
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 40), height: 50)
                            
                            TextField("", text: $asking_price, prompt: Text("1250000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                                .onChange(of: self.asking_price, perform: { value in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        if self.asking_price.count > 0 {
                                            if Int(self.asking_price)! == 0 { is_valid_input = false }
                                        } else { is_valid_input = true }
                                    }
                                })
                        }
                        
                        // Error checking to validate amount entered
                        if !is_valid_input {
                            HStack {
                                Spacer()
                                Text("Amount should be greater than 0").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                            }
                        }
                        
                        
                        HStack {
                            Toggle(isOn: $is_on) {
                                HStack(spacing: 5) {
                                    Text("I agree to the")
                                    Text("terms and conditions")
                                        .foregroundColor(Color.blue)
                                        .underline()
                                }
                            }
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.035))
                            .padding(.top, 5)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            let components = selected_holding!.option.components(separatedBy: "-")
                            if let userHoldingID = Int((components.first?.trimmingCharacters(in: .whitespaces))!) {
                                DispatchQueue.global(qos: .userInteractive).async {
                                    UpdateDB().update_table(primary_key: "user_holdings_id", primary_key_value: String(describing: userHoldingID), table: "user-holdings", updated_key: "status", updated_value: "Listed") { response in
                                        if response == "user-holdings status updated" {
                                            
                                            UpdateDB().update_table(primary_key: "user_holdings_id", primary_key_value: String(describing: userHoldingID), table: "user-holdings", updated_key: "amount", updated_value: asking_price) { response in
                                                if response == "user-holdings amount updated" {
                                                    marketplace_shown.toggle()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Text("Submit Listing")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                            }
                            .frame(width: max(0, geometry.size.width-40), height: 55)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                            .padding(.bottom)
                        }
                        .disabled(valid_form_inputs ? false : true)
                        .opacity(valid_form_inputs ? 1 : 0.75)
                    }
                    .frame(width: max(0, geometry.size.width - 40), height: max(0, geometry.size.height))
                    .padding(10)
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .foregroundColor(.black)
            .navigationDestination(isPresented: $marketplace_shown) {
                UserHome(is_investment_confirmed: $is_investment_confirmed, is_withdrawal_confirmed: $is_withdrawal_confirmed, is_shown_home_page: $is_shown_home_page).navigationBarBackButtonHidden(true)
            }
        }
    }
}
