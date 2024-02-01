//
//  UserListShares.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

struct UserListShares: View {
    @Binding var franchise_data: [DropdownMenuOption]
    @Binding var holding_data: [DropdownMenuOption]
    @State var franchise = ""
    @State var no_of_shares = ""
    @State var asking_price = ""
    @State var is_on = false
    @Binding var marketplace_shown: Bool
    @State var isInvestmentConfirmed = false
    @State var isSharesListed = true
    @State var isShownHomePage = false
    @State var isWithdrawalConfirmed = false
    @State private var selectedFranchise: DropdownMenuOption? = nil
    @State private var selectedHolding: DropdownMenuOption? = nil
    var validFormInputs: Bool { selectedHolding != nil && asking_price.count>0 && is_on }
    @State var isValidInput = true
    
    //Refactor this view to show for loop components as compared to replicating
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
                        
                        DropdownMenu(selectedOption: self.$selectedHolding, placeholder: "Select", options: holding_data)
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
                                            if Int(self.asking_price)! == 0 { isValidInput = false }
                                        } else { isValidInput = true }
                                    }
                                })
                        }
                        
                        if !isValidInput {
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
                            let components = selectedHolding!.option.components(separatedBy: "-")
                            if let userHoldingID = Int((components.first?.trimmingCharacters(in: .whitespaces))!) {
                                DispatchQueue.global(qos: .userInteractive).async {
                                    UpdateDB().updateTable(primary_key: "user_holdings_id", primary_key_value: String(describing: userHoldingID), table: "user-holdings", updated_key: "status", updated_value: "Listed") { response in
                                        if response == "user-holdings status updated" {
                                            
                                            UpdateDB().updateTable(primary_key: "user_holdings_id", primary_key_value: String(describing: userHoldingID), table: "user-holdings", updated_key: "amount", updated_value: asking_price) { response in
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
                        .disabled(validFormInputs ? false : true)
                        .opacity(validFormInputs ? 1 : 0.75)
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
                UserHome(isInvestmentConfirmed: $isInvestmentConfirmed, isWithdrawalConfirmed: $isWithdrawalConfirmed, isShownHomePage: $isShownHomePage).navigationBarBackButtonHidden(true)
            }
        }
    }
}
