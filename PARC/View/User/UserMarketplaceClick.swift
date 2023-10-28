//
//  UserMarketplaceClick.swift
//  PARC
//
//  Created by Ayman Ali on 22/10/2023.
//

import SwiftUI

struct UserMarketplaceClick: View {
    @State var investment_titles = ["Location", "Type", "Equity Offered", "Share Price"]
    @State var investment_values = ["Stratford, London", "Equity", "12.54%", "£38.42"]
    @State var share_prices = ["£400", "£560", "£230", "£120"]
    @State var no_of_shares = ["10", "60", "85", "90"]
    @State var total_values = ["£85,000", "£15,000", "£68,000", "£23,000"]
    @Binding var title: String
    @Binding var logo: String
    
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
                        
                        Text("Business Overview")
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
                        
                        HStack(spacing: 15) {
                            Text("Share Price")
                            Text("No of Shares")
                            Text("Total Value")
                        }
                        .padding(.vertical, 7.5)
                        .font(Font.custom("Nunito-Bold", size: 11))
                        
                        ForEach(0..<4, id: \.self) {index in
                            HStack(alignment: .center, spacing: 50) {
                                Text(share_prices[index])
                                Text(no_of_shares[index])
                                Text(total_values[index])
                                
                                Button(action: {}) {
                                    HStack {
                                        Text("Make Offer")
                                            .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.028))
                                    }
                                    .frame(width: max(0, geometry.size.width-300), height: 40)
                                    .background(Color("Secondary"))
                                    .foregroundColor(Color.white)
                                    .border(Color.black, width: 1)
                                    .cornerRadius(5)
                                    .padding(.leading, -20)
                                }

                            }
                            .font(Font.custom("Nunito-Bold", size: 16))
                            .padding(.vertical, 5)
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

//#Preview {
//    UserMarketplaceClick()
//}
