//
//  UserHomeView.swift
//  PARC
//
//  Created by Ayman Ali on 18/10/2023.
//

import SwiftUI
import URLImage

struct UserHome: View {
    @State var selectedTab: Tab = .house
    @State var account_shown = false
    @Binding var isInvestmentConfirmed: Bool
    @Binding var isWithdrawalConfirmed: Bool
    @Binding var isShownHomePage: Bool
    @State var isShownOnboarding = false
    @AppStorage("first_name") var firstName: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("onboarding_completed") var onboarding_completed: Bool = false
    @State var imageURL = URL(string: "")
    @ObservedObject var readDB = ReadDB()
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
    
    var body: some View {
        GeometryReader { geometry in
            if isShownOnboarding {
                UserOnboarding(isShownOnboarding: $isShownOnboarding)
            } else {
                ZStack {
                    Color(.white).ignoresSafeArea()
                    
                    if isShownHomePage {
                        VStack(alignment: .center) {
                            Spacer()
                            LottieView(name: "loading_3.0", speed: 1, loop: false).frame(width: 100, height: 100)
                            Text("Welcome \(firstName)").font(Font.custom("Nunito-ExtraBold", size: 30)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black).padding(.top, -5)
                            Text("Your PARC journey awaits 🥳").font(Font.custom("Nunito-Medium", size: 20)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black)
                            Spacer()
                        }
                        .foregroundColor(.black).frame(width: max(0, geometry.size.width))
                    }
                    
                    if isInvestmentConfirmed {
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
                    
                    if isWithdrawalConfirmed {
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
                        
                        if selectedTab == .house {
                            Text("New Opportunities")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserHomeContent(opportunity_data: $readDB.user_opportunity_data, franchise_data: $readDB.franchise_data, user_holdings_data: $readDB.user_holdings_data, readDB: readDB, email: $email, portfolio_data: $portfolio_data, transformed_payouts_data: $transformed_payouts_data, user_payouts_data: $user_payouts_data, payouts_value: $payouts_value, payouts_chart_values: $payouts_chart_values, admin_opportunity_data: $admin_opportunity_data, holdings_value: $holdings_value, chart_values: $chart_values)
                            
                        } else if selectedTab == .chartPie {
                            Text("Portfolio")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserPortfolio(portfolio_data: $portfolio_data, franchise_data: $readDB.franchise_data, user_payouts_data: $user_payouts_data, payouts_chart_values: $payouts_chart_values, payouts_value: $payouts_value, holdings_value: $holdings_value, chart_values: $chart_values, opportunity_data: $readDB.admin_opportunity_data)
                        } else {
                            Text("Secondary Market")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserMarketplace(franchise_data: $readDB.franchise_data_dropdown, holding_data: $readDB.user_holdings_data_dropdown, listed_shares: $readDB.secondary_market_data, secondary_shares: $readDB.listed_shares, transformed_payouts_data: $transformed_payouts_data, franchises: $readDB.franchise_data)
                        }
                        
                        
                        Spacer()
                        BottomNavBar(selectedTab: $selectedTab)
                        
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                    .foregroundColor(.black)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                isShownHomePage = false
                                isInvestmentConfirmed = false
                                isWithdrawalConfirmed = false
                                if !onboarding_completed {
                                    isShownOnboarding.toggle()
                                }
                            }
                        }
                        loadProfileImage() { response in
                            if response != nil {
                                profile_image = response!
                                init_profile_image = response!
                            }
                        }
                        readDB.user_holdings_data_dropdown = []
                        readDB.listed_shares = [:]
                        readDB.franchise_data_dropdown = []
                        readDB.franchise_data = []
                        readDB.user_opportunity_data = []
                        readDB.admin_opportunity_data = []
                        readDB.user_holdings_data = []
                        readDB.full_user_holdings_data = []
                        readDB.user_payout_data = []
                        readDB.sold_shares = []
                        readDB.trading_window_data = []
                        readDB.payout_data = []
                        readDB.secondary_market_transactions_ind = 0
                        readDB.getFranchises()
                        readDB.getAllUserHoldings()
                        readDB.getTradingWindows()
                        readDB.getTradingWindowTransactionsEmail()
                        readDB.getPayouts() { response in
                            if response == "Fetched payouts" {
                                self.transformed_payouts_data = transformPayouts(payouts_array: readDB.payout_data)
                            }
                        }
                        readDB.getUserPayouts(email: email) { response in
                            if response == "Fetched user payouts" {
                                self.user_payouts_data = readDB.user_payout_data
                                self.payouts_value = calculateTotalValue(input: self.user_payouts_data, field: "amount_received")
                                self.payouts_chart_values = calculatePayoutOpportunities(input: self.user_payouts_data)
                            }
                        }
                        readDB.getUserHoldings(email: email) { response in
                            if response == "Fetched user holdings" {
                                self.portfolio_data = readDB.user_holdings_data
                                self.holdings_value = calculateTotalValue(input: self.portfolio_data, field: "amount")
                                self.chart_values = calculatePortionHoldings(input: portfolio_data, holdings_value: calculateTotalValue(input: self.portfolio_data, field: "amount"))
                            }
                        }
                        readDB.getAdminOpportunities() { response in
                            if response == "Fetched all opportunities" {
                                self.admin_opportunity_data = readDB.admin_opportunity_data
                            }
                        }
                        readDB.getUserOpportunities() { response in
                            if response == "Fetched all opportunities" {
                                self.opportunity_data = readDB.user_opportunity_data
                                self.admin_opportunity_data = readDB.admin_opportunity_data
                            }
                        }

                    }
                    .opacity(isInvestmentConfirmed ? 0 : 1)
                    .opacity(isShownHomePage ? 0 : 1)
                    .opacity(isWithdrawalConfirmed ? 0 : 1)
                }
                .navigationDestination(isPresented: $account_shown) {
                    UserAccount(payoutsValue: $payouts_value, secondaryTransactionsValue: $readDB.secondary_market_transactions_ind, profile_image: $profile_image, init_profile_image: $init_profile_image, user_holdings: $readDB.user_holdings_data, user_holdings_sold: $readDB.sold_shares)
                }
            }
            
        }
    }
}

