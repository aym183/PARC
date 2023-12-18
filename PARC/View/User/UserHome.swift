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
    @Binding var isShownHomePage: Bool
    @State var isShownOnboarding = false
    @AppStorage("first_name") var firstName: String = ""
    @AppStorage("picture") var picture: String = ""
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
                            
                            Text("Welcome \(firstName)").font(Font.custom("Avenir-ExtraBold", size: 30)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black).padding(.top, -5)
                            Text("Your PARC journey awaits 🥳").font(Font.custom("Avenir-Medium", size: 20)).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black)
                            
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
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("PARC").font(Font.custom("Nunito-Black", size: 60)).foregroundColor(Color("Secondary"))
                            Spacer()
                            
                            Button(action: {
//                                CreateDB().createUserPayout(opportunity_id: 2, user_holdings: readDB.full_user_holdings_data, amount_offered: "2000000", payout_id: 2)
                                account_shown.toggle()
                                 }) {
                                if imageURL != nil {
                                    URLImage(imageURL!) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                    }
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                            }
                            //                            }
                            //                        else {
                            //                                Button(action: { account_shown.toggle() }) {
                            //                                    Image(systemName: "person.crop.circle")
                            //                                        .resizable()
                            //                                        .frame(width: 50, height: 50)
                            //                                }
                            //                            }
                        }
                        
                        if selectedTab == .house {
                            Text("New Opportunities")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            if readDB.opportunity_data != [] && readDB.franchise_data != [] {
                                UserHomeContent(opportunity_data: $readDB.opportunity_data, franchise_data: $readDB.franchise_data, user_holdings_data: $readDB.user_holdings_data)
                            }
                        } else if selectedTab == .chartPie {
                            Text("Portfolio")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserPortfolio(portfolio_data: $portfolio_data, user_payouts_data: $user_payouts_data, payouts_chart_values: $payouts_chart_values, payouts_value: $payouts_value, holdings_value: $holdings_value, chart_values: $chart_values, opportunity_data: $opportunity_data)
                        } else {
                            Text("Secondary Market")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserMarketplace()
                        }
                        
                        
                        Spacer()
                        BottomNavBar(selectedTab: $selectedTab)
                        
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                    .foregroundColor(.black)
                    .onAppear {
//                        print(convertDate(dateString: String(describing: Date())))
//                        if "20/12/2023" >= convertDate(dateString: String(describing: Date())) {
//                            print(dateStringByAddingDays(days: 30, dateString: "20/12/2023"))
//                        } else {
//                            print(false)
//                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeOut(duration: 0.5)) {
//                                imageURL = URL(string: picture)!
                                isInvestmentConfirmed = false
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeOut(duration: 0.5)) {
//                                imageURL = URL(string: picture)!
                                isShownHomePage = false
                                if !onboarding_completed {
                                    isShownOnboarding.toggle()
                                }
                            }
                        }
                        readDB.franchise_data = []
                        readDB.opportunity_data = []
                        readDB.user_holdings_data = []
                        readDB.full_user_holdings_data = []
                        readDB.user_payout_data = []
                        readDB.trading_window_data = []
                        readDB.getFranchises()
                        readDB.getAllUserHoldings()
                        readDB.getTradingWindows()
                        readDB.getUserPayouts(email: email) { response in
                            if response == "Fetched user payouts" {
                                self.user_payouts_data = readDB.user_payout_data
                                self.payouts_value = calculateTotalValue(input: self.user_payouts_data, field: "amount_received")
                                self.payouts_chart_values = calculatePayoutOpportunities(input: self.user_payouts_data)
                            }
                        }
                        readDB.getUserHoldings(email: email) { response in
                            if response == "Fetched user holdings" {
                                self.portfolio_data = sortArrayByDate(inputArray: readDB.user_holdings_data)
                                self.holdings_value = calculateTotalValue(input: self.portfolio_data, field: "amount")
                                self.chart_values = calculatePortionHoldings(input: portfolio_data, holdings_value: calculateTotalValue(input: self.portfolio_data, field: "amount"))
                            }
                        }
                        readDB.getOpportunities() { response in
                            if response == "Fetched all opportunities" {
                                print("Fetched opportunities")
                                self.opportunity_data = readDB.opportunity_data
                            }
                        }
                        
                    }
                    .opacity(isInvestmentConfirmed ? 0 : 1)
                    .opacity(isShownHomePage ? 0 : 1)
                    
                }
                .navigationDestination(isPresented: $account_shown) {
                    UserAccount(imageURL: $imageURL, payoutsValue: $payouts_value)
                }
            }
            
            }
    }
}

struct UserHomeContent: View {
    var bg_images = ["store_live", "store_live_2"]
    var logo_images = ["McDonalds", "Starbucks"]
    var titles = ["McDonald's", "Starbucks"]
    @State var bg_image = ""
    @State var logo = ""
    @State var title = ""
    @State var progress = "90% - 12 days left"
    @State var min_investment_amount = "100"
    @State var target_raise = "£3,500,000"
    @State var opportunity_shown = false
    @Binding var opportunity_data: [[String: String]]
    @State var selected_opportunity: [String: String] = [:]
    @Binding var franchise_data: [[String: String]]
    @Binding var user_holdings_data: [[String: String]]

    
    var body: some View {
            GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(0..<opportunity_data.count, id: \.self) { index in
                            
                            Button(action: {
                                selected_opportunity = opportunity_data[index]
//                                bg_image = bg_images[index]
//                                logo = logo_images[index]
//                                title = titles[index]
                                opportunity_shown.toggle()
                            }) {
                                ZStack{
                                    Image(bg_images[0])
                                        .resizable()
                                        .frame(height: 250)
                                        .cornerRadius(5)
                                    
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
                                                    Image(logo_images[0])
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 40, height: 30)
                                                        .padding(.top, 10).padding(.leading, 5)
                                                    
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
                                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.024))
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
                                                                .font(Font.custom("Nunito-Bold", size: 8))
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
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.024))
                                                        .foregroundColor(Color("Custom_Gray"))
                                                        .frame(alignment: .leading)
                                                    Spacer()
                                                    Text("£\(String(describing: formattedNumber(input_number:Int(opportunity_data[index]["asking_price"]!)!)))")
                                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.024))
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
                    }
                    .frame(width: max(0, geometry.size.width))
                    .navigationDestination(isPresented: $opportunity_shown) {
                        UserOpportunityClick(opportunity_data: $selected_opportunity, franchise_data: $franchise_data)
                    }
            }
    }
    
}

//
//struct UserHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserHome(isInvestmentConfirmed: .constant(false), isShownHomePage: .constant(false))
//    }
//}
