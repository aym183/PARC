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
    var logo_images = ["McDonalds", "Starbucks", "Dominos", "Chipotle", "Subway", "McDonalds", "Starbucks", "Dominos", "Chipotle", "Subway"]
    var titles = ["McDonald's", "Starbucks", "Dominos", "Chipotle", "Subway", "McDonald's", "Starbucks", "Dominos", "Chipotle", "Subway"]
    @State var opportunity_logo: UIImage?
    @State var opportunity_data: [String:String] = [:]
    @State var payout_data: [String:String] = [:]
    @State var selected_trading_window: [String: String] = [:]
    @ObservedObject var readDB = ReadDB()
    var trading_window_transactions: [String:Int] = [:]
    @State var trading_volume = 0
    @State var no_of_trades = 0
    @State var isRefreshing = false
    @State var profile_image: UIImage?
    @State var init_profile_image: UIImage?
    @State private var counter = 2
    @State var trading_window_ongoing = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("PARC").font(Font.custom("Nunito-Black", size: 40)).foregroundColor(Color("Secondary"))
                            Spacer()
                            Button(action: { admin_account_click_shown.toggle() }) {
                                if profile_image != nil {
                                    Image(uiImage: profile_image!)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(100)
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                        
                        
                        if (self.isRefreshing == true) {
                            VStack(alignment: .center) {
                                Spacer()
                                LottieView(name: "loading_3.0", speed: 1, loop: false).frame(width: 75, height: 75)
                                Text("Loading...").font(Font.custom("Nunito-SemiBold", size: 20)).multilineTextAlignment(.center).foregroundColor(.black).padding(.top, -5)
                                Spacer()
                            }
                            .frame(width: max(0, geometry.size.width)-40)
                        } else {
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
                                        } else {
                                            ZStack {
                                                Button(action: {
                                                    opportunity_logo = loadDisplayImage(key: readDB.franchise_data[readDB.franchise_data.firstIndex(where: { $0["name"] ==  readDB.admin_opportunity_data[index-1]["franchise"]})!]["logo"]!)
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
                                                        if let franchiseName = readDB.admin_opportunity_data[index-1]["franchise"] {
                                                            if let franchiseIndex = readDB.franchise_data.firstIndex(where: { $0["name"] == franchiseName }) {
                                                                let matchedFranchise = readDB.franchise_data[franchiseIndex]["logo"]!
                                                                
                                                                if UserDefaults.standard.object(forKey: String(describing: matchedFranchise)) != nil {
                                                                    Image(uiImage: loadDisplayImage(key: String(describing: matchedFranchise)))
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fill)
                                                                        .frame(width: 30, height: 30)
                                                                        .padding([.leading, .top], 10).padding(.leading, 5)
                                                                } else {
                                                                    Image(systemName: "house")
                                                                        .resizable()
                                                                        .aspectRatio(contentMode: .fit)
                                                                        .frame(width: 40, height: 30)
                                                                        .padding(.top, 10)
                                                                        .padding(.leading, 5)
                                                                }
                                                            } else {
                                                                Image(systemName: "house")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .frame(width: 30, height: 30)
                                                                    .padding([.leading, .top], 10).padding(.leading, 5)
                                                            }
                                                        }
                                                        
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
                                                        if readDB.admin_opportunity_data[index-1]["status"]! == "Closed"{
                                                            Text("Closed")
                                                        } else if readDB.admin_opportunity_data[index-1]["status"]! == "Completed" {
                                                            Text("Completed")
                                                                .foregroundColor(Color("Profit"))
                                                        } else if getDaysRemaining(date_input: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))! <= 5 {
                                                            
                                                            Text("\(getDaysRemaining(date_input: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))!) days left")
                                                                .foregroundColor(Color("Loss"))
                                                            
                                                        } else if getDaysRemaining(date_input: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))! > 5 && getDaysRemaining(date_input: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))! < 15 {
                                                            
                                                            Text("\(getDaysRemaining(date_input: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))!) days left")
                                                                .foregroundColor(Color("Amber"))
                                                        } else {
                                                            Text("\(getDaysRemaining(date_input: String(describing: readDB.admin_opportunity_data[index-1]["close_date"]!))!) days left")
                                                        }
                                                        
                                                        Spacer()
                                                    }
                                                    .font(Font.custom("Nunito-Bold", size: 12))
                                                    .padding(.leading, 10)
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
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                                
                                                                Text(String(describing: readDB.payout_data[index-1]["status"]!))
                                                                    .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                    .foregroundColor(.white)
                                                            } else if readDB.payout_data[index-1]["status"] == "Completed" {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Profit"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                                
                                                                Text(String(describing: readDB.payout_data[index-1]["status"]!))
                                                                    .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                    .foregroundColor(.white)
                                                            } else if readDB.payout_data[index-1]["status"] == "Cancelled" {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Loss"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                                
                                                                Text(String(describing: readDB.payout_data[index-1]["status"]!))
                                                                    .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                    .foregroundColor(.white)
                                                            }
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Text("+£\(String(describing:   formattedNumber(input_number: Int(readDB.payout_data[index-1]["amount_offered"]!)!)))")
                                                            .font(Font.custom("Nunito-Bold", size: 25))
                                                        
                                                        Spacer()
                                                        
                                                        HStack {
                                                            
                                                            Text("Investors: \(String(describing: readDB.admin_opportunity_data[Int(readDB.payout_data[index-1]["opportunity_id"]!)!-1]["investors"]!))")
                                                            Divider()
                                                                .frame(height: 15)
                                                            
                                                            if readDB.payout_data[index-1]["status"] == "Scheduled" {
                                                                Text("Scheduled: \(String(describing: readDB.payout_data[index-1]["date_scheduled"]!))")
                                                            } else if readDB.payout_data[index-1]["status"] == "Completed" {
                                                                Text("Created: \(String(describing: readDB.payout_data[index-1]["date_created"]!))")
                                                                
                                                            } else if readDB.payout_data[index-1]["status"] == "Cancelled" {
                                                                Text("Created: \(String(describing: readDB.payout_data[index-1]["date_created"]!))")
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
                                            .opacity(trading_window_ongoing ? 0.5 : 1)
                                            .disabled(trading_window_ongoing ? true : false)
                                        } else {
                                            Button(action: {
                                                selected_trading_window = readDB.trading_window_data[index-1]
                                                trading_volume = readDB.transformed_trading_window_transactions_data["\(String(describing: readDB.trading_window_data[index-1]["trading-window-id"]!))_volume"] ?? 0
                                                no_of_trades = readDB.transformed_trading_window_transactions_data["\(String(describing: readDB.trading_window_data[index-1]["trading-window-id"]!))_trades"] ?? 0
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
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                            } else if readDB.trading_window_data[index-1]["status"] == "Ongoing"  {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Amber"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                                    .onAppear() {
                                                                        self.trading_window_ongoing = true
                                                                    }
                                                            } else if readDB.trading_window_data[index-1]["status"] == "Completed"  {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Profit"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                            } else if readDB.trading_window_data[index-1]["status"] == "Cancelled"  {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Loss"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                            }
                                                            
                                                            Text(String(describing: readDB.trading_window_data[index-1]["status"]!))
                                                                .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                .foregroundColor(.white)
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        if readDB.transformed_trading_window_transactions_data.count != 0 {
                                                            if readDB.transformed_trading_window_transactions_data.keys.contains("\(String(describing: readDB.trading_window_data[index-1]["trading-window-id"]!))_trades") {
                                                                Text("\(readDB.transformed_trading_window_transactions_data["\(String(describing: readDB.trading_window_data[index-1]["trading-window-id"]!))_trades"]!) Trades")
                                                                    .font(Font.custom("Nunito-Bold", size: 25))
                                                            } else {
                                                                Text("0 Trades")
                                                                    .font(Font.custom("Nunito-Bold", size: 25))
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            HStack {
                                                                if readDB.transformed_trading_window_transactions_data.keys.contains("\(String(describing: readDB.trading_window_data[index-1]["trading-window-id"]!))_volume") {
                                                                    
                                                                    Text("Volume - £\(convertNumberAmount(input_number: Double(readDB.transformed_trading_window_transactions_data["\(String(describing: readDB.trading_window_data[index-1]["trading-window-id"]!))_volume"]!)))")
                                                                } else {
                                                                    Text("Volume - £0")
                                                                    
                                                                }
                                                                
                                                                Divider()
                                                                    .frame(height: 15)
                                                                
                                                                if readDB.trading_window_data[index-1]["status"] == "Scheduled" {
                                                                    Text("Scheduled: \(readDB.trading_window_data[index-1]["start_date"]!)")
                                                                } else {
                                                                    Text("Started: \(readDB.trading_window_data[index-1]["start_date"]!)")
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
                        }
                        
                        Spacer()
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                    .foregroundColor(.black)
                }
                .refreshable() {
                    withAnimation(.easeOut(duration: 0.25)) {
                        isRefreshing = true
                    }
                    readDB.franchise_data = []
                    readDB.franchise_data_dropdown = []
                    readDB.admin_opportunity_data = []
                    readDB.payout_data = []
                    readDB.sold_shares = []
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
                                    readDB.payout_data = sortArrayByDate(inputArray: readDB.payout_data, field_name: "date_created", date_type: "dd/MM/yyyy")
                                }
                            }
                            readDB.getTradingWindows()
                            readDB.getTradingWindowTransactions()
                        }
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        if self.counter > 0 {
                            self.counter -= 1
                        } else {
                            withAnimation(.easeOut(duration: 0.25)) {
                                isRefreshing = false
                            }
                            timer.invalidate()
                        }
                    }
                }
            }
        }
        .onAppear {
            loadProfileImage() { response in
                if response != nil {
                    profile_image = response!
                    init_profile_image = response!
                }
            }
            readDB.franchise_data = []
            readDB.franchise_data_dropdown = []
            readDB.admin_opportunity_data = []
            readDB.payout_data = []
            readDB.opportunity_data_dropdown = []
            readDB.full_user_holdings_data = []
            readDB.trading_window_data = []
            readDB.sold_shares = []
            readDB.trading_window_transactions_data = []
            readDB.transformed_trading_window_transactions_data = [:]
            readDB.getFranchises()
            readDB.getAllUserHoldings()
            readDB.getAdminOpportunities() { response in
                if response == "Fetched all opportunities" {
                    readDB.getPayouts() { response in
                        if response == "Fetched payouts" {
                            readDB.payout_data = sortArrayByDate(inputArray: readDB.payout_data, field_name: "date_created", date_type: "dd/MM/yyyy")
                        }
                    }
                    readDB.getTradingWindows()
                    readDB.getTradingWindowTransactions()
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
            AdminOpportunityClick(opportunity_logo: $opportunity_logo, opportunity_data: $opportunity_data)
        }
        .navigationDestination(isPresented: $admin_trading_click_shown){
            AdminTradingClick(selected_trading_window: $selected_trading_window, trading_volume: $trading_volume, no_of_trades: $no_of_trades)
        }
        .navigationDestination(isPresented: $admin_payout_click_shown){
            AdminPayoutClick(opportunity_data: $opportunity_data, payout_data: $payout_data, admin_payout_click_shown: $admin_payout_click_shown)
        }
        .navigationDestination(isPresented: $admin_account_click_shown){
            AdminAccount(profile_image: $profile_image, init_profile_image: $init_profile_image)
        }
    }
    
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
