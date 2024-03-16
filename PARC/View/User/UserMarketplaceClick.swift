//
//  UserMarketplaceClick.swift
//  PARC
//
//  Created by Ayman Ali on 22/10/2023.
//

import SwiftUI

// Content shown when a user clicks on a listed franchise on the secondary market page
struct UserMarketplaceClick: View {
    @State var investment_titles = ["Industry", "Number of franchises", "Franchise Revenue (monthly)", "Estimated EBITDA Margin"]
    @State var investment_values = ["Food & Beverage", "50", "£50,000", "42"]
    @State var share_prices = ["£400", "£560", "£230", "£120"]
    @State var showingPaymentAlert = false
    @State var home_page_shown = false
    @State var isInvestmentConfirmed = true
    @State var isWithdrawalConfirmed = false
    @State var isShownHomePage = false
    @State var isSharesListed = false
    @AppStorage("trading_window_id") var trading_window_id: String = ""
    @AppStorage("email") var email: String = ""
    @State var selling_email = ""
    @State var equity = ""
    @State var amount = ""
    @State var opportunity_id = ""
    @State var opportunity_name = ""
    @State var user_holding_id = ""
    @Binding var title: String
    @Binding var logo: String
    @Binding var shares_data: [[String: String]]
    @Binding var franchise_selected: [String: String]
    @Binding var opportunity_data: [[String: String]]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(uiImage: loadFranchiseLogo(key: franchise_selected["logo"]!))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                            
                            Text(title)
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            
                            Spacer()
                        }
                        
                        Text("Franchise Overview")
                            .font(Font.custom("Nunito-Bold", size: 25))
                            .padding(.bottom, -5).padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                            .padding(.bottom, 10)
                        
                        ForEach(0..<investment_titles.count, id: \.self) { index in
                            HStack {
                                Text(investment_titles[index])
                                    .foregroundColor(Color("Custom_Gray"))
                                Spacer()
                                
                                if investment_titles[index] == "Industry" {
                                    Text(franchise_selected["industry"]!)
                                        .font(Font.custom("Nunito-SemiBold", size: 14))
                                } else if investment_titles[index] == "Number of franchises" {
                                    Text(franchise_selected["no_of_franchises"]!)
                                        .font(Font.custom("Nunito-SemiBold", size: 14))
                                } else if investment_titles[index] == "Franchise Revenue (monthly)" {
                                    Text("£\(formattedNumber(input_number: Int(franchise_selected["avg_franchise_mom_revenues"]!)!))")
                                        .font(Font.custom("Nunito-SemiBold", size: 14))
                                } else if investment_titles[index] == "Estimated EBITDA Margin" {
                                    Text("\(franchise_selected["ebitda_estimate"]!)%")
                                        .font(Font.custom("Nunito-SemiBold", size: 14))
                                }
                                
                            }
                            .font(Font.custom("Nunito-SemiBold", size: 14))
                            
                            if index != investment_titles.count-1 {
                                Divider()
                                    .overlay(.gray)
                                    .frame(height: 1)
                                    .opacity(0.5)
                            }
                        }
                        .padding(.vertical, 5)
                        
                        Text("Available Shares")
                            .font(Font.custom("Nunito-Bold", size: 25))
                            .padding(.bottom, -5).padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                        
                        HStack(spacing: 25) {
                            Text("Bought\nPrice")
                            Text("Equity")
                            Text("Listed\nPrice")
                            Text("Location")
                            
                        }
                        .padding(.vertical, 7.5)
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.032))
                        .multilineTextAlignment(.center)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
                            .padding(.top, -5)
                        
                        if shares_data.count != 0 && opportunity_data.count != 0 {
                            ForEach(0..<shares_data.count, id: \.self) { index in
                                HStack(spacing: 20) {
                                    HStack {
                                        Text(share_prices[index])
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width*0.15)
                                    
                                    HStack {
                                        Text(String(format: "%.2f", Float(shares_data[index]["equity"]!)!))
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width*0.15)
                                    .padding(.leading, -5)
                                    
                                    HStack {
                                        Text("£\(formattedNumber(input_number: Int(shares_data[index]["amount"]!)!))")
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width*0.2)
                                    .padding(.leading, -20)
                                    
                                    
                                    HStack {
                                        Text(opportunity_data[opportunity_data.firstIndex(where: { $0["opportunity_id"] == shares_data[index]["opportunity_id"]!})!]["location"]!)
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width*0.15)
                                    .padding(.leading, -25)
                                    
                                    Button(action: {
                                        selling_email = shares_data[index]["user_email"]!
                                        equity = shares_data[index]["equity"]!
                                        amount = shares_data[index]["amount"]!
                                        opportunity_id = shares_data[index]["opportunity_id"]!
                                        opportunity_name = shares_data[index]["opportunity_name"]!
                                        user_holding_id = shares_data[index]["user_holdings_id"]!
                                        showingPaymentAlert.toggle()
                                    }) {
                                        HStack {
                                            Text("Buy")
                                                .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.0325))
                                        }
                                        .frame(width: geometry.size.width*0.2, height: 40)
                                        .background(Color("Secondary"))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(5)
                                    }
                                    
                                }
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.0325))
                                .padding(.vertical, 5)
                                .multilineTextAlignment(.center)
                                
                                Divider()
                                    .overlay(Color("Custom_Gray"))
                                    .opacity(0.5)
                                    .frame(height: 1)
                            }
                            
                        } else {
                            Text("☹️")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.3))
                                .padding(.bottom, -20)
                            
                            Text("No shares available yet")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                        }
                        
                    }
                    .foregroundColor(.black)
                }
                .frame(width: max(0, geometry.size.width - 40))
                .padding(.top,10)
            }
            .navigationDestination(isPresented: $home_page_shown) {
                UserHome(isInvestmentConfirmed: $isInvestmentConfirmed, isWithdrawalConfirmed: $isWithdrawalConfirmed, isShownHomePage: $isShownHomePage).navigationBarBackButtonHidden(true)
            }
            .alert(isPresented: $showingPaymentAlert) {
                Alert(
                    title: Text("Are you sure you want to buy this?"),
                    primaryButton: .default(Text("Yes")) {
                        
                        DispatchQueue.global(qos: .userInteractive).async {
                            CreateDB().createSecondaryMarketTransaction(opportunity_id: opportunity_id, trading_window_id: trading_window_id, price: amount, equity: equity, user_buying: email, user_selling: selling_email) { response in
                                if response == "Transactions Secondary Market Created" {
                                    UpdateDB().updateTable(primary_key: "user_holdings_id", primary_key_value: user_holding_id, table: "user-holdings", updated_key: "status", updated_value: "Sold") { response in
                                        if response == "user-holdings status updated" {
                                            home_page_shown.toggle()
                                            CreateDB().createUserInvestmentHolding(opportunity_name: opportunity_name, opportunity_id: opportunity_id, email: email, equity: equity, amount: amount)
                                        }
                                    }
                                }
                            }
                            CreateDB().createInvestmentConfirmation(email: email, amount: amount, opportunity_name: opportunity_name, type: "buyer")
                            CreateDB().createInvestmentConfirmation(email: selling_email, amount: amount, opportunity_name: opportunity_name, type: "seller")
                        }
                    },
                    secondaryButton: .destructive(Text("No")) {
                    }
                )
            }
            
        }
    }
}
