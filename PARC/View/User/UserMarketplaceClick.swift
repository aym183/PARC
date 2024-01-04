//
//  UserMarketplaceClick.swift
//  PARC
//
//  Created by Ayman Ali on 22/10/2023.
//

import SwiftUI

struct UserMarketplaceClick: View {
    @State var investment_titles = ["Industry", "Number of franchises", "Franchise Revenue (monthly)", "Estimated EBITDA"]
    @State var investment_values = ["Food & Beverage", "50", "£50,000", "42"]
    @State var share_prices = ["£400", "£560", "£230", "£120"]
    @State var showingPaymentAlert = false
    @State var home_page_shown = false
    @State var isInvestmentConfirmed = true
    @State var isShownHomePage = false
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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(logo)
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
                        
                        ForEach(0..<investment_titles.count, id: \.self) {index in
                            HStack {
                                Text(investment_titles[index])
                                    .foregroundColor(Color("Custom_Gray"))
                                Spacer()
                                Text(investment_values[index])
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
                        
                        HStack(spacing: 20) {
                            Text("Share Price")
                            Text("Equity")
                            Text("Total Value")
                        }
                        .padding(.vertical, 7.5)
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.029))
                        
                        ForEach(0..<shares_data.count, id: \.self) { index in
                            HStack(spacing: 30) {
                                HStack {
                                    Text(share_prices[index])
                                    Spacer()
                                }
                                .frame(width: 50)
                                
                                HStack {
                                    Text(String(format: "%.2f", Float(shares_data[index]["equity"]!)!))
                                    Spacer()
                                }
                                .frame(width: 55)
                                
                                HStack {
                                    Text("£\(formattedNumber(input_number: Int(shares_data[index]["amount"]!)!))")
                                    Spacer()
                                }
                                .frame(width: 80)
                                .padding(.leading, -20)
                                
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
                                            .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                    }
                                    .frame(width: max(0, geometry.size.width-300), height: 40)
                                    .background(Color("Secondary"))
                                    .foregroundColor(Color.white)
                                    .cornerRadius(5)
                                }

                            }
                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.035))
                            .padding(.vertical, 5)
                            
                            Divider()
                                .overlay(.gray)
                                .frame(height: 1)
                                .opacity(0.5)
                        }
                    }
                    .foregroundColor(.black)
                }
                .frame(width: max(0, geometry.size.width - 40))
                .padding(.top,10)
            }
            .navigationDestination(isPresented: $home_page_shown) {
                UserHome(isInvestmentConfirmed: $isInvestmentConfirmed, isShownHomePage: $isShownHomePage).navigationBarBackButtonHidden(true)
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
                            CreateDB().createInvestmentConfirmation(email: email, amount: amount, opportunity_name: opportunity_name)
                        }
                    },
                    secondaryButton: .destructive(Text("No")) {
                        print("Delete")
                    }
                )
            }
            
        }
    }
}

#Preview {
    UserMarketplaceClick(title: .constant("McDonald's"), logo: .constant("McDonalds"), shares_data: .constant([["opportunity_id": "2", "amount": "125000", "user_email": "ayman.ali1302@gmail.com", "equity": "0.567", "transaction_date": "2024-01-01 11:50:23  0000", "status": "Listed", "opportunity_name": "McDonald’s", "user_holdings_id": "1"], ["transaction_date": "2024-01-01 11:50:37  0000", "equity": "0.023", "user_email": "ayman.ali1302@gmail.com", "amount": "400", "opportunity_id": "2", "user_holdings_id": "2", "opportunity_name": "McDonald’s", "status": "Listed"]]))
}
