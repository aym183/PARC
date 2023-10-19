//
//  UserMarketplace.swift
//  PARC
//
//  Created by Ayman Ali on 19/10/2023.
//

import SwiftUI

struct UserMarketplace: View {
    var logo_images = ["McDonalds", "Chipotle", "Dominos", "Subway"]
    var title_images = ["McDonald's", "Chipotle", "Dominos", "Subway"]
    var valuation_data = ["£3.5M", "£700.5K", "£7.25M", "£100K"]
    var percent_changes = [502, 200, 10, 1000]
    var available_shares = ["£55,000", "£35,000", "£1,000", "£49,760"]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    VStack {
                        Text("Volume Traded")
                        Text("£10B+")
                            .font(Font.custom("Nunito-SemiBold", size: 25))
                            .padding(.top, 3)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Deals Completed")
                        Text("15")
                            .font(Font.custom("Nunito-SemiBold", size: 25))
                            .padding(.top, 3)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Average Returns")
                        Text("£10,000")
                            .font(Font.custom("Nunito-SemiBold", size: 25))
                            .padding(.top, 3)
                    }
                }
                .multilineTextAlignment(.center)
                .font(Font.custom("Nunito-ExtraBold", size: 14))
                .padding(.top, 10)
                
                HStack {
                    Text("Businesses")
                    Spacer()
                    Text("Estimated Valuation")
                    Spacer()
                    Text("% Change")
                    Spacer()
                    Text("Available Shares")
                }
                .font(Font.custom("Nunito-ExtraBold", size: 11))
                .padding(.top)
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color("Custom_Gray"))
                    .padding(.top, -5)
                
                ForEach((0..<4), id: \.self) { index in
                    Button(action: {}) {
                        HStack {
                            VStack {
                                Image(logo_images[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 55, height: 55)
                                
                                Text(title_images[index])
                                    .font(Font.custom("Nunito-ExtraBold", size: 11))

                            }
                            Spacer()
                            
                            Text(valuation_data[index])
                            
                            Spacer()
                            
                            if percent_changes[index] >= 500 {
                                Text("\(percent_changes[index])%")
                                    .foregroundColor(Color("Profit"))
                            } else {
                                Text("\(percent_changes[index])%")
                                    .foregroundColor(Color("Loss"))
                            }
                            
                            Spacer()
                            
                            Text(available_shares[index])
                            
                        }
                        .font(Font.custom("Nunito-ExtraBold", size: 14))
                    }
                    Divider()
                        .frame(height: 0.5)
                        .overlay(Color("Custom_Gray")).opacity(0.6)
                        .padding(.vertical, 5)
                }
            }
            .foregroundColor(.black)
        }
    }
}

struct UserMarketplace_Previews: PreviewProvider {
    static var previews: some View {
        UserMarketplace()
    }
}
