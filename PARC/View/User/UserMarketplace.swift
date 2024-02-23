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
    @Binding var listed_shares: [(key: String, value: Any)]
    @Binding var secondary_shares: [String: [[String: String]]]
    @Binding var opportunity_data: [[String: String]]
    @State var transformed_secondary_shares: [[String: String]] = []
    @Binding var transformed_payouts_data: [String: Any]
    @Binding var franchises: [[String: String]]
    @State var franchise_selected: [String: String] = [:]
    
    var body: some View {
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
            } else if trading_window_active == "true" && listed_shares.count == 0 {
                ZStack() {
                    Color(.white).ignoresSafeArea()
                    VStack {
                        Spacer()
                        Text("☹️")
                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.3))
                            .padding(.bottom, -20)
                        
                        Text("No shares currently listed")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                        Spacer()
                        
                        HStack {
                            Spacer() 
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
                    }
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    
                }
                .navigationDestination(isPresented: $marketplace_list_shares_shown) {
                    UserListShares(franchise_data: $franchise_data, holding_data: $holding_data, marketplace_shown: $marketplace_shown)
                }
                .sheet(isPresented: $marketplace_bottom_sheet_shown) {
                    UserMarketplaceBottomSheet(marketplace_bottom_sheet_shown: $marketplace_bottom_sheet_shown, marketplace_list_shares_shown: $marketplace_list_shares_shown).presentationDetents([.height(150)])
                }
                
                
            } else {
                ZStack(alignment: .bottomTrailing) {
                    Color(.white).ignoresSafeArea()
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            HStack(spacing: 40) {
                                Text("Logo")
                                Text("Franchise")
                                Text("Payouts")
                                Text("Available\nShares")
                            }
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                            .padding(.top, 10)
                            .multilineTextAlignment(.center)
                            
                            Divider()
                                .overlay(Color("Custom_Gray"))
                                .opacity(0.5)
                                .frame(height: 1)
                                .padding(.top, -5)
                            
                            if listed_shares.count != 0 && franchises.count != 0 {
                                ForEach((0..<listed_shares.count), id: \.self) { index in
                                    Button(action: {
                                        title = String(describing: listed_shares[index].key)
                                        logo = logo_images[index]
                                        transformed_secondary_shares = secondary_shares[title]!
                                        franchise_selected = franchises[franchises.firstIndex(where: { $0["name"] == String(describing: listed_shares[index].key)})!]
                                        marketplace_click_shown.toggle()
                                    }) {
                                        HStack {
                                                if let franchiseIndex = franchises.firstIndex(where: { $0["name"] == listed_shares[index].key }) {
                                                    let matchedFranchise = franchises[franchiseIndex]["logo"]!
                                                    
                                                    if UserDefaults.standard.object(forKey: String(describing: matchedFranchise)) != nil {
                                                        Image(uiImage: loadDisplayImage(key: String(describing: matchedFranchise)))
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 40, height: 40)
                                                    } else {
                                                        Image(systemName: "house")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 40, height: 40)
                                                    }
                                                    
                                                } else {
                                                    Image(systemName: "house")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 40, height: 40)
                                                }
                                
                                            Spacer()
                                            
                                            HStack {
                                                Spacer()
                                                Text(String(describing: listed_shares[index].key))
                                                Spacer()
                                            }
                                            .frame(width: geometry.size.width*0.25)
                                            .padding(.trailing, -10)
                                            
                                            Spacer()
                                            
                                            HStack {
                                                Spacer()
                                                Text("£\(formattedNumber(input_number: Int(String(describing: transformed_payouts_data[String(describing: listed_shares[index].key)]!))!))")
                                                Spacer()
                                            }
                                            .frame(width: 75)
//                                            .padding(.trailing, -25)
                                            
                                            Spacer()
                                            
                                            HStack {
                                                Spacer()
                                                Text("£\(formattedNumber(input_number: Int(String(describing: listed_shares[index].value))!))")
                                                Spacer()
                                            }
                                            .frame(width: 75)
//                                            .padding(.trailing, -5)
                                        }
                                        .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 5)
                                    }
                                    
                                    Divider()
                                        .overlay(Color("Custom_Gray"))
                                        .opacity(0.5)
                                        .frame(height: 1)
                                        .padding(.vertical, 5)
                                }
                            }
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
                    UserMarketplaceClick(title: $title, logo: $logo, shares_data: $transformed_secondary_shares, franchise_selected: $franchise_selected, opportunity_data: $opportunity_data)
                }
                .navigationDestination(isPresented: $marketplace_list_shares_shown) {
                    UserListShares(franchise_data: $franchise_data, holding_data: $holding_data, marketplace_shown: $marketplace_shown)
                }
                .sheet(isPresented: $marketplace_bottom_sheet_shown) {
                    UserMarketplaceBottomSheet(marketplace_bottom_sheet_shown: $marketplace_bottom_sheet_shown, marketplace_list_shares_shown: $marketplace_list_shares_shown).presentationDetents([.height(100)])
                }
            }
        }
    }
}
