//
//  UserHomeView.swift
//  PARC
//
//  Created by Ayman Ali on 18/10/2023.
//

import SwiftUI
import URLImage

// Displays the central home content for users with the bottom navigation bar
struct UserHome: View {
    @State var selected_tab: Tab = .house
    @State var account_shown = false
    @Binding var is_investment_confirmed: Bool
    @Binding var is_withdrawal_confirmed: Bool
    @Binding var is_shown_home_page: Bool
    @State var is_shown_onboarding = false
    @AppStorage("first_name") var first_name: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("onboarding_completed") var onboarding_completed: Bool = false
    @State var image_url = URL(string: "")
    @ObservedObject var read_db = ReadDB()
    @State var portfolio_data: [[String: String]] = []
    @State var user_payouts_data: [[String: String]] = []
    @State var holdings_value: Int = 0
    @State var payouts_value: Int = 0
    @State var chart_values: [Float] = []
    @State var payouts_chart_values: [Float] = []
    @State var opportunity_data: [[String: String]] = []
    @State var admin_opportunity_data: [[String: String]] = []
    @State var transformed_payouts_data: [String: Any] = [:]
    @State var profile_image: UIImage?
    @State var init_profile_image: UIImage?
    @AppStorage("is_unlocked") var is_unlocked: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            if is_shown_onboarding {
                UserOnboarding(is_shown_onboarding: $is_shown_onboarding)
            } else {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    
                    // Animations that are shown to the user in different conditions. Thsoe include:
                    // (i) Appearing on the app, (ii) Investment confirmed, and (iii) Withdrawals
                    if is_shown_home_page {
                        VStack(alignment: .center) {
                            Spacer()
                            LottieView(name: "loading_3.0", speed: 1, loop: false).frame(width: 100, height: 100)
                            Text("Welcome \(first_name)").font(Font.custom("Nunito-ExtraBold", size: 30)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black).padding(.top, -5)
                            Text("Your PARC journey awaits 🥳").font(Font.custom("Nunito-Medium", size: 20)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black)
                            Spacer()
                        }
                        .foregroundColor(.black).frame(width: max(0, geometry.size.width))
                    }
                    
                    if is_investment_confirmed {
                        VStack(alignment: .center) {
                            Spacer()
                            Text("Congratulations!").font(Font.custom("Nunito-Bold", size: 40))
                            Text("Your investment has been received. Thank you for trusting PARC!").font(Font.custom("Nunito-Bold", size: 16))
                                .multilineTextAlignment(.center)
                                .padding(.top, -25)
                                .frame(width: 270)
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .frame(width: max(0, geometry.size.width))
                        LottieView(name: "confetti", speed: 0.5, loop: false).frame(width: max(0, geometry.size.width))
                    }
                    
                    if is_withdrawal_confirmed {
                        VStack(alignment: .center) {
                            Spacer()
                            Text("Confirmed!").font(Font.custom("Nunito-Bold", size: 40))
                            Text("Your withdrawal request has been received. It should be in your inbox shortly!").font(Font.custom("Nunito-Bold", size: 16))
                                .multilineTextAlignment(.center)
                                .padding(.top, -25)
                                .frame(width: 270)
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .frame(width: max(0, geometry.size.width))
                        LottieView(name: "confetti", speed: 0.5, loop: false).frame(width: max(0, geometry.size.width))
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("PARC").font(Font.custom("Nunito-Black", size: 40)).foregroundColor(Color("Secondary"))
                            Spacer()
                            
                            Button(action: { account_shown.toggle() }) {
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
                        
                        // Configuring the bottom navbar to show specific content on click of a bottom navbar element
                        if selected_tab == .house {
                            Text("New Opportunities")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserHomeContent(opportunity_data: $read_db.user_opportunity_data, franchise_data: $read_db.franchise_data, user_holdings_data: $read_db.user_holdings_data, readDB: read_db, email: $email, portfolio_data: $portfolio_data, transformed_payouts_data: $transformed_payouts_data, user_payouts_data: $user_payouts_data, payouts_value: $payouts_value, payouts_chart_values: $payouts_chart_values, admin_opportunity_data: $admin_opportunity_data, holdings_value: $holdings_value, chart_values: $chart_values)
                            
                        } else if selected_tab == .chartPie {
                            Text("Portfolio")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserPortfolio(portfolio_data: $portfolio_data, franchise_data: $read_db.franchise_data, user_payouts_data: $user_payouts_data, payouts_chart_values: $payouts_chart_values, payouts_value: $payouts_value, holdings_value: $holdings_value, chart_values: $chart_values, opportunity_data: $read_db.admin_opportunity_data)
                        } else {
                            Text("Secondary Market")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserMarketplace(franchise_data: $read_db.franchise_data_dropdown, holding_data: $read_db.user_holdings_data_dropdown, listed_shares: $read_db.secondary_market_data, secondary_shares: $read_db.listed_shares, opportunity_data: $read_db.admin_opportunity_data, transformed_payouts_data: $transformed_payouts_data, franchises: $read_db.franchise_data)
                        }
                        
                        Spacer()
                        BottomNavBar(selected_tab: $selected_tab)
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                    .foregroundColor(.black)
                    .onAppear {
                        // Fetching all the information needed to operate all user views across the application
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                is_shown_home_page = false
                                is_investment_confirmed = false
                                is_withdrawal_confirmed = false
                                if !onboarding_completed {
                                    is_shown_onboarding.toggle()
                                }
                            }
                        }
                        load_profile_image() { response in
                            if response != nil {
                                profile_image = response!
                                init_profile_image = response!
                            }
                        }
                        read_db.user_holdings_data_dropdown = []
                        read_db.listed_shares = [:]
                        read_db.franchise_data_dropdown = []
                        read_db.franchise_data = []
                        read_db.user_opportunity_data = []
                        read_db.admin_opportunity_data = []
                        read_db.user_holdings_data = []
                        read_db.full_user_holdings_data = []
                        read_db.user_payout_data = []
                        read_db.sold_shares = []
                        read_db.trading_window_data = []
                        read_db.payout_data = []
                        read_db.secondary_market_transactions_ind = 0
                        read_db.get_franchises()
                        read_db.get_all_user_holdings()
                        read_db.get_trading_windows()
                        read_db.get_trading_window_transactions_email()
                        read_db.get_payouts() { response in
                            if response == "Fetched payouts" {
                                self.transformed_payouts_data = transform_payouts(payouts_array: read_db.payout_data)
                            }
                        }
                        read_db.get_user_payouts(email: email) { response in
                            if response == "Fetched user payouts" {
                                self.user_payouts_data = read_db.user_payout_data
                                self.payouts_value = calculate_total_value(input: self.user_payouts_data, field: "amount_received")
                                self.payouts_chart_values = calculate_payout_opportunities(input: self.user_payouts_data)
                            }
                        }
                        read_db.get_user_holdings(email: email) { response in
                            if response == "Fetched user holdings" {
                                self.portfolio_data = read_db.user_holdings_data
                                self.holdings_value = calculate_total_value(input: self.portfolio_data, field: "amount")
                                self.chart_values = calculate_portion_holdings(input: portfolio_data, holdings_value: calculate_total_value(input: self.portfolio_data, field: "amount"))
                            }
                        }
                        read_db.get_admin_opportunities() { response in
                            if response == "Fetched all opportunities" {
                                self.admin_opportunity_data = read_db.admin_opportunity_data
                            }
                        }
                        read_db.get_user_opportunities() { response in
                            if response == "Fetched all opportunities" {
                                self.opportunity_data = read_db.user_opportunity_data
                                self.admin_opportunity_data = read_db.admin_opportunity_data
                            }
                        }
                    }
                    .opacity(is_investment_confirmed ? 0 : 1)
                    .opacity(is_shown_home_page ? 0 : 1)
                    .opacity(is_withdrawal_confirmed ? 0 : 1)
                }
                .blur(radius: is_unlocked ? 0 : 10)
                .navigationDestination(isPresented: $account_shown) {
                    UserAccount(payouts_value: $payouts_value, secondary_transactions_value: $read_db.secondary_market_transactions_ind, profile_image: $profile_image, init_profile_image: $init_profile_image, user_holdings: $read_db.user_holdings_data, user_holdings_sold: $read_db.sold_shares)
                }
            }
        }
    }
}

