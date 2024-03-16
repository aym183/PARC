//
//  UserOpportunity.swift
//  PARC
//
//  Created by Ayman Ali on 20/10/2023.
//

import SwiftUI
import SlidingTabView

// Content seen by users when an investable opportunity is clicked on
struct UserOpportunityClick: View {
    @Binding var opportunity_data: [String: String]
    @Binding var franchise_data: [String: String]
    @Binding var franchise_logo: UIImage?
    @Binding var display_image: UIImage?
    @State var text_selected = ""
    @State var user_invest_shown = false
    @State var chatbot_shown = false
    @State var asking_price = 0.0
    @State var equity_offered = 0.0
    @State var opportunity_id = ""
    @State var amount_offered = ""
    @State var investors = ""
    @State var opportunity_name = ""
    @State var min_investment_amount = ""
    @State var titles_why_invest_1 = ["Passive Income", "Diversification"]
    @State var titles_why_invest_description = ["Get a share of the profits every month and earn money while you sleep", "Strengthen your portfolio by investing in franchises of different types"]
    @State var titles_why_invest_2 = ["Recession Proof", "Brand Value"]
    @State var titles_why_invest_description_2 = ["The need for food and beverages remains during economic crises", "The franchise has built up trust and credibility with its consumers"]
    @State var titles_similar_franchise_1 = ["Dividend Payout", "Net Return"]
    @State var titles_similar_franchise_images = ["Dividend_Payout", "Net_Return"]
    @State var titles_similar_franchise_2 = ["Annual Profit", "Success Rate"]
    @State var titles_similar_franchise_images_2 = ["Annual_Profit", "96%"]
    @State var titles_selected_franchise_1 = ["TTM Revenue", "MoM Revenue"]
    @State var selected_franchise_data = ["avg_revenue_18_months", "avg_franchise_mom_revenues"]
    @State var selected_franchise_data_2 = ["ebitda_estimate", "no_of_franchises"]
    @State var titles_selected_franchise_2 = ["EBITDA", "No of Franchises"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color(.white).ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    ZStack {
                        Image(uiImage: display_image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: max(0, geometry.size.width))
                        
                        VStack {
                            HStack {
                                Spacer()
                                ZStack {
                                    if getDaysRemaining(date_input: String(describing: opportunity_data["close_date"]!))! <= 7 {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: geometry.size.width*0.3, height: 35)
                                            .background(Color("Amber"))
                                            .cornerRadius(5)
                                    } else if getDaysRemaining(date_input: String(describing: opportunity_data["close_date"]!))! <= 2 {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: geometry.size.width*0.3, height: 35)
                                            .background(Color("Loss"))
                                            .cornerRadius(5)
                                    } else {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: geometry.size.width*0.3, height: 30)
                                            .background(Color("Secondary"))
                                            .cornerRadius(5)
                                    }
                                    
                                    Text("\(String(describing: getDaysRemaining(date_input: String(describing: opportunity_data["close_date"]!))!)) days left")
                                        .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding([.trailing, .top], 10)
                            Spacer()
                        }
                    }
                    
                    VStack {
                        HStack {
                            Image(uiImage: franchise_logo!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                            
                            Text(String(describing: opportunity_data["franchise"]!))
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                            
                            Spacer()
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 70, height: 20)
                                    .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.5))
                                    .cornerRadius(5)
                                
