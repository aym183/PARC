//
//  UserTransactionHistory.swift
//  PARC
//
//  Created by Ayman Ali on 01/02/2024.
//

import SwiftUI

// Transaction history of investments and sales available to users in their account page
struct UserTransactionHistory: View {
    @Binding var user_holdings: [[String: String]]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if user_holdings.count == 0 {
                            Spacer()
                            Text("☹️")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.3))
                                .padding(.bottom, -20)
                                .padding(.top, 50)
                            Text("No transactions")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            
                            Spacer()
                        } else {
                            ForEach(0..<user_holdings.count, id: \.self) { index in
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            
                                            if user_holdings[index]["status"]! == "Owned" {
                                                Text("Bought \(user_holdings[index]["opportunity_name"]!)")
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                            } else {
                                                Text("Sold \(user_holdings[index]["opportunity_name"]!)")
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                            }
                                            
                                        }
                                        Text("Date Bought - \(user_holdings[index]["transaction_date"]!)")
                                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.027))
                                            .foregroundColor(Color("Custom_Gray"))
                                    }
                                    Spacer()
                                    
                                    if user_holdings[index]["status"]! == "Owned" {
                                        Text("+£\(formatted_number(input_number: Int(user_holdings[index]["amount"]!)!))")
                                            .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                            .foregroundColor(Color("Profit"))
                                    } else {
                                        Text("-£\(formatted_number(input_number: Int(user_holdings[index]["amount"]!)!))")
                                            .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                            .foregroundColor(Color("Loss"))
                                    }
                                }
                                .padding(.vertical, 10)
                                .frame(width: max(0, geometry.size.width-40))
                                
                                Divider()
                                    .overlay(Color("Custom_Gray"))
                                    .frame(height: 0.5)
                            }
                        }
                    }
                    .foregroundColor(.black)
                    .padding(.top, 10)
                }
            }
        }
    }
}