// Displays the content shown to the user specifically when the home tab on the bottom navigation bar is selected. This displays all investable opportunities
struct UserHomeContent: View {
    var logo_images = ["McDonalds", "Starbucks"]
    @State var opportunity_shown = false
    @Binding var opportunity_data: [[String: String]]
    @State var selected_opportunity: [String: String] = [:]
    @State var selected_franchise: [String: String] = [:]
    @State var franchise_logo: UIImage?
    @State var display_image: String?
    @Binding var franchise_data: [[String: String]]
    @Binding var user_holdings_data: [[String: String]]
    @ObservedObject var readDB: ReadDB
    @Binding var email: String
    @Binding var portfolio_data: [[String: String]]
    @Binding var transformed_payouts_data : [String: Any]
    @Binding var user_payouts_data: [[String: String]]
    @Binding var payouts_value: Int
    @Binding var payouts_chart_values: [Float]
    @Binding var admin_opportunity_data: [[String: String]]
    @Binding var holdings_value: Int
    @Binding var chart_values: [Float]
    @State var is_refreshing = false
    @State private var counter = 2
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                
                // Animation when user refreshes the home page
                if (is_refreshing == true) {
                    VStack(alignment: .center) {
                        Spacer()
                        LottieView(name: "loading_3.0", speed: 1, loop: false).frame(width: 75, height: 75)
                        Text("Loading...").font(Font.custom("Nunito-SemiBold", size: 20)).multilineTextAlignment(.center).foregroundColor(.black).padding(.top, -5)
                        Spacer()
                    }
                    .frame(width: max(0, geometry.size.width))
                } else if (opportunity_data.count != 0 && franchise_data.count != 0) {
                    // Displying the content for the home page (i.e. all the investment opportunities)
                    ForEach(0..<opportunity_data.count, id: \.self) { index in
                        Button(action: {
                            selected_franchise = franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data[index]["franchise"]!})!]
                            selected_opportunity = opportunity_data[index]
                            franchise_logo = load_display_image(key: franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data[index]["franchise"]!})!]["logo"]!)
                            display_image = franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data[index]["franchise"]!})!]["display_image"]!
                            opportunity_shown.toggle()
                        }) {
                            ZStack{
                                Image(franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data[index]["franchise"]!})!]["display_image"]!)
                                            .resizable()
                                            .frame(height: 225)
                                            .cornerRadius(5)
                                            
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    ZStack {
                                                        if get_days_remaining(date_input: String(describing: opportunity_data[index]["close_date"]!))! <= 7 {
                                                            Rectangle()
                                                                .foregroundColor(.clear)
                                                                .frame(width: geometry.size.width*0.22, height: 22)
                                                                .background(Color("Amber"))
                                                                .cornerRadius(5)
                                                        } else if get_days_remaining(date_input: String(describing: opportunity_data[index]["close_date"]!))! <= 2 {
                                                            Rectangle()
                                                                .foregroundColor(.clear)
                                                                .frame(width: geometry.size.width*0.22, height: 22)
                                                                .background(Color("Loss"))
                                                                .cornerRadius(5)
                                                        } else {
                                                            Rectangle()
                                                                .foregroundColor(.clear)
                                                                .frame(width: geometry.size.width*0.22, height: 22)
                                                                .background(Color("Secondary"))
                                                                .cornerRadius(5)
                                                        }
                                                        
                                                        Text("\(String(describing: get_days_remaining(date_input: String(describing: opportunity_data[index]["close_date"]!))!)) days left")
                                                            .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                                            .foregroundColor(.white)
                                                    }
                                                    .padding([.trailing, .top], 10)
                                                }
                                                Spacer()
                                            }

                                Rectangle()
                                    .opacity(0)
                                    .frame(height: 225)
                                    .cornerRadius(2.5)
                                    .border(.gray, width: 1)
                                
                                VStack {
                                    Spacer()
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(.white)
                                            .frame(height: 155)
                                            .border(.gray, width: 1)
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                
                                                if let franchiseName = opportunity_data[index]["franchise"] {
                                                    if let franchiseIndex = franchise_data.firstIndex(where: { $0["name"] == franchiseName }) {
                                                        let matchedFranchise = readDB.franchise_data[franchiseIndex]["logo"]!
                                                        
                                                        if UserDefaults.standard.object(forKey: String(describing: matchedFranchise)) != nil {
                                                            Image(uiImage: load_display_image(key: String(describing: matchedFranchise)))
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 40, height: 30)
                                                                .padding(.top, 10)
                                                                .padding(.leading, 5)
                                                                
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
                                                            .frame(width: 40, height: 30)
                                                            .padding(.top, 10)
                                                            .padding(.leading, 5)
                                                    }
                                                }
                                                
                                                Text(String(describing: opportunity_data[index]["franchise"]!))
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                                    .padding(.top, 10).padding(.leading, -7.5)
                                                
                                                Spacer()
                                                
                                                ZStack {
                                                    Rectangle()
                                                        .foregroundColor(.clear)
                                                        .frame(width: 70, height: 20)
                                                        .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.5))
                                                        .cornerRadius(5)
                                                    
                                                    HStack(spacing: 10) {
                                                        Image("gbr").resizable().frame(width: 15, height: 15)
                                                        Text(String(describing: opportunity_data[index]["location"]!))
                                                            .font(Font.custom("Nunito-Bold", size: 12))
                                                            .foregroundColor(Color("Custom_Gray"))
                                                            .padding(.leading, -7.5)
                                                    }
                                                }
                                                .padding([.trailing, .top], 10)
                                            }
                                            .padding(.leading, -2.5)
                                            
                                            Text(franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data[index]["franchise"]!})!]["description"]!)
                                                .foregroundColor(Color("Custom_Gray"))
                                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.033))
                                                .frame(height: 80)
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, 12).padding(.vertical, -15)
                                            
                                            HStack {
                                                
                                                Text("\(String(describing: Int(Double(opportunity_data[index]["ratio"]!)!*100)))% - £\(formatted_number(input_number:  Int(opportunity_data[index]["amount_raised"]!)!)) raised")
                                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.0255))
                                                    .foregroundColor(Color("Custom_Gray"))
                                                    .frame(alignment: .leading)
                                                Spacer()
                                          
                                            }
                                            .padding(.horizontal,12)
                                            .padding(.top, 5).padding(.bottom, -2)
                                            
                                            ProgressView(value: Double(opportunity_data[index]["ratio"]!))
                                                .tint(Color("Secondary"))
                                                .scaleEffect(x: 1, y: 2, anchor: .center)
                                                .padding(.horizontal, 11)
                                            
                                            HStack {
                                                Text("Min Investment - £\(opportunity_data[index]["min_invest_amount"]!)")
                                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.0255))
                                                    .foregroundColor(Color("Custom_Gray"))
                                                    .frame(alignment: .leading)
                                                Spacer()
                                                Text("Target - £\(String(describing: formatted_number(input_number:Int(opportunity_data[index]["asking_price"]!)!)))")
                                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.0255))
                                                    .foregroundColor(Color("Custom_Gray"))
                                                    .frame(alignment: .leading)
                                                
                                            }
                                            .padding(.horizontal,12)
                                            .padding(.top, -3)
                                            
                                            
                                            Spacer()
                                            
                                        }
                                        .frame(height: 150)
                                    }
                                }
                            }
                            .padding(.top)
                            .foregroundColor(.black)
                        }
                        .id(index)
                    }
                    .frame(width: max(0, geometry.size.width))
                    .navigationDestination(isPresented: $opportunity_shown) {
                        UserOpportunityClick(opportunity_data: $selected_opportunity, franchise_data: $selected_franchise, franchise_logo: $franchise_logo, display_image: $display_image)
                    }
                }
            }
            .refreshable() {
                // Fetching all the information needed to operate all user views across the application after refresh is initiated
                withAnimation(.easeOut(duration: 0.25)) {
                    is_refreshing = true
                }
                readDB.user_holdings_data_dropdown = []
                readDB.listed_shares = [:]
                readDB.franchise_data_dropdown = []
                readDB.franchise_data = []
                readDB.user_opportunity_data = []
                readDB.admin_opportunity_data = []
                readDB.sold_shares = []
                readDB.user_holdings_data = []
                readDB.full_user_holdings_data = []
                readDB.user_payout_data = []
                readDB.trading_window_data = []
                readDB.payout_data = []
                readDB.secondary_market_transactions_ind = 0
                readDB.get_franchises()
                readDB.get_all_user_holdings()
                readDB.get_trading_windows()
                readDB.get_trading_window_transactions_email()
                readDB.get_payouts() { response in
                    if response == "Fetched payouts" {
                        self.transformed_payouts_data = transform_payouts(payouts_array: readDB.payout_data)
                    }
                }
                readDB.get_user_payouts(email: email) { response in
                    if response == "Fetched user payouts" {
                        self.user_payouts_data = readDB.user_payout_data
                        self.payouts_value = calculate_total_value(input: self.user_payouts_data, field: "amount_received")
                        self.payouts_chart_values = calculate_payout_opportunities(input: self.user_payouts_data)
                    }
                }
                readDB.get_user_holdings(email: email) { response in
                    if response == "Fetched user holdings" {
                        self.portfolio_data = readDB.user_holdings_data
                        self.holdings_value = calculate_total_value(input: self.portfolio_data, field: "amount")
                        self.chart_values = calculate_portion_holdings(input: portfolio_data, holdings_value: calculate_total_value(input: self.portfolio_data, field: "amount"))
                    }
                }
                readDB.get_admin_opportunities() { response in
                    if response == "Fetched all opportunities" {
                        self.admin_opportunity_data = readDB.admin_opportunity_data
                    }
                }
                readDB.get_user_opportunities() { response in
                    if response == "Fetched all opportunities" {
                        self.opportunity_data = readDB.user_opportunity_data
                        self.admin_opportunity_data = readDB.admin_opportunity_data
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
    }
    
}

// The content displayed to the user when no investment opportunities are listed
struct UserHomeError: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("☹️")
                        .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.3))
                        .padding(.bottom, -20)
                    
                    Text("No active opportunites")
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
        }
    }
}