                                HStack(spacing: 10) {
                                    Image("gbr").resizable().frame(width: 15, height: 15)
                                    Text(String(describing: opportunity_data["location"]!))
                                        .font(Font.custom("Nunito-Bold", size: 12))
                                        .foregroundColor(Color("Custom_Gray"))
                                        .padding(.leading, -7.5)
                                }
                            }
                        }
                        
                        Text(franchise_data["description"]!)
                            .foregroundColor(Color("Custom_Gray"))
                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.033))
                            .frame(width: max(0, geometry.size.width-40), height: 80)
                            .multilineTextAlignment(.leading).padding(.top, -10).padding(.bottom, -5)
                        
                        HStack {
                            Text("\(String(describing: Int(Double(opportunity_data["ratio"]!)!*100)))% - £\(formattedNumber(input_number:  Int(opportunity_data["amount_raised"]!)!)) raised")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.0255))
                                .foregroundColor(Color("Custom_Gray"))
                            Spacer()
                            
                        }
                        .padding(.top, 5)
                        
                        ProgressView(value: Double(opportunity_data["ratio"]!))
                            .tint(Color("Secondary"))
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .padding(.top, -1)
                        
                        HStack {
                            Text("Minimum Investment Amount - £\(opportunity_data["min_invest_amount"]!)")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.0255))
                                .foregroundColor(Color("Custom_Gray"))
                            
                            Spacer()
                            
                            Text("Target - £\(String(describing: formattedNumber(input_number:Int(opportunity_data["asking_price"]!)!)))")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.0255))
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
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.075))
                                Text("Invested")
                                    .foregroundColor(Color("Custom_Gray"))
                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                    .padding(.top, -25)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("\(String(describing: opportunity_data["investors"]!))")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.075))
                                Text("Investors")
                                    .foregroundColor(Color("Custom_Gray"))
                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                    .padding(.top, -25)
                            }
                            .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
                        
                        HStack {
                            Text("Why Invest in Franchises?")
                            Spacer()
                        }
                        .padding(.top)
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                        
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
                            .padding(.top, -15)
                        
                        ForEach(0..<2, id: \.self) { index in
                            HStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color("Custom_Light_Gray"))
                                        .frame(width: geometry.size.width*0.45)
                                    
                                    VStack {
                                        Text(titles_why_invest_1[index])
                                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                            .padding(.bottom, 10)
                                        
                                        Text(titles_why_invest_description[index])
                                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.033))
                                        //                                            .foregroundColor(.gray)
                                            .foregroundColor(Color("Secondary"))
                                            .multilineTextAlignment(.center)
                                        
                                    }
                                    .padding(.horizontal, 10)
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color("Custom_Light_Gray"))
                                        .frame(width: geometry.size.width*0.45)
                                    
                                    VStack {
                                        Text(titles_why_invest_2[index])
                                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                            .padding(.bottom, 10)
                                        
                                        Text(titles_why_invest_description_2[index])
                                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.033))
                                        //                                            .foregroundColor(.gray)
                                            .foregroundColor(Color("Secondary"))
                                            .multilineTextAlignment(.center)
                                        
                                    }
                                    .padding(.horizontal, 10)
                                    
                                }
                                
                            }
                            .frame(height: 120)
                            .padding(.vertical, 2.5)
                        }
                        
                        
                        HStack(spacing: 30) {
                            Button(action : {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    text_selected = "Selected Franchise"
                                }
                            }) {
                                VStack {
                                    Text("Selected Franchise").font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                    
                                    if text_selected == "Selected Franchise" || text_selected == "" {
                                        Divider()
                                            .frame(height: 2.5)
                                            .background(Color("Secondary"))
                                            .cornerRadius(5)
                                            .padding(.top, -7.5)
                                    }
                                }
                            }
                            
                            Button(action : {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    text_selected = "Similar Franchises"
                                }
                            }) {
                                VStack {
                                    Text("Similar Franchises").font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                    if text_selected == "Similar Franchises" {
                                        Divider()
                                            .frame(height: 2.5)
                                            .background(Color("Secondary"))
                                            .cornerRadius(5)
                                            .padding(.top, -7.5)
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
                            .padding(.top, -5)
                        
                        
                        if text_selected == "Similar Franchises" {
                            ForEach(0..<2, id: \.self) { index in
                                HStack(spacing: 10) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color("Custom_Light_Gray"))
                                            .frame(width: geometry.size.width*0.45)
                                        
                                        VStack {
                                            
                                            if index == 0 {
                                                Text(titles_similar_franchise_1[index])
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                                
                                                Image(titles_similar_franchise_images[index])
                                                    .resizable()
                                                    .frame(width: 140, height: 120)
                                                    .scaledToFit()
                                                    .padding(.bottom, 15)
                                                
                                            } else {
                                                Text(titles_similar_franchise_1[index])
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                                    .padding(.top, -5)
                                                
                                                Image(titles_similar_franchise_images[index])
                                                    .resizable()
                                                    .frame(width: 135, height: 135)
                                                    .scaledToFit()
                                                    .padding(.top, -5)
                                            }
                                        }
                                        .padding(.horizontal, 10)
                                    }
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color("Custom_Light_Gray"))
                                            .frame(width: geometry.size.width*0.45)
                                        
                                        VStack {
                                            Text(titles_similar_franchise_2[index])
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                                .padding(.top, -5)
                                            
                                            if index == 0 {
                                                Image(titles_similar_franchise_images_2[index])
                                                    .resizable()
                                                    .frame(width: 135, height: 135)
                                                    .scaledToFit()
                                                    .padding(.top, -5)
                                            } else {
                                                VStack {
                                                    Text("96%")
                                                        .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.15))
                                                        .padding(.bottom, -20)
                                                    Text("of fast-food franchises are profitable")
                                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.025))
                                                        .padding(.horizontal, 10)
                                                }
                                                .foregroundColor(Color("Secondary"))
                                                .padding(.top, 5).padding(.bottom, 18)
                                                .multilineTextAlignment(.center)
                                            }
                                            
                                        }
                                        .padding(.horizontal, 10)
                                        
                                    }
                                    
                                }
                                .frame(height: 190)
                                .padding(.bottom, 2.5).padding(.top, 5)
                            }
                        } else {
                            ForEach(0..<2, id: \.self) { index in
                                HStack(spacing: 10) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color("Custom_Light_Gray"))
                                            .frame(width: geometry.size.width*0.45)
                                        
                                        VStack {
                                            
                                            Text(titles_selected_franchise_1[index])
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                                .padding(.top, 5)
                                            
                                            Text("£\(convertNumberAmount(input_number: Double(franchise_data[selected_franchise_data[index]]!)!))")
                                                .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.1))
                                                .foregroundColor(Color("Secondary"))
                                                .padding(.vertical, 1.5)
                                        }
                                        .padding(.horizontal, 10)
                                    }
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color("Custom_Light_Gray"))
                                            .frame(width: geometry.size.width*0.45)
                                        
                                        VStack {
                                            Text(titles_selected_franchise_2[index])
                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                                .padding(.top, 5)
                                            
                                            if index == 0 {
                                                Text("\(franchise_data[selected_franchise_data_2[index]]!)%")
                                                    .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.1))
                                                    .foregroundColor(Color("Secondary"))
                                                    .padding(.vertical, 1.5)
                                            } else {
                                                Text("\(franchise_data[selected_franchise_data_2[index]]!)")
                                                    .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.1))
                                                    .foregroundColor(Color("Secondary"))
                                                    .padding(.vertical, 1.5)
                                            }
                                            
                                        }
                                        .padding(.horizontal, 10)
                                        
                                    }
                                }
                                .frame(height: 120)
                                .padding(.bottom, 2.5).padding(.top, 5)
                            }
                        }
                        
                        HStack {
                            Text("Investment Overview")
                            Spacer()
                        }
                        .padding(.top)
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
                            .padding(.top, -15)
                        
                        
                        HStack {
                            Text("Location")
                                .foregroundColor(Color("Custom_Gray"))
                            Spacer()
                            Text(opportunity_data["location"]!)
                        }
                        .font(Font.custom("Nunito-SemiBold", size: 14))
                        .padding(.bottom, 5)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
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
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
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
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.5)
                            .frame(height: 1)
                            .padding(.vertical, 5)
                        
                    }
                    .frame(width: max(0, geometry.size.width - 40))
                }
                .foregroundColor(.black)
                
                HStack(spacing: 20) {
                    VStack {
                        Spacer()
                        Button(action: {
                            asking_price = Double(opportunity_data["asking_price"]!)!
                            equity_offered = Double(opportunity_data["equity_offered"]!)!
                            opportunity_id = opportunity_data["opportunity_id"]!
                            amount_offered = opportunity_data["amount_raised"]!
                            investors = String(describing: Int(opportunity_data["investors"]!)! + 1)
                            opportunity_name = opportunity_data["franchise"]!
                            min_investment_amount = opportunity_data["min_invest_amount"]!
                            user_invest_shown.toggle()
                        }) {
                            HStack {
                                Text("Invest")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                            }
                            .frame(width: geometry.size.width*0.7, height: geometry.size.height*0.0725)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                            .padding(.bottom)
                        }
                        Spacer()
                    }
                    .frame(height: 40)
                    .padding(.top, 40)
                    
                    Button(action: { chatbot_shown.toggle() }) {
                        HStack {
                            Image(systemName: "message.fill")
                                .foregroundColor(.white)
                                .font(.system(size: geometry.size.width*0.05))
                            
                        }
                        .frame(width:  geometry.size.width*0.14, height: geometry.size.height*0.0725)
                        .background(Color("Secondary"))
                        .cornerRadius(100)
                    }
                    .padding(.top, 20)
                }
                .frame(width: max(0, geometry.size.width))
                .background(.white)
            }
            .navigationDestination(isPresented: $user_invest_shown) {
                UserInvestPage(user_invest_shown: $user_invest_shown, asking_price: $asking_price, equity_offered: $equity_offered, opportunity_id: $opportunity_id, opportunity_name: $opportunity_name, amount_offered: $amount_offered, investors: $investors, min_investment: $min_investment_amount)
            }
            .sheet(isPresented: $chatbot_shown) {
                UserChatbot().presentationDetents([.height(750)])
            }
        }
    }
}
