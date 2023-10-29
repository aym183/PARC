//
//  AdminPayoutClick.swift
//  PARC
//
//  Created by Ayman Ali on 29/10/2023.
//

import SwiftUI

struct AdminPayoutClick: View {
    var payout_data_titles = ["Investors", "Revenue Generated (past month)", "% of Revenue", "Payout Date"]
    var payout_data_values = ["500", "£750,000", "6.66%", "15/04/2023", "15/06/2023"]
    var opportunity_data_titles = ["Opportunity ID", "Opportunity Name", "Location", "Share Price"]
    var opportunity_data_values = ["24", "McDonald's", "Stratford, London", "£38.42"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Text("+£50,000")
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
                        
                        ForEach(0..<payout_data_titles.count, id: \.self) {index in
                            HStack {
                                Text(payout_data_titles[index])
                                    .foregroundColor(.gray)
                                Spacer()
                                
                                Text(payout_data_values[index])
                            }
                            .font(Font.custom("Nunito-Medium", size: 14))
                            .padding(.vertical, 6)
                            
                            if index < payout_data_titles.count - 1 {
                                Divider()
                                    .overlay(.gray)
                                    .frame(height: 1)
                                    .opacity(0.5)
                            }
                        }
                        
                        
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
                                
                                Text(opportunity_data_values[index])
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

#Preview {
    AdminPayoutClick()
}
