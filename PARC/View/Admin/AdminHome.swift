//
//  AdminHome.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI
import Foundation

struct AdminHome: View {
    var rows: [GridItem] = [
        GridItem(.flexible() , spacing: nil, alignment: nil),
    ]
    @State var admin_opportunity_form_shown = false
    @State var admin_payout_form_shown = false
    @State var admin_trading_form_shown = false
    @State var admin_opportunity_click_shown = false
    @State var admin_payout_click_shown = false
    @State var admin_trading_click_shown = false
    @State var admin_account_click_shown = false
    var logo_images = ["McDonalds", "Starbucks", "Dominos", "Chipotle", "Subway"]
    var titles = ["McDonald's", "Starbucks", "Dominos", "Chipotle", "Subway"]
    @State var opportunity_title = ""
    @State var opportunity_logo = ""
    @State var opportunity_data: [String:String] = [:]
    @ObservedObject var readDB = ReadDB()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("PARC").font(Font.custom("Nunito-Black", size: 60)).foregroundColor(Color("Secondary"))
                            Spacer()
                            Button(action: { admin_account_click_shown.toggle() }) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        
                        Text("Opportunities")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            .padding(.bottom, -5)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                            .padding(.bottom, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: rows, spacing: 20) {
                                ForEach(0..<readDB.opportunity_data.count+1, id: \.self ) { index in
                                    if index == 0 {
                                        Button(action: { admin_opportunity_form_shown.toggle() }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.black, lineWidth: 1.25)
                                                    )
                                                
                                                VStack {
                                                    Text("Add Opportunity")
                                                        .font(Font.custom("Nunito-ExtraBold", size: 15))
                                                        .foregroundColor(Color("Secondary"))
                                                        .padding(.bottom)
                                                    ZStack {
                                                        Circle()
                                                            .frame(width: 35, height: 35)
                                                            .foregroundColor(Color("Secondary"))
                                                        Image(systemName: "plus")
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                            }
                                            .frame(width: 135, height: 140)
                                        }
                                    } else {
                                        ZStack {
                                            Button(action: {
                                                opportunity_logo = logo_images[index-1]
                                                opportunity_title = titles[index-1]
                                                opportunity_data = readDB.opportunity_data[index-1]
                                                admin_opportunity_click_shown.toggle()
                                            }) {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.black, lineWidth: 1.25)
                                                    )
                                                    .frame(width: 160, height: 140)
                                            }
                                            
                                            VStack {
                                                HStack {
                                                    Image(logo_images[index-1])
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 40, height: 40)
                                                        .padding([.leading, .top], 10)
                                                    
                                                    Text(String(describing: readDB.opportunity_data[index-1]["franchise"]!))
                                                        .font(Font.custom("Nunito-Bold", size: 16))
                                                        .padding(.top, 10)
                                                    Spacer()
                                                }
                                                Spacer()
                                                
                                                HStack {
                                                    
                                                    ZStack {
                                                        Rectangle()
                                                            .foregroundColor(.clear)
                                                            .frame(width: 50, height: 14)
                                                            .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.5))
                                                            .cornerRadius(5)
                                                        
                                                        HStack(spacing: 10) {
                                                            Image("gbr").resizable().frame(width: 10, height: 10)
                                                            Text(String(describing: readDB.opportunity_data[index-1]["location"]!))
                                                                .font(Font.custom("Nunito-Bold", size: 8))
                                                                .foregroundColor(Color("Custom_Gray"))
                                                                .padding(.leading, -7.5)
                                                        }
//                                                        .padding(.trailing, 15)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Text("Created - \(String(describing: readDB.opportunity_data[index-1]["date_created"]!))")
                                                        .font(Font.custom("Nunito-Bold", size: 7))
                                                        .foregroundColor(Color("Custom_Gray"))
                                                }
                                                .padding(.horizontal, 10)
                                                
                                                ProgressView(value: Double(readDB.opportunity_data[index-1]["ratio"]!))
                                                    .tint(Color("Secondary"))
                                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                                                    .padding(.top,3)
                                                    .frame(width: 140)
                                                
