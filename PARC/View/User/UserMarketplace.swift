//
//  UserMarketplace.swift
//  PARC
//
//  Created by Ayman Ali on 19/10/2023.
//

import SwiftUI

struct UserMarketplace: View {
    var logo_images = ["McDonalds", "Chipotle", "Dominos", "McDonalds", "Dominos", "Chipotle", "Dominos", "Subway"]
    var title_texts = ["McDonald's", "Chipotle", "Dominos", "McDonald's", "Dominos", "Chipotle", "Dominos", "Subway"]
    var valuation_data = ["£3.5M", "£700.5K", "£7.25M", "£100K", "£3.5M", "£700.5K", "£7.25M", "£100K"]
    var payouts = ["£10K", "£100K", "£2.5M", "£10K", "£100K", "£2.5M", "£10K", "£100K"]
    var available_shares = ["£55,000", "£35,000", "£10,000", "£49,760", "£55,000", "£35,000", "£1,000", "£49,760"]
    @State var marketplace_click_shown = false
    @State var marketplace_bottom_sheet_shown = false
    @State var marketplace_list_shares_shown = false
    @State var marketplace_shown = false
    @AppStorage("trading_window_active") var trading_window_active: String = ""
    @State var title = ""
    @State var logo = ""
    @Binding var franchise_data: [DropdownMenuOption]
    @Binding var holding_data: [DropdownMenuOption]
    @Binding var listed_shares: [String: Any]
    @Binding var secondary_shares: [String: [[String: String]]]
    @State var transformed_secondary_shares: [[String: String]] = []
    @Binding var transformed_payouts_data: [String: Any]
    
    var body: some View {
        let allKeys = Array(listed_shares.keys)
        GeometryReader { geometry in
            
            if trading_window_active == "false" {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        Spacer()
                        Text("☹️")
                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.3))
                            .padding(.bottom, -20)
                        
                        Text("Trading Window is closed")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                        
                        Text("You will be notified when the next one starts")
                            .frame(width: 210)
                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                            .padding(.top, -15)
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.bottom)
                }
            } else {
                ZStack(alignment: .bottomTrailing) {
                    Color(.white).ignoresSafeArea()
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
//                            HStack {
//                                VStack {
//                                    Text("Volume Traded")
//                                    Text("£10B+")
//                                        .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.065))
//                                        .padding(.top, 3)
//                                }
//                                
//                                Spacer()
//                                
//                                VStack {
//                                    Text("Deals Completed")
//                                    Text("15")
//                                        .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.065))
//                                        .padding(.top, 3)
//                                }
//                                
//                                Spacer()
//                                
//                                VStack {
//                                    Text("Average Returns")
//                                    Text("£10,000")
//                                        .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.065))
//                                        .padding(.top, 3)
//                                }
//                            }
//                            .multilineTextAlignment(.center)
//                            .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.030))
//                            .padding(.top, 10)
//                            (spacing: 40)
                            HStack {
                                Text("Businesses")
                                Spacer()
                                Text("Estimated Valuation")
                                Spacer()
                                Text("Payouts")
                                Spacer()
                                Text("Available Shares")
                            }
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                            .padding(.top, 10)
                            
                            Divider()
                                .overlay(Color("Custom_Gray"))
                                .frame(height: 1)
                                .padding(.top, -5)
                            
                            ForEach((0..<listed_shares.count), id: \.self) { index in
                                Button(action: {
                                    title = String(describing: Array(listed_shares.keys)[index])
                                    logo = logo_images[index]
                                    transformed_secondary_shares = secondary_shares[title]!
                                    marketplace_click_shown.toggle()
                                }) {
                                    HStack {

                                        Image("McDonalds")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            
                                        Spacer()
                                        
                                        HStack {
                                            Text(String(describing: Array(listed_shares.keys)[index]))
                                            Spacer()
                                        }
                                        .frame(width: 75)
                                        .padding(.trailing, -25)

                                        
                                        Spacer()
                                    
                                        HStack {
                                            
                                            Text("£\(formattedNumber(input_number: Int(String(describing: transformed_payouts_data[String(describing: Array(listed_shares.keys)[index])]!))!))")
                                            Spacer()
                                        }
                                        .frame(width: 75)
                                        .padding(.trailing, -30)
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Text("£\(formattedNumber(input_number: Int(String(describing: Array(listed_shares.values)[index]))!))")
                                            Spacer()
                                        }
                                        .frame(width: 75)
                                        .padding(.trailing, -20)
                                    }
                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                    .multilineTextAlignment(.leading)
                                }
                                
//                                if index != 5 {
                                    Divider()
                                        .overlay(Color("Custom_Gray")).opacity(0.6)
                                        .frame(height: 0.5)
                                        .padding(.vertical, 5)
//                                }
                            }
                            
                            // Add condition to remove Show more if only limite businesses have shares
//                            Button(action: {}) { 
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(Color("Secondary"))
//                                    Text("Show more")
//                                        .foregroundColor(.white)
//                                        .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.035))
//                                }
//                                .frame(width: 100, height: 40)
//                            }
//                            .padding(.top)
                        }
                        .foregroundColor(.black)
                        
                    }
                                   
                    Button(action: { marketplace_bottom_sheet_shown.toggle() }) {
                        ZStack {
                            Circle()
                                .fill(Color("Secondary"))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "plus")
                                .font(Font.custom("Nunito-Black", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 15).padding(.bottom)
                }
                .navigationDestination(isPresented: $marketplace_click_shown) {
                    UserMarketplaceClick(title: $title, logo: $logo, shares_data: $transformed_secondary_shares)
                }
                .navigationDestination(isPresented: $marketplace_list_shares_shown) {
                    UserListShares(franchise_data: $franchise_data, holding_data: $holding_data, marketplace_shown: $marketplace_shown)
                }
                .sheet(isPresented: $marketplace_bottom_sheet_shown) {
                    UserMarketplaceBottomSheet(marketplace_bottom_sheet_shown: $marketplace_bottom_sheet_shown, marketplace_list_shares_shown: $marketplace_list_shares_shown).presentationDetents([.height(150)])
                }
            }
        }
    }
}

//struct UserMarketplace_Previews: PreviewProvider {
//    static var previews: some View {
//        UserMarketplace()
//    }
//}
