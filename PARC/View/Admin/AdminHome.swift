//
//  AdminHome.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI
import Foundation

//class TradingWindowTransactions {
//    var id: String = ""
//    var amount: Int = 0
//    var no_of_trades: Int = 0
//}
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
    @State var payout_data: [String:String] = [:]
    @State var selected_trading_window: [String: String] = [:]
    @ObservedObject var readDB = ReadDB()
    var trading_window_transactions: [String:Int] = [:]
    @State var trading_volume = 0
    @State var no_of_trades = 0
    
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
                                ForEach(0..<readDB.admin_opportunity_data.count+1, id: \.self ) { index in
                                    if index == 0 {
                                        Button(action: { admin_opportunity_form_shown.toggle() }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.gray, lineWidth: 1.25)
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
                                    } else if getDaysRemaining(dateString: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))! < 1 {
                                        ZStack {
                                            Button(action: {
                                                opportunity_logo = logo_images[index-1]
                                                opportunity_title = titles[index-1]
                                                opportunity_data = readDB.admin_opportunity_data[index-1]
                                                admin_opportunity_click_shown.toggle()
                                            }) {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.gray, lineWidth: 1.25)
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
                                                    
                                                    Text(String(describing: readDB.admin_opportunity_data[index-1]["franchise"]!))
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
                                                            Text(String(describing: readDB.admin_opportunity_data[index-1]["location"]!))
                                                                .font(Font.custom("Nunito-SemiBold", size: 8))
                                                                .foregroundColor(Color("Custom_Gray"))
                                                                .padding(.leading, -7.5)
                                                        }
//                                                        .padding(.trailing, 15)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Text("Created - \(convertDate(dateString: String(describing: readDB.admin_opportunity_data[index-1]["date_created"]!)))")
                                                        .font(Font.custom("Nunito-SemiBold", size: 7))
                                                        .foregroundColor(Color("Custom_Gray"))
                                                }
                                                .padding(.horizontal, 10)
                                                
                                                ProgressView(value: Double(readDB.admin_opportunity_data[index-1]["ratio"]!))
                                                    .tint(Color("Secondary"))
                                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                                                    .padding(.top,3)
                                                    .frame(width: 140)
                                                
                                                HStack {
                                                    
                                                    Text("Completed")
                                                            .font(Font.custom("Nunito-Bold", size: 12))
                                                            .foregroundColor(Color("Profit"))
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 10)
                                                
                                                
                                                
                                            }
                                            .padding(.bottom, 10)
                                        }
                                        .frame(width: 160, height: 140)
                                    } else {
                                        ZStack {
                                            Button(action: {
                                                opportunity_logo = logo_images[index-1]
                                                opportunity_title = titles[index-1]
                                                opportunity_data = readDB.admin_opportunity_data[index-1]
                                                admin_opportunity_click_shown.toggle()
                                            }) {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.gray, lineWidth: 1.25)
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
                                                    
                                                    Text(String(describing: readDB.admin_opportunity_data[index-1]["franchise"]!))
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
                                                            Text(String(describing: readDB.admin_opportunity_data[index-1]["location"]!))
                                                                .font(Font.custom("Nunito-SemiBold", size: 8))
                                                                .foregroundColor(Color("Custom_Gray"))
                                                                .padding(.leading, -7.5)
                                                        }
//                                                        .padding(.trailing, 15)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Text("Created - \(convertDate(dateString: String(describing: readDB.admin_opportunity_data[index-1]["date_created"]!)))")
                                                        .font(Font.custom("Nunito-SemiBold", size: 7))
                                                        .foregroundColor(Color("Custom_Gray"))
                                                }
                                                .padding(.horizontal, 10)
                                                
                                                ProgressView(value: Double(readDB.admin_opportunity_data[index-1]["ratio"]!))
                                                    .tint(Color("Secondary"))
                                                    .scaleEffect(x: 1, y: 2, anchor: .center)
                                                    .padding(.top,3)
                                                    .frame(width: 140)
                                                
                                                HStack {
                                                    if getDaysRemaining(dateString: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))! <= 5 {
                                                        
                                                        Text("\(getDaysRemaining(dateString: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))!) days left")
                                                            .font(Font.custom("Nunito-SemiBold", size: 12))
                                                            .foregroundColor(Color("Loss"))
                                                            .padding(.leading, 10)
                                                        
                                                    } else if getDaysRemaining(dateString: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))! > 5 && getDaysRemaining(dateString: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))! < 15 {
                                                        
                                                        Text("\(getDaysRemaining(dateString: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))!) days left")
                                                            .font(Font.custom("Nunito-SemiBold", size: 12))
                                                            .foregroundColor(Color("Amber"))
                                                            .padding(.leading, 10)
                                                        
                                                    } else {
                                                        
                                                        Text("\(getDaysRemaining(dateString: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))!) days left")
                                                            .font(Font.custom("Nunito-SemiBold", size: 12))
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
                                ForEach(0..<readDB.payout_data.count+1, id: \.self ) { index in
                                    
                                    if index == 0 {
                                        Button(action: { admin_payout_form_shown.toggle() }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.gray, lineWidth: 1.25)
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
                                        Button(action: {
                                            opportunity_data = readDB.admin_opportunity_data[Int(readDB.payout_data[index-1]["opportunity_id"]!)!-1]
                                            payout_data = readDB.payout_data[index-1]
                                            admin_payout_click_shown.toggle()
                                        }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.gray, lineWidth: 1.25)
                                                    )
                                                
                                                VStack {
                                                    ZStack {
                                                        if readDB.payout_data[index-1]["status"] == "Scheduled" {
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .fill(Color("Amber"))
                                                                .frame(width: max(0, geometry.size.width-300), height: 25)
                                                            
                                                            Text(String(describing: readDB.payout_data[index-1]["status"]!))
                                                                .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                .foregroundColor(.white)
                                                        } else if readDB.payout_data[index-1]["status"] == "Completed" {
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .fill(Color("Profit"))
                                                                .frame(width: max(0, geometry.size.width-300), height: 25)
                                                            
                                                            Text(String(describing: readDB.payout_data[index-1]["status"]!))
                                                                .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                .foregroundColor(.white)
                                                        } else if readDB.payout_data[index-1]["status"] == "Cancelled" {
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .fill(Color("Loss"))
                                                                .frame(width: max(0, geometry.size.width-300), height: 25)
                                                            
                                                            Text(String(describing: readDB.payout_data[index-1]["status"]!))
                                                                .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                    
                                                    Spacer()

                                                    Text("+£\(String(describing:   formattedNumber(input_number: Int(readDB.payout_data[index-1]["amount_offered"]!)!)))")
                                                        .font(Font.custom("Nunito-Bold", size: 25))
//                                                        .foregroundColor(Color("Profit"))
                                                    
                                                    Spacer()
                                                    
                                                    HStack {
                                                        
                                                        Text("Investors: \(String(describing: readDB.admin_opportunity_data[Int(readDB.payout_data[index-1]["opportunity_id"]!)!-1]["investors"]!))")
                                                        
                                                        //    readDB.opportunity_data[Int(readDB.payout_data[index-1]["oportunity_id"])-1]["investors"]
                                                        Divider()
                                                            .frame(height: 15)
                                                        
                                                        if readDB.payout_data[index-1]["status"] == "Scheduled" {
                                                            Text("Scheduled: \(convertDate(dateString: String(describing: readDB.payout_data[index-1]["date_scheduled"]!)))")
                                                        } else if readDB.payout_data[index-1]["status"] == "Completed" {
                                                            Text("Created: \(convertDate(dateString: String(describing: readDB.payout_data[index-1]["date_created"]!)))")
                                                            
                                                        } else if readDB.payout_data[index-1]["status"] == "Cancelled" {
                                                            Text("Created: \(convertDate(dateString: String(describing: readDB.payout_data[index-1]["date_created"]!)))")
                                                        }
                                                    }
                                                    .font(Font.custom("Nunito-SemiBold", size: 6.5))
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
                                ForEach(0..<readDB.trading_window_data.count+1, id: \.self ) { index in
                                    
                                    if index == 0 {
                                        Button(action: { admin_trading_form_shown.toggle() }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.gray, lineWidth: 1.25)
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
                                        Button(action: {
                                            selected_trading_window = readDB.trading_window_data[index-1]
                                            trading_volume = readDB.transformed_trading_window_transactions_data["\(String(describing: index))_volume"]!
                                            no_of_trades = readDB.transformed_trading_window_transactions_data["\(String(describing: index))_trades"]!
                                            admin_trading_click_shown.toggle()
                                        }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.gray, lineWidth: 1.25)
                                                    )
                                                
                                                VStack {
                                                    ZStack {
                                                        if readDB.trading_window_data[index-1]["status"] == "Scheduled" {
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .fill(.blue)
                                                                .frame(width: max(0, geometry.size.width-300), height: 25)
                                                        } else if readDB.trading_window_data[index-1]["status"] == "Ongoing"  {
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .fill(Color("Amber"))
                                                                .frame(width: max(0, geometry.size.width-300), height: 25)
                                                        } else if readDB.trading_window_data[index-1]["status"] == "Completed"  {
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .fill(Color("Profit"))
                                                                .frame(width: max(0, geometry.size.width-300), height: 25)
                                                        } else if readDB.trading_window_data[index-1]["status"] == "Cancelled"  {
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .fill(Color("Loss"))
                                                                .frame(width: max(0, geometry.size.width-300), height: 25)
                                                        }
                                                        
                                                        Text(String(describing: readDB.trading_window_data[index-1]["status"]!))
                                                            .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                            .foregroundColor(.white)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    if readDB.transformed_trading_window_transactions_data.count != 0 {
                                                        Text("\(readDB.transformed_trading_window_transactions_data["\(String(describing: index))_trades"]!) Trades")
                                                            .font(Font.custom("Nunito-Bold", size: 25))
                                                        
                                                        Spacer()
                                                        
                                                        HStack {
                                                            Text("Volume - £\(readDB.transformed_trading_window_transactions_data["\(String(describing: index))_volume"]!)")
                                                            Divider()
                                                                .frame(height: 15)
                                                            
                                                            if readDB.trading_window_data[index-1]["status"] == "Scheduled" {
                                                                Text("Scheduled: \(convertDate(dateString: readDB.trading_window_data[index-1]["start_date"]!))")
                                                            } else {
                                                                Text("Started: \(convertDate(dateString: readDB.trading_window_data[index-1]["start_date"]!))")
                                                            }
                                                        }
                                                        .font(Font.custom("Nunito-SemiBold", size: 6.5))
                                                        .foregroundColor(Color("Custom_Gray"))
                                                    }
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
                readDB.franchise_data_dropdown = []
                readDB.admin_opportunity_data = []
                readDB.payout_data = []
                readDB.opportunity_data_dropdown = []
                readDB.full_user_holdings_data = []
                readDB.trading_window_data = []
                readDB.trading_window_transactions_data = []
                readDB.transformed_trading_window_transactions_data = [:]
                readDB.getFranchises()
                readDB.getAllUserHoldings()
                readDB.getAdminOpportunities() { response in
                    if response == "Fetched all opportunities" {
                        readDB.getPayouts() { response in
                            if response == "Fetched payouts data" {
                                print("payouts fetched")
                            }
                        }
                        readDB.getTradingWindows()
                        readDB.getTradingWindowTransactions() 
//                        { response in
//                            if response == "Trading window transactions fetched" {
//                                print("trading window transactions fetched")
//                                print(readDB.transformed_trading_window_transactions_data)
//                            }
//                        }
                    }
                }
            }
            .navigationDestination(isPresented: $admin_payout_form_shown){
                AdminPayoutForm(opportunity_data: $readDB.opportunity_data_dropdown, user_holdings_data: $readDB.full_user_holdings_data)
            }
            .navigationDestination(isPresented: $admin_opportunity_form_shown){
                AdminOpportunityForm(franchise_data: $readDB.franchise_data_dropdown)
            }
            .navigationDestination(isPresented: $admin_trading_form_shown){
                AdminTradingForm()
            }
            .navigationDestination(isPresented: $admin_opportunity_click_shown){
                AdminOpportunityClick(opportunity_logo: $opportunity_logo, opportunity_title: $opportunity_title, opportunity_data: $opportunity_data)
            }
            .navigationDestination(isPresented: $admin_trading_click_shown){
                AdminTradingClick(selected_trading_window: $selected_trading_window, trading_volume: $trading_volume, no_of_trades: $no_of_trades)
            }
            .navigationDestination(isPresented: $admin_payout_click_shown){
                AdminPayoutClick(opportunity_data: $opportunity_data, payout_data: $payout_data, admin_payout_click_shown: $admin_payout_click_shown)
            }
            .navigationDestination(isPresented: $admin_account_click_shown){
                AdminAccount()
            }
        }
    
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    AdminHome()
}
