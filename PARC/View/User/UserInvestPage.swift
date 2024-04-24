//
//  UserInvestPage.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

// When a user is ready to invest, they get navigated to this view to confirm their investment
struct UserInvestPage: View {
    
    @State var investment_amount = ""
    @AppStorage("net_worth") var net_worth: String = ""
    @State var net_worth_int: Int = 0
    @State var investment_limit = 0
    @State var is_investment_amount_valid: Bool = false
    @State var is_shares_listed = false
    @State var home_page_shown = false
    @State var is_investment_confirmed = true
    @State var user_ready_to_invest = false
    @State var is_shown_home_page = false
    @State var is_withdrawal_confirmed = false
    @Binding var user_invest_shown: Bool
    @Binding var asking_price: Double
    @Binding var equity_offered: Double
    @Binding var opportunity_id: String
    @Binding var opportunity_name: String
    @Binding var amount_offered: String
    @Binding var investors: String
    @Binding var min_investment: String
    @State var equity_value = 0.0
    @State var updated_amount_offered = 0
    @State var showing_payment_alert = false
    @AppStorage("email") var email: String = ""
    @AppStorage("verification_completed") var verification_completed: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        
                        // Verifying that the user has completed onboarding. If not, they can't invest
                        if net_worth_int == 0 || verification_completed == false {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("❌").font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.3))
                                    .padding(.bottom, -20)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Text("We need your onboarding details to continue").font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            Spacer()
                        } else {
                            Text("Invest")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("£\(investment_limit)")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                                        .padding(.bottom, -5)
                                    
                                    Text("Your investment limit")
                                        .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                        .foregroundColor(Color("Custom_Gray"))
                                        .padding(.top, -5)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("£\(formatted_number(input_number: Int(min_investment)!))")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                                        .padding(.bottom, -5)
                                    
                                    Text("Min investment")
                                        .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                        .foregroundColor(Color("Custom_Gray"))
                                        .padding(.top, -5)
                                }
                                .padding(.leading, 30)
                            }
                            .padding(.bottom, 5).padding(.top, 10)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color("Custom_Gray"))
                                .opacity(0.5)
                                .padding(.top, 2.5).padding(.bottom, -5)
                            
                            // Restrictions for the user if verified but cannot invest due to lack of income
                            if investment_limit > 0 {
                                Text("Investment Amount (£)").font(Font.custom("Nunito-Bold", size: 18))
                                    .padding(.top).padding(.bottom, -2.5)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 1.25)
                                        )
                                        .frame(width: max(0, geometry.size.width - 40), height: 50)
                                        .opacity(0.5)
                                    
                                    TextField("", text: $investment_amount, prompt: Text("500").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                        .foregroundColor(.black)
                                        .autocorrectionDisabled(true)
                                        .autocapitalization(.none)
                                        .cornerRadius(5)
                                        .font(Font.custom("Nunito-Bold", size: 16))
                                        .onChange(of: investment_amount) {
                                            withAnimation(.easeOut(duration: 0.2)) {
                                                validateInvestmentAmount()
                                            }
                                        }
                                        .keyboardType(.numberPad)
                                }
                            }
                            
                            if !is_investment_amount_valid && investment_amount != "" {
                                HStack {
                                    Spacer()
                                    Text("Invalid Amount").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                                }
                            } else if is_investment_amount_valid && investment_amount != "" {
                                HStack {
                                    Spacer()
                                    Text("\(String(format: "%.3f", (Double(investment_amount)!/equity_value)*100))% of equity").font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                                }
                            }
                            
                            Spacer()
                            Button(action: { showing_payment_alert.toggle() }) {
                                HStack {
                                    Text("Confirm Investment")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                                }
                                .frame(width: max(0, geometry.size.width-40), height: 55)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                                .padding(.bottom)
                            }
                            .sensoryFeedback(.success, trigger: showing_payment_alert)
                            .disabled(is_investment_amount_valid ? false : true)
                            .opacity(is_investment_amount_valid ? 1 : 0.75)
                        }
                    }
                    .frame(height: max(0, geometry.size.height - 20))
                    .padding(.horizontal, 5)
                    
                }
                .padding(.top, 10)
                .foregroundColor(.black)
                .frame(width: max(0, geometry.size.width - 40))
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationDestination(isPresented: $home_page_shown) {
                UserHome(is_investment_confirmed: $is_investment_confirmed, is_withdrawal_confirmed: $is_withdrawal_confirmed, is_shown_home_page: $is_shown_home_page).navigationBarBackButtonHidden(true)
            }
            .onAppear {
                if let netWorthInt = Int(net_worth) {
                    // Conversion succeeded, netWorthInt contains the integer value
                    net_worth_int = netWorthInt
                } else {
                    net_worth_int = 0
                }
                calculateInvestmentLimit()
                withAnimation(.easeOut(duration: 0.2)) {
                    user_ready_to_invest = true
                }
                equity_value = (asking_price*100)/(equity_offered)
            }
            // Before a user invests, a confirmation popup gets shown to confirm investment
            .alert(isPresented: $showing_payment_alert) {
                Alert(
                    title: Text("Are you sure you want to buy this?"),
                    primaryButton: .default(Text("Yes")) {
                        updated_amount_offered = Int(amount_offered)! + Int(investment_amount)!
                        DispatchQueue.global(qos: .userInteractive).async {
                            UpdateDB().update_table(primary_key: "opportunity_id", primary_key_value: opportunity_id, table: "opportunities", updated_key: "amount_raised", updated_value: String(describing: updated_amount_offered)) { response in
                                
                                if response == "opportunities amount_raised updated" {
                                    UpdateDB().update_table(primary_key: "opportunity_id", primary_key_value: opportunity_id, table: "opportunities", updated_key: "investors", updated_value: investors) { second_response in
                                        
                                        if second_response == "opportunities investors updated" {
                                            home_page_shown.toggle()
                                            
                                            CreateDB().create_user_investment_holding(opportunity_name: opportunity_name, opportunity_id: opportunity_id, email: email, equity: String(format: "%.3f", (Double(investment_amount)!/equity_value)*100), amount: investment_amount)
                                            
                                            CreateDB().create_opportunity_transaction(opportunity_id: opportunity_id, email: email, amount: investment_amount)
                                            
                                            CreateDB().create_investment_confirmation(email: email, amount: investment_amount, opportunity_name: opportunity_name, type: "buyer")
                                        }
                                    }
                                }
                                
                            }
                        }
                    },
                    secondaryButton: .destructive(Text("No")) {
                    }
                )
            }
        }
    }
    
    
    
    // Valides whether the inputted amount by the user is within the limits set
    private func validateInvestmentAmount() {
        if investment_amount != "" && (Int(investment_amount)! >= Int(min_investment)! && Int(investment_amount)! <= investment_limit) {
            is_investment_amount_valid = true
        } else {
            is_investment_amount_valid = false
        }
    }
    
    
    //  Calculates how much the user is allowed to invest
    private func calculateInvestmentLimit() {
        investment_limit = 10*(net_worth_int/100)
    }
}