struct UserHomeContent: View {
    var bg_images = ["store_live", "store_live_2"]
    var logo_images = ["McDonalds", "Starbucks"]
    @State var opportunity_shown = false
    @Binding var opportunity_data: [[String: String]]
    @State var selected_opportunity: [String: String] = [:]
    @State var selected_franchise: [String: String] = [:]
    @State var franchise_logo: UIImage?
    @State var display_image: UIImage?
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
    @State var isRefreshing = false
    @State private var counter = 2
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                
                if (isRefreshing == true) {
                    VStack(alignment: .center) {
                        Spacer()
                        LottieView(name: "loading_3.0", speed: 1, loop: false).frame(width: 75, height: 75)
                        Text("Loading...").font(Font.custom("Nunito-SemiBold", size: 20)).multilineTextAlignment(.center).foregroundColor(.black).padding(.top, -5)
                        Spacer()
                    }
                    .frame(width: max(0, geometry.size.width))
                } else if (opportunity_data.count != 0 && franchise_data.count != 0) {
                    ForEach(0..<opportunity_data.count, id: \.self) { index in
                        Button(action: {
                            selected_franchise = franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data[index]["franchise"]!})!]
                            selected_opportunity = opportunity_data[index]
                            franchise_logo = loadDisplayImage(key: franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data[index]["franchise"]!})!]["logo"]!)
                            display_image = loadDisplayImage(key: franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data[index]["franchise"]!})!]["display_image"]!)
                            opportunity_shown.toggle()
                        }) {
                            ZStack{
                                if let franchiseName = opportunity_data[index]["franchise"] {
                                    if let franchiseIndex = franchise_data.firstIndex(where: { $0["name"] == franchiseName }) {
                                        let matchedFranchise = readDB.franchise_data[franchiseIndex]["display_image"]!
                                        
                                        if UserDefaults.standard.object(forKey: String(describing: matchedFranchise)) != nil {
                                            Image(uiImage: loadDisplayImage(key: String(describing: matchedFranchise)))
                                                .resizable()
                                                .frame(height: 250)
                                                .cornerRadius(5)
                                        } else {
                                            Image(systemName: bg_images[0])
                                                .resizable()
                                                .frame(height: 250)
                                                .cornerRadius(5)
                                        }
                                        
                                    } else {
                                        Image(systemName: bg_images[0])
                                            .resizable()
                                            .frame(height: 250)
                                            .cornerRadius(5)
                                    }
                                }
                                
                                Rectangle()
                                    .opacity(0)
                                    .frame(height: 250)
                                    .cornerRadius(2.5)
                                    .border(.gray, width: 1)
                                
                                VStack {
                                    Spacer()
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(.white)
                                            .frame(height: 150)
                                            .border(.gray, width: 1)
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                
                                                if let franchiseName = opportunity_data[index]["franchise"] {
                                                    if let franchiseIndex = franchise_data.firstIndex(where: { $0["name"] == franchiseName }) {
                                                        let matchedFranchise = readDB.franchise_data[franchiseIndex]["logo"]!
                                                        
                                                        if UserDefaults.standard.object(forKey: String(describing: matchedFranchise)) != nil {
                                                            Image(uiImage: loadDisplayImage(key: String(describing: matchedFranchise)))
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
                                            }
                                            .padding(.leading, -2.5)
                                            
                                            Text(franchise_data[franchise_data.firstIndex(where: { $0["name"] == opportunity_data[index]["franchise"]!})!]["description"]!)
                                                .foregroundColor(Color("Custom_Gray"))
                                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.030))
                                                .frame(height: 50)
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, 12).padding(.top, -12)
                                            
                                            HStack {
                                                Text("\(String(describing: Int(Double(opportunity_data[index]["ratio"]!)!*100)))% - \(getDaysRemaining(dateString: String(describing: opportunity_data[index]["close_date"]!))!) days left")
                                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.024))
                                                    .foregroundColor(Color("Custom_Gray"))
                                                    .frame(alignment: .leading)
                                                Spacer()
                                                
                                                ZStack {
                                                    Rectangle()
                                                        .foregroundColor(.clear)
                                                        .frame(width: 45, height: 14)
                                                        .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.5))
                                                        .cornerRadius(5)
                                                    
                                                    HStack {
                                                        Image("gbr").resizable().frame(width: 10, height: 10)
                                                        Text(String(describing: opportunity_data[index]["location"]!))
                                                            .font(Font.custom("Nunito-SemiBold", size: 8))
                                                            .foregroundColor(Color("Custom_Gray"))
                                                            .padding(.leading, -7.5)
                                                    }
                                                }
                                            }
                                            .padding(.horizontal,12)
                                            .padding(.top, -3)
                                            
                                            ProgressView(value: Double(opportunity_data[index]["ratio"]!))
                                                .tint(Color("Secondary"))
                                                .scaleEffect(x: 1, y: 2, anchor: .center)
                                                .padding(.horizontal, 11).padding(.top, -1)
                                            
                                            HStack {
                                                Text("Minimum Investment Amount - £\(opportunity_data[index]["min_invest_amount"]!)")
                                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.024))
                                                    .foregroundColor(Color("Custom_Gray"))
                                                    .frame(alignment: .leading)
                                                Spacer()
                                                Text("Target - £\(String(describing: formattedNumber(input_number:Int(opportunity_data[index]["asking_price"]!)!)))")
                                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.024))
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
                withAnimation(.easeOut(duration: 0.25)) {
                    isRefreshing = true
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
                readDB.getFranchises()
                readDB.getAllUserHoldings()
                readDB.getTradingWindows()
                readDB.getTradingWindowTransactionsEmail()
                readDB.getPayouts() { response in
                    if response == "Fetched payouts" {
                        self.transformed_payouts_data = transformPayouts(payouts_array: readDB.payout_data)
                    }
                }
                readDB.getUserPayouts(email: email) { response in
                    if response == "Fetched user payouts" {
                        self.user_payouts_data = readDB.user_payout_data
                        self.payouts_value = calculateTotalValue(input: self.user_payouts_data, field: "amount_received")
                        self.payouts_chart_values = calculatePayoutOpportunities(input: self.user_payouts_data)
                    }
                }
                readDB.getUserHoldings(email: email) { response in
                    if response == "Fetched user holdings" {
                        self.portfolio_data = sortArrayByDate(inputArray: readDB.user_holdings_data, field_name: "transaction_date", date_type: "yyyy-MM-dd")
                        self.holdings_value = calculateTotalValue(input: self.portfolio_data, field: "amount")
                        self.chart_values = calculatePortionHoldings(input: portfolio_data, holdings_value: calculateTotalValue(input: self.portfolio_data, field: "amount"))
                    }
                }
                readDB.getAdminOpportunities() { response in
                    if response == "Fetched all opportunities" {
                        self.admin_opportunity_data = readDB.admin_opportunity_data
                    }
                }
                readDB.getUserOpportunities() { response in
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
                            isRefreshing = false
                        }
                        timer.invalidate()
                    }
                }
            }
        }
    }
    
}

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
