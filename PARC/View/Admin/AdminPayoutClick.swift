//
//  AdminPayoutClick.swift
//  PARC
//
//  Created by Ayman Ali on 29/10/2023.
//

import SwiftUI

struct AdminPayoutClick: View {
    var payout_data_titles = ["Investors", "Revenue Generated (past month)", "% of Revenue", "Payout Date"]
    var payout_data_values = ["investors", "revenue_generated", "percentage_of_revenue", "date_scheduled"]
    var opportunity_data_titles = ["Opportunity ID", "Opportunity Name", "Location"]
    var opportunity_data_values = ["opportunity_id", "franchise", "location"]
    @Binding var opportunity_data: [String:String]
    @Binding var payout_data: [String:String]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Text("+£\(String(describing:   formattedNumber(input_number: Int(payout_data["amount_offered"]!)!)))")
                            .font(Font.custom("Nunito-ExtraBold", size: 50))
                            .foregroundColor(Color("Profit"))
                        
                        HStack(spacing: 20) {
                            Button(action: {}) {
                                HStack {
                                    Text("Edit Payout")
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
                                    Text("Close Payout")
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
                        //                    .padding(.top)
                        
                        
                        HStack {
                            Text("Payout Details")
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
                            Text("Investors")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            Text(opportunity_data["investors"]!)
                           
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Revenue Generated (past month)")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            Text("£\(formattedNumber(input_number: Int(payout_data["revenue_generated"]!)!))")
                           
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("% of revenue paid out")
                                .foregroundColor(.gray)
                            Spacer()
                            
                            Text("\(payout_data["percentage_of_revenue"]!)")
                           
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Payout Date")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(describing: convertDate(dateString:payout_data["date_scheduled"]!)))
                           
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
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
                        
                        ForEach(0..<opportunity_data_titles.count, id: \.self) {index in
                            HStack {
                                Text(opportunity_data_titles[index])
                                    .foregroundColor(.gray)
                                Spacer()
                                
                                Text(opportunity_data[opportunity_data_values[index]]!)
                            }
                            .font(Font.custom("Nunito-Medium", size: 14))
                            .padding(.vertical, 6)
                            
                            if index < opportunity_data_titles.count - 1 {
                                Divider()
                                    .overlay(.gray)
                                    .frame(height: 1)
                                    .opacity(0.5)
                            }
                        }
                        
                        
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
//
//#Preview {
//    AdminPayoutClick()
//}
