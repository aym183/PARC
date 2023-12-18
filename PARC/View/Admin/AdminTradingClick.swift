//
//  AdminTradingClick.swift
//  PARC
//
//  Created by Ayman Ali on 29/10/2023.
//

import SwiftUI

struct AdminTradingClick: View {
    var data_titles = ["Trading Volume", "Trades", "Scheduled Date", "Duration", "Most Traded Opportunity", "Biggest Trade"]
    var data_values = ["£178,000,000", "Check", "21/03/2023", "15/04/2023", "McDonald's, 25", "McDonald's - £1.5M"]
    @Binding var selected_trading_window: [String: String]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Text("500 Trades")
                            .font(Font.custom("Nunito-ExtraBold", size: 50))
                        
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
                        //                    .padding(.top)
                        
                        
                        HStack {
                            Text("Trading Window Details")
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
                                
                                if data_values[index] == "Check" {
                                    Button(action: {}) {
                                        HStack {
                                            Text("Check")
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.038))
                                        }
                                        .frame(width: max(0, geometry.size.width-300), height: 35)
                                        .background(Color("Secondary"))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(5)
                                    }
                                } else if data_titles[index] == "Scheduled Date" {
                                    Text(convertDate(dateString: selected_trading_window["start_date"]!))
                                } else if data_titles[index] == "Duration" {
                                    Text("\(String(describing: selected_trading_window["duration"]!)) days")
                                } else {
                                    Text(data_values[index])
                                }
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
                    .padding(.top)
                }
            }
            .onAppear() {
                print(selected_trading_window)
            }
        }
    }
}

//#Preview {
//    AdminTradingClick()
//}
