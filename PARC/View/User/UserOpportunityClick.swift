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

struct UserOpportunity: View {
    @Binding var bg_image: String
    @Binding var logo: String
    @Binding var title: String
    @Binding var progress: String
    @Binding var min_investment_amount: String
    @Binding var target_raise: String
    @State var user_invest_shown = false
    @State var investment_titles = ["Location", "Type", "Equity Offered", "Share Price", "", ""]
    @State var investment_values = ["Stratford, London", "Equity", "12.54%", "£38.42", "", ""]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color(.white).ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    Image(bg_image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: max(0, geometry.size.width))
                        .padding(.top)
                    
                    VStack {
                        
                        HStack {
                            Image(logo)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                            
                            Text(title)
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                            
                            Spacer()
                        }
                        
                        Text("A golden opportunity for those seeking a turnkey, globally renowned business in the fast-food industry, backed by a proven system of success and ongoing support.")
                            .frame(width: max(0, geometry.size.width - 40))
                            .foregroundColor(Color("Custom_Gray"))
                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.030))


                        
                        HStack {
                            Text(progress)
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
                                    Text("London")
                                        .font(Font.custom("Nunito-Bold", size: 8))
                                        .foregroundColor(Color("Custom_Gray"))
                                        .padding(.leading, -7.5)
                                }
                            }
                        }
                        .padding(.top, -3)
                        
                        ProgressView(value: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/)
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
                            Text("Minimum Investment Amount - £\(min_investment_amount)")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.024))
                                .foregroundColor(Color("Custom_Gray"))
                            
                            Spacer()
                            
                            Text(target_raise)
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
                                Text("£900,000")
                                    .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.075))
                                Text("Invested")
                                    .foregroundColor(Color("Custom_Gray"))
                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("400")
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
                        
                       
                        ForEach(0..<investment_titles.count, id: \.self) {index in
                            HStack {
                                Text(investment_titles[index])
                                    .foregroundColor(Color("Custom_Gray"))
                                Spacer()
                                Text(investment_values[index])
                                }
                                .font(Font.custom("Nunito-SemiBold", size: 14))
                            if index < 3 {
                                Divider()
                                    .overlay(.gray)
                                    .frame(height: 1)
                                    .opacity(0.5)
                            }
                        }
                        .padding(.vertical, 5)
                        
                    }
                    .frame(width: max(0, geometry.size.width - 40))
                }
                .foregroundColor(.black)
                
                Button(action: { user_invest_shown.toggle() }) {
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
                UserInvestPage(user_invest_shown: $user_invest_shown)
            }
//            .frame(width: max(0, geometry.size.width), height: max(0, geometry.size.height - 20))
            
        }
    }
}

#Preview {
    UserOpportunity(bg_image: .constant("store_live"), logo: .constant("McDonalds"), title: .constant("McDonald's"), progress: .constant("250,000"), min_investment_amount: .constant("100"), target_raise: .constant("250,000,000"))
}
