//
//  AdminOpportunity Click.swift
//  PARC
//
//  Created by Ayman Ali on 29/10/2023.
//

import SwiftUI

struct AdminOpportunityClick: View {
    var data_titles = ["Opportunity ID", "Location", "Type", "Money Raised", "Target Raised", "Investors", "Minimum Investment", "Investment Deadline"]
    var data_values = ["24", "Stratford, London", "Equity", "£400,000", "£1,000,000", "500", "£100", "18/08/2023"]
    @Binding var opportunity_logo: String
    @Binding var opportunity_title: String
    @Binding var opportunity_data: [String:String]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack(spacing: 20) {
                            Image(opportunity_logo)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                            
                            Text(String(describing: opportunity_data["franchise"]!))
                                .font(Font.custom("Nunito-Bold", size: 30))
                        }
                        
                        HStack(spacing: 20) {
                            Button(action: {}) {
                                HStack {
                                    Text("Edit Opportunity")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.038))
                                }
                                .frame(width: max(0, geometry.size.width-240), height: 45)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                                .padding(.bottom)
                            }
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                            
                            Button(action: {}) {
                                HStack {
                                    Text("Close Opportunity")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.038))
                                }
                                .frame(width: max(0, geometry.size.width-240), height: 45)
                                .background(Color("Loss"))
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                                .padding(.bottom)
                            }
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                        }
                        .padding(.top)
                        
                        HStack {
                            Text("Opportunity Details")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                                .padding(.bottom, -5)
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                            .padding(.bottom, 5)
                        
                        HStack {
                            Text("Opportunity ID")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(describing: opportunity_data["opportunity_id"]!))
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)

                        HStack {
                            Text("Location")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(describing: opportunity_data["location"]!))
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Type")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Equity")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Money Raised")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("£\(formattedNumber(input_number: Int(opportunity_data["amount_raised"]!)!))")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        // change to comma for large no.s
                        HStack {
                            Text("Target Raised")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("£\(formattedNumber(input_number: Int(opportunity_data["asking_price"]!)!))")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Investors")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(String(describing: opportunity_data["investors"]!))")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Minimum Investment")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("£\(formattedNumber(input_number: Int(opportunity_data["min_invest_amount"]!)!))")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Investment Deadline")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(describing: opportunity_data["close_date"]!))
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        
                        Spacer()
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                    .foregroundColor(.black)
                    .padding(.top)
                }
            }
        }
    }
}

//#Preview {
//    AdminOpportunityClick(opportunity_logo: .constant("McDonalds"), opportunity_title: .constant("McDonalds"))
//}
