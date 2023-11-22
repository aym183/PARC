//
//  UserOpportunity.swift
//  PARC
//
//  Created by Ayman Ali on 20/10/2023.
//

import SwiftUI

//struct RoundedRectanglesGrid: View {
//    var body: some View {
//        VStack {
//            HStack {
//                RoundedRectangleView()
//                RoundedRectangleView()
//            }
//            HStack {
//                RoundedRectangleView()
//                RoundedRectangleView()
//            }
//        }
//    }
//}

struct UserOpportunityClick: View {
//    @Binding var bg_image: String
//    @Binding var logo: String
//    @Binding var title: String
//    @Binding var progress: String
//    @Binding var min_investment_amount: String
//    @Binding var target_raise: String
    @Binding var opportunity_data: [String: String]
    @Binding var franchise_data: [[String: String]]
    @State var user_invest_shown = false
    @State var asking_price = 0.0
    @State var equity_offered = 0.0
    @State var opportunity_id = ""
    @State var amount_offered = ""
    @State var investors = ""
    @State var opportunity_name = ""
//    @State var investment_titles = ["Location", "Type", "Equity Offered", "", ""]
//    @State var investment_values = ["location", "Equity", "equity_offered", "", ""]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color(.white).ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    Image("store_live")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: max(0, geometry.size.width))
                        .padding(.top)
                    
                    VStack {
                        
                        HStack {
                            Image("McDonalds")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                            
                            Text(String(describing: opportunity_data["franchise"]!))
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                            
                            Spacer()
                        }
                        
                        Text(franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data["franchise"]! })!]["description"]!)
                            .frame(width: max(0, geometry.size.width - 40))
                            .foregroundColor(Color("Custom_Gray"))
                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.030))


                        
                        HStack {
                            Text("\(String(describing: Int(Double(opportunity_data["ratio"]!)!*100)))% - \(getDaysRemaining(dateString: String(describing: opportunity_data["close_date"]!))!) days left")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.024))
                                .foregroundColor(Color("Custom_Gray"))
                            Spacer()
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 45, height: 14)
                                    .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.5))
                                    .cornerRadius(5)
                                
                                HStack {
                                    Image("gbr").resizable().frame(width: 10, height: 10)
                                    Text(String(describing: opportunity_data["location"]!))
                                        .font(Font.custom("Nunito-Bold", size: 8))
                                        .foregroundColor(Color("Custom_Gray"))
                                        .padding(.leading, -7.5)
                                }
                            }
                        }
                        .padding(.top, -3)
                        
                        ProgressView(value: Double(opportunity_data["ratio"]!))
                            .tint(Color("Secondary"))
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .padding(.top, -1)
                        
