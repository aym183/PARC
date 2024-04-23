//
//  AdminHome.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI
import Foundation

// The content shown on login to admins which allows them to manage all operations that users get to interact with
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
    @ObservedObject var read_db = ReadDB()
    var trading_window_transactions: [String:Int] = [:]
    @State var trading_volume = 0
    @State var no_of_trades = 0
    @State var is_refreshing = false
    @State var profile_image: UIImage?
    @State var init_profile_image: UIImage?
    @State private var counter = 2
    @State var trading_window_ongoing = false
    @AppStorage("is_unlocked") var is_unlocked: Bool = false
    
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
                        
                        
                        if (self.is_refreshing == true) {
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
                                    ForEach(0..<read_db.admin_opportunity_data.count+1, id: \.self ) { index in
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
                                                    opportunity_logo = load_display_image(key: read_db.franchise_data[read_db.franchise_data.firstIndex(where: { $0["name"] ==  read_db.admin_opportunity_data[index-1]["franchise"]})!]["logo"]!)
                                                    opportunity_data = read_db.admin_opportunity_data[index-1]
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
                                                        if let franchiseName = read_db.admin_opportunity_data[index-1]["franchise"] {
                                                            if let franchiseIndex = read_db.franchise_data.firstIndex(where: { $0["name"] == franchiseName }) {
                                                                let matchedFranchise = read_db.franchise_data[franchiseIndex]["logo"]!
                                                                
                                                                if UserDefaults.standard.object(forKey: String(describing: matchedFranchise)) != nil {
                                                                    Image(uiImage: load_display_image(key: String(describing: matchedFranchise)))
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
                                                        
                                                        Text(String(describing: read_db.admin_opportunity_data[index-1]["franchise"]!))
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
                                                                Text(String(describing: read_db.admin_opportunity_data[index-1]["location"]!))
                                                                    .font(Font.custom("Nunito-SemiBold", size: 8))
                                                                    .foregroundColor(Color("Custom_Gray"))
                                                                    .padding(.leading, -7.5)
                                                            }
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Text("Created - \(convert_date(dateString: String(describing: read_db.admin_opportunity_data[index-1]["date_created"]!)))")
                                                            .font(Font.custom("Nunito-SemiBold", size: 7))
                                                            .foregroundColor(Color("Custom_Gray"))
                                                    }
                                                    .padding(.horizontal, 10)
                                                    
                                                    ProgressView(value: Double(read_db.admin_opportunity_data[index-1]["ratio"]!))
                                                        .tint(Color("Secondary"))
                                                        .scaleEffect(x: 1, y: 2, anchor: .center)
                                                        .padding(.top,3)
                                                        .frame(width: 140)
                                                    
                                                    HStack {
                                                        if read_db.admin_opportunity_data[index-1]["status"]! == "Closed"{
                                                            Text("Closed")
                                                        } else if read_db.admin_opportunity_data[index-1]["status"]! == "Completed" {
                                                            Text("Completed")
                                                                .foregroundColor(Color("Profit"))
                                                        } else if get_days_remaining(date_input: String(describing: read_db.admin_opportunity_data[index-1]["close_date"]!))! <= 5 {
                                                            
                                                            Text("\(get_days_remaining(date_input: String(describing: read_db.admin_opportunity_data[index-1]["close_date"]!))!) days left")
                                                                .foregroundColor(Color("Loss"))
                                                            
                                                        } else if get_days_remaining(date_input: String(describing: read_db.admin_opportunity_data[index-1]["close_date"]!))! > 5 && get_days_remaining(date_input: String(describing: read_db.admin_opportunity_data[index-1]["close_date"]!))! < 15 {
                                                            
                                                            Text("\(get_days_remaining(date_input: String(describing: read_db.admin_opportunity_data[index-1]["close_date"]!))!) days left")
                                                                .foregroundColor(Color("Amber"))
                                                        } else {
                                                            Text("\(get_days_remaining(date_input: String(describing: read_db.admin_opportunity_data[index-1]["close_date"]!))!) days left")
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
                                    ForEach(0..<read_db.payout_data.count+1, id: \.self ) { index in
                                        
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
                                                opportunity_data = read_db.admin_opportunity_data[Int(read_db.payout_data[index-1]["opportunity_id"]!)!-1]
                                                payout_data = read_db.payout_data[index-1]
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
                                                            if read_db.payout_data[index-1]["status"] == "Scheduled" {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Amber"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                                
                                                                Text(String(describing: read_db.payout_data[index-1]["status"]!))
                                                                    .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                    .foregroundColor(.white)
                                                            } else if read_db.payout_data[index-1]["status"] == "Completed" {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Profit"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                                
                                                                Text(String(describing: read_db.payout_data[index-1]["status"]!))
                                                                    .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                    .foregroundColor(.white)
                                                            } else if read_db.payout_data[index-1]["status"] == "Cancelled" {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Loss"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                                
                                                                Text(String(describing: read_db.payout_data[index-1]["status"]!))
                                                                    .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                    .foregroundColor(.white)
                                                            }
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Text("+£\(String(describing: formatted_number(input_number: Int(read_db.payout_data[index-1]["amount_offered"]!)!)))")
                                                            .font(Font.custom("Nunito-Bold", size: 25))
                                                        
                                                        Spacer()
                                                        
                                                        HStack {
                                                            
                                                            Text("Investors: \(String(describing: read_db.admin_opportunity_data[Int(read_db.payout_data[index-1]["opportunity_id"]!)!-1]["investors"]!))")
                                                            
                                                            Divider().frame(height: 15)
                                                            
                                                            if read_db.payout_data[index-1]["status"] == "Scheduled" {
                                                                Text("Scheduled: \(String(describing: read_db.payout_data[index-1]["date_scheduled"]!))")
                                                            } else if read_db.payout_data[index-1]["status"] == "Completed" {
                                                                Text("Created: \(String(describing: read_db.payout_data[index-1]["date_created"]!))")
                                                                
                                                            } else if read_db.payout_data[index-1]["status"] == "Cancelled" {
                                                                Text("Created: \(String(describing: read_db.payout_data[index-1]["date_created"]!))")
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
                                    ForEach(0..<read_db.trading_window_data.count+1, id: \.self ) { index in
                                        
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
                                                selected_trading_window = read_db.trading_window_data[index-1]
                                                trading_volume = read_db.transformed_trading_window_transactions_data["\(String(describing: read_db.trading_window_data[index-1]["trading-window-id"]!))_volume"] ?? 0
                                                no_of_trades = read_db.transformed_trading_window_transactions_data["\(String(describing: read_db.trading_window_data[index-1]["trading-window-id"]!))_trades"] ?? 0
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
                                                            if read_db.trading_window_data[index-1]["status"] == "Scheduled" {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(.blue)
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                            } else if read_db.trading_window_data[index-1]["status"] == "Ongoing"  {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Amber"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                                    .onAppear() {
                                                                        self.trading_window_ongoing = true
                                                                    }
                                                            } else if read_db.trading_window_data[index-1]["status"] == "Completed"  {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Profit"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                            } else if read_db.trading_window_data[index-1]["status"] == "Cancelled"  {
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .fill(Color("Loss"))
                                                                    .frame(width: geometry.size.width*0.2, height: 25)
                                                            }
                                                            
                                                            Text(String(describing: read_db.trading_window_data[index-1]["status"]!))
                                                                .font(Font.custom("Nunito-ExtraBold", size: 12))
                                                                .foregroundColor(.white)
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        if read_db.transformed_trading_window_transactions_data.count != 0 {
                                                            if read_db.transformed_trading_window_transactions_data.keys.contains("\(String(describing: read_db.trading_window_data[index-1]["trading-window-id"]!))_trades") {
                                                                Text("\(read_db.transformed_trading_window_transactions_data["\(String(describing: read_db.trading_window_data[index-1]["trading-window-id"]!))_trades"]!) Trades")
                                                                    .font(Font.custom("Nunito-Bold", size: 25))
                                                            } else {
                                                                Text("0 Trades")
                                                                    .font(Font.custom("Nunito-Bold", size: 25))
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            HStack {
                                                                if read_db.transformed_trading_window_transactions_data.keys.contains("\(String(describing: read_db.trading_window_data[index-1]["trading-window-id"]!))_volume") {
                                                                    
                                                                    Text("Volume - £\(convert_number_amount(input_number: Double(read_db.transformed_trading_window_transactions_data["\(String(describing: read_db.trading_window_data[index-1]["trading-window-id"]!))_volume"]!)))")
                                                                } else {
                                                                    Text("Volume - £0")
                                                                    
                                                                }
                                                                
                                                                Divider()
                                                                    .frame(height: 15)
                                                                
                                                                if read_db.trading_window_data[index-1]["status"] == "Scheduled" {
                                                                    Text("Scheduled: \(read_db.trading_window_data[index-1]["start_date"]!)")
                                                                } else {
                                                                    Text("Started: \(read_db.trading_window_data[index-1]["start_date"]!)")
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
                        is_refreshing = true
                    }
                    read_db.franchise_data = []
                    read_db.franchise_data_dropdown = []
                    read_db.admin_opportunity_data = []
                    read_db.payout_data = []
                    read_db.sold_shares = []
                    read_db.opportunity_data_dropdown = []
                    read_db.full_user_holdings_data = []
                    read_db.trading_window_data = []
                    read_db.trading_window_transactions_data = []
                    read_db.transformed_trading_window_transactions_data = [:]
                    read_db.get_franchises()
                    read_db.get_all_user_holdings()
                    read_db.get_admin_opportunities() { response in
                        if response == "Fetched all opportunities" {
                            read_db.get_payouts() { response in
                                if response == "Fetched payouts data" {
                                    read_db.payout_data = sort_array_by_date(inputArray: read_db.payout_data, field_name: "date_created", date_type: "dd/MM/yyyy")
                                }
                            }
                            read_db.get_trading_windows()
                            read_db.get_trading_window_transactions()
                        }
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        if self.counter > 0 {
                            self.counter -= 1
                        } else {
                            withAnimation(.easeOut(duration: 0.25)) {
                                is_refreshing = false
                            }
                            timer.invalidate()
                        }
                    }
                }
            }
            .blur(radius: is_unlocked ? 0 : 10)
        }
        .onAppear {
            load_profile_image() { response in
                if response != nil {
                    profile_image = response!
                    init_profile_image = response!
                }
            }
            read_db.franchise_data = []
            read_db.franchise_data_dropdown = []
            read_db.admin_opportunity_data = []
            read_db.payout_data = []
            read_db.opportunity_data_dropdown = []
            read_db.full_user_holdings_data = []
            read_db.trading_window_data = []
            read_db.sold_shares = []
            read_db.trading_window_transactions_data = []
            read_db.transformed_trading_window_transactions_data = [:]
            read_db.get_franchises()
            read_db.get_all_user_holdings()
            read_db.get_admin_opportunities() { response in
                if response == "Fetched all opportunities" {
                    read_db.get_payouts() { response in
                        if response == "Fetched payouts" {
                            read_db.payout_data = sort_array_by_date(inputArray: read_db.payout_data, field_name: "date_created", date_type: "dd/MM/yyyy")
                        }
                    }
                    read_db.get_trading_windows()
                    read_db.get_trading_window_transactions()
                }
            }
        }
        .navigationDestination(isPresented: $admin_payout_form_shown){
            AdminPayoutForm(opportunity_data: $read_db.opportunity_data_dropdown, user_holdings_data: $read_db.full_user_holdings_data)
        }
        .navigationDestination(isPresented: $admin_opportunity_form_shown){
            AdminOpportunityForm(franchise_data: $read_db.franchise_data_dropdown)
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
