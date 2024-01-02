//
//  UserMarketplaceClick.swift
//  PARC
//
//  Created by Ayman Ali on 22/10/2023.
//

import SwiftUI

struct UserMarketplaceClick: View {
    @State var investment_titles = ["Industry", "Number of franchises", "Franchise Revenue (monthly)", "Estimated EBITDA"]
    @State var investment_values = ["Food & Beverage", "50", "50,000", "42"]
    @State var share_prices = ["£400", "£560", "£230", "£120"]
    @State var no_of_shares = ["0.05", "1.2", "0.89", "0.9"]
    @State var total_values = ["£850", "£15,000", "£68,000", "£23,000"]
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
                                .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            
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
                                
                                Button(action: {}) {
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
                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
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
            
        }
    }
}

#Preview {
    UserMarketplaceClick(title: .constant("McDonald's"), logo: .constant("McDonalds"), shares_data: .constant([["opportunity_id": "2", "amount": "125000", "user_email": "ayman.ali1302@gmail.com", "equity": "0.567", "transaction_date": "2024-01-01 11:50:23  0000", "status": "Listed", "opportunity_name": "McDonald’s", "user_holdings_id": "1"], ["transaction_date": "2024-01-01 11:50:37  0000", "equity": "0.023", "user_email": "ayman.ali1302@gmail.com", "amount": "400", "opportunity_id": "2", "user_holdings_id": "2", "opportunity_name": "McDonald’s", "status": "Listed"]]))
}
