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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack {
                    HStack(spacing: 20) {
                        Image(opportunity_logo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                        
                        Text(opportunity_title)
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
                    
                    ForEach(0..<data_titles.count, id: \.self) {index in
                        HStack {
                            Text(data_titles[index])
                                .foregroundColor(.gray)
                            Spacer()
                            Text(data_values[index])
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        if index < data_titles.count - 1 {
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
                .padding(.top, 10)
            }
        }
    }
}

//#Preview {
//    AdminOpportunityClick()
//}