//                        ZStack {
//                            Rectangle()
//                                .foregroundColor(.clear)
//                                .frame(width: max(0, geometry.size.width - 40), height: 8)
//                                .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6))
//                                .cornerRadius(100)
//                            
//                            HStack {
//                                Rectangle()
//                                    .foregroundColor(.clear)
//                                    .frame(width: max(0, geometry.size.width - 200), height: 8)
//                                    .background(Color("Secondary"))
//                                    .cornerRadius(100)
//                                
//                                Spacer()
//                            }
//                            .frame(width: max(0, geometry.size.width - 105))
//                            .padding(.leading, -65)
//                            
//                            
//                        }
//                        .padding(.top, -5)
                        
                        HStack {
                            Text("Minimum Investment Amount - £\(opportunity_data["min_invest_amount"]!)")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.024))
                                .foregroundColor(Color("Custom_Gray"))
                            
                            Spacer()
                            
                            Text("£\(String(describing: formattedNumber(input_number:Int(opportunity_data["asking_price"]!)!)))")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.024))
                                .foregroundColor(Color("Custom_Gray"))
                            
                        }
                        .padding(.top, -3)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
                            .padding(.top, 10)
                            .padding(.bottom, -5)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("£\(String(describing: formattedNumber(input_number:Int(opportunity_data["amount_raised"]!)!)))")
                                    .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.075))
                                Text("Invested")
                                    .foregroundColor(Color("Custom_Gray"))
                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("\(String(describing: opportunity_data["investors"]!))")
                                    .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.075))
                                Text("Investors")
                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.leading, 40)
                            
                            Spacer()
                        }
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
                            .padding(.top, 5)
                        
                        Button(action: {}) {
                            HStack {
                                Image("Presentation")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                
                                Text("Pitch Deck")
                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.042))
                                
                                Spacer()
                                
                                Image(systemName: "arrowshape.forward.fill")
                            }
                        }
                        .padding(.vertical, 10)
                        
                        HStack {
                            Text("Why Invest in Franchises?")
                            Spacer()
                        }
                        .padding(.top)
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                        
                        
                        Divider()
                            .overlay(.black)
                            .frame(height: 1)
                            .padding(.top, -15)
                        
                        ForEach(0..<2, id: \.self) {index in
                            HStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.gray)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.gray)
                                
                            }
                            .frame(height: 120)
                            .opacity(0.25)
                            
                        }
                        
                        
                        HStack {
                            Text("Similar Franchise Performance")
                            Spacer()
                        }
                        .padding(.top)
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                        
                        
                        Divider()
                            .overlay(.black)
                            .frame(height: 1)
                            .padding(.top, -15)
                        
                        ForEach(0..<2, id: \.self) {index in
                            HStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.gray)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.gray)
                                
                            }
                            .frame(height: 120)
                            .opacity(0.25)
                            
                        }
                        
                        HStack {
                            Text("Investment Overview")
                            Spacer()
                        }
                        .padding(.top)
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                        
                        
                        Divider()
                            .overlay(.black)
                            .frame(height: 1)
                            .padding(.top, -15)
                        
                       
                            HStack {
                                Text("Location")
                                    .foregroundColor(Color("Custom_Gray"))
                                Spacer()
                                Text(opportunity_data["location"]!)
                            }
                            .font(Font.custom("Nunito-SemiBold", size: 14))
                            .padding(.vertical, 5)
                        
                            Divider()
                                .overlay(.gray)
                                .frame(height: 1)
                                .opacity(0.5)
                                .padding(.vertical, 5)
                        
                        HStack {
                            Text("Type")
                                .foregroundColor(Color("Custom_Gray"))
                            Spacer()
                            Text("Equity")
                        }
                        .font(Font.custom("Nunito-SemiBold", size: 14))
                        .padding(.vertical, 5)
                    
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                            .padding(.vertical, 5)
                        
                        HStack {
                            Text("Equity Offered")
                                .foregroundColor(Color("Custom_Gray"))
                            Spacer()
                            Text("\(opportunity_data["equity_offered"]!)%")
                        }
                        .font(Font.custom("Nunito-SemiBold", size: 14))
                        .padding(.vertical, 5)
                    
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                            .padding(.vertical, 5)
                        
                    }
                    .frame(width: max(0, geometry.size.width - 40))
                }
                .foregroundColor(.black)
                
                Button(action: {
                    asking_price = Double(opportunity_data["asking_price"]!)!
                    equity_offered = Double(opportunity_data["equity_offered"]!)!
                    opportunity_id = opportunity_data["opportunity_id"]!
                    amount_offered = opportunity_data["amount_raised"]!
                    investors = String(describing: Int(opportunity_data["investors"]!)! + 1)
                    opportunity_name = opportunity_data["franchise"]!
                    user_invest_shown.toggle()
                }) {
                    HStack {
                        Text("Invest")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                    }
                    .frame(width: max(0, geometry.size.width-40), height: 55)
                    .background(Color("Secondary"))
                    .foregroundColor(Color.white)
                    .border(Color.black, width: 1)
                    .cornerRadius(5)
                    .padding(.bottom)
                }
                
            }
            .navigationDestination(isPresented: $user_invest_shown) {
                UserInvestPage(user_invest_shown: $user_invest_shown, asking_price: $asking_price, equity_offered: $equity_offered, opportunity_id: $opportunity_id, opportunity_name: $opportunity_name, amount_offered: $amount_offered, investors: $investors)
            }
//            .frame(width: max(0, geometry.size.width), height: max(0, geometry.size.height - 20))
            
        }
    }
}

//#Preview {
//    UserOpportunityClick(bg_image: .constant("store_live"), logo: .constant("McDonalds"), title: .constant("McDonald's"), progress: .constant("250,000"), min_investment_amount: .constant("100"), target_raise: .constant("250,000,000"))
//}