                                                HStack {
                                                    if getDaysRemaining(dateString: String(describing: readDB.opportunity_data[index-1]["close_date"]!))! <= 5 {
                                                        
                                                        Text("\(getDaysRemaining(dateString: String(describing: readDB.opportunity_data[index-1]["close_date"]!))!) days left")
                                                            .font(Font.custom("Nunito-ExtraBold", size: 15))
                                                            .foregroundColor(Color("Loss"))
                                                            .padding(.leading, 10)
                                                        
                                                    } else if getDaysRemaining(dateString: String(describing: readDB.opportunity_data[index-1]["close_date"]!))! > 5 && getDaysRemaining(dateString: String(describing: readDB.opportunity_data[index-1]["close_date"]!))! < 15 {
                                                        
                                                        Text("\(getDaysRemaining(dateString: String(describing: readDB.opportunity_data[index-1]["close_date"]!))!) days left")
                                                            .font(Font.custom("Nunito-ExtraBold", size: 15))
                                                            .foregroundColor(Color("Amber"))
                                                            .padding(.leading, 10)
                                                        
                                                    } else {
                                                        
                                                        Text("\(getDaysRemaining(dateString: String(describing: readDB.opportunity_data[index-1]["close_date"]!))!) days left")
                                                            .font(Font.custom("Nunito-ExtraBold", size: 15))
                                                            .foregroundColor(.black)
                                                            .padding(.leading, 10)
                                                        
                                                    }
                                                    
                                                    Spacer()
                                                }
                                                
                                                
                                                
                                            }
                                            .padding(.bottom, 10)
                                        }
                                        .frame(width: 160, height: 140)
                                    }
                                }
                            }
                            .padding(.leading,2)
                        }
                        .frame(height: 150)
                        
                        Text("Payouts")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            .padding(.bottom, -5)
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: rows, spacing: 20) {
                                ForEach(0..<5, id: \.self ) { index in
                                    
                                    if index == 0 {
                                        Button(action: { admin_payout_form_shown.toggle() }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.black, lineWidth: 1.25)
                                                    )
                                                
                                                VStack {
                                                    Text("Initiate Payout")
                                                        .font(Font.custom("Nunito-ExtraBold", size: 15))
                                                        .foregroundColor(Color("Secondary"))
                                                        .padding(.bottom)
                                                    ZStack {
                                                        Circle()
                                                            .frame(width: 35, height: 35)
                                                            .foregroundColor(Color("Secondary"))
                                                        Image(systemName: "plus")
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                            }
                                            .frame(width: 135, height: 140)
                                        }
                                    } else {
                                        Button(action: { admin_payout_click_shown.toggle() }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.black, lineWidth: 1.25)
                                                    )
                                                
                                                VStack {
                                                    Text("15/06/2023")
                                                        .font(Font.custom("Nunito-Bold", size: 16))
                                                    
                                                    Spacer()
                                                    
                                                    Text("+£50,000")
                                                        .font(Font.custom("Nunito-ExtraBold", size: 25))
                                                        .foregroundColor(Color("Profit"))
                                                    
                                                    Spacer()
                                                    
                                                    HStack {
                                                        Text("Investors - 500")
                                                        Divider()
                                                            .frame(height: 15)
                                                        
                                                        Text("Opportunity ID - 5")
                                                    }
                                                    .font(Font.custom("Nunito-Bold", size: 6.5))
                                                    .foregroundColor(Color("Custom_Gray"))
                                                }
                                                .padding(.vertical)
                                            }
                                            .frame(width: 160, height: 140)
                                        }
                                    }
                                }
                            }
                            .padding(.leading,2)
                        }
                        .frame(height: 150)
                        
                        Text("Secondary Market")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            .padding(.bottom, -5)
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: rows, spacing: 20) {
                                ForEach(0..<5, id: \.self ) { index in
                                    
                                    if index == 0 {
                                        Button(action: { admin_trading_form_shown.toggle() }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.black, lineWidth: 1.25)
                                                    )
                                                
                                                VStack {
                                                    Text("Trading Window")
                                                        .font(Font.custom("Nunito-ExtraBold", size: 15))
                                                        .foregroundColor(Color("Secondary"))
                                                        .padding(.bottom)
                                                    ZStack {
                                                        Circle()
                                                            .frame(width: 35, height: 35)
                                                            .foregroundColor(Color("Secondary"))
                                                        Image(systemName: "plus")
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                            }
                                            .frame(width: 135, height: 140)
                                        }
                                    } else {
                                        Button(action: { admin_trading_click_shown.toggle() }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.black, lineWidth: 1.25)
                                                    )
                                                
                                                VStack {
                                                    Text("15/06/2023")
                                                        .font(Font.custom("Nunito-Bold", size: 16))
                                                    
                                                    Spacer()
                                                    
                                                    Text("500 Trades")
                                                        .font(Font.custom("Nunito-ExtraBold", size: 25))
                                                        .foregroundColor(Color("Profit"))
                                                    
                                                    Spacer()
                                                    
                                                    HStack {
                                                        Text("Total Spend - £500k")
                                                        Divider()
                                                            .frame(height: 15)
                                                        
                                                        // Replace with variable status according to stats (Completed, Ongoing)
                                                        Text("Completed")
                                                            .foregroundColor(Color("Profit"))
                                                    }
                                                    .font(Font.custom("Nunito-Bold", size: 6.5))
                                                    .foregroundColor(Color("Custom_Gray"))
                                                }
                                                .padding(.vertical)
                                            }
                                            .frame(width: 160, height: 140)
                                        }
                                    }
                                }
                            }
                            .padding(.leading,2)
                        }
                        .frame(height: 150)
                        
                        Spacer()
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                    .foregroundColor(.black)
                }
                }
            }
            .onAppear {
                readDB.franchise_data = []
                readDB.opportunity_data = []
                readDB.opportunity_data_dropdown = []
                readDB.getOpportunities()
                readDB.getFranchises()
            }
            .navigationDestination(isPresented: $admin_payout_form_shown){
                AdminPayoutForm(opportunity_data: $readDB.opportunity_data_dropdown)
            }
            .navigationDestination(isPresented: $admin_opportunity_form_shown){
                AdminOpportunityForm(franchise_data: $readDB.franchise_data)
            }
            .navigationDestination(isPresented: $admin_trading_form_shown){
                AdminTradingForm()
            }
            .navigationDestination(isPresented: $admin_opportunity_click_shown){
                AdminOpportunityClick(opportunity_logo: $opportunity_logo, opportunity_title: $opportunity_title, opportunity_data: $opportunity_data)
            }
            .navigationDestination(isPresented: $admin_trading_click_shown){
                AdminTradingClick()
            }
            .navigationDestination(isPresented: $admin_payout_click_shown){
                AdminPayoutClick()
            }
            .navigationDestination(isPresented: $admin_account_click_shown){
                AdminAccount()
            }
        }
}

#Preview {
    AdminHome()
}
