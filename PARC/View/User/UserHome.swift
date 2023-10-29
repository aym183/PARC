//
//  UserHomeView.swift
//  PARC
//
//  Created by Ayman Ali on 18/10/2023.
//

import SwiftUI

struct UserHome: View {
    @State var selectedTab: Tab = .house
    @State var account_shown = false
    @Binding var isInvestmentConfirmed: Bool
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    Color(.white).ignoresSafeArea()
                    
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
                            Button(action: { account_shown.toggle() }) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        
                        if selectedTab == .house {
                            Text("New Opportunities")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserHomeContent()
                        } else if selectedTab == .chartPie {
                            Text("Portfolio")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                                .padding(.bottom, -5)
                            Divider()
                                .frame(height: 1)
                                .overlay(.black)
                            
                            UserPortfolio()
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                isInvestmentConfirmed = false
                            }
                        }
                    }
                    .opacity(isInvestmentConfirmed ? 0 : 1)
                    
                }
                .navigationDestination(isPresented: $account_shown) {
                    UserAccount()
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
    
    var body: some View {
            GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false){
                        ForEach(0..<2, id: \.self) {index in
                            
                            Button(action: {
                                print("You clicked \(titles[index])")
                                bg_image = bg_images[index]
                                logo = logo_images[index]
                                title = titles[index]
                                opportunity_shown.toggle()
                            }) {
                                ZStack{
                                    Image(bg_images[index])
                                        .resizable()
                                        .frame(height: 250)
                                        .cornerRadius(5)
                                    
                                    Rectangle()
                                        .stroke(Color.gray, lineWidth: 2)
                                        .frame(height: 250)
                                        .cornerRadius(2.5)
                                    
                                    VStack {
                                        Spacer()
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(.white)
                                                .frame(height: 150)
                                                .border(.gray, width: 1)
                                            
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Image(logo_images[index])
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 40, height: 30)
                                                        .padding(.top, 10).padding(.leading, 5)
                                                    
                                                    Text(titles[index])
                                                        .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                                        .foregroundColor(.black)
                                                        .padding(.top, 10).padding(.leading, -5)
                                                    
                                                    Spacer()
                                                }
                                                
                                                Text("A golden opportunity for those seeking a turnkey, globally renowned business in the fast-food industry, backed by a proven system of success and ongoing support.")
                                                    .foregroundColor(Color("Custom_Gray"))
                                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.030))
                                                    .frame(height: 50)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.horizontal, 12).padding(.top, -12)
                                                
                                                HStack {
                                                    Text(progress)
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
                                                            Text("London")
                                                                .font(Font.custom("Nunito-Bold", size: 8))
                                                                .foregroundColor(Color("Custom_Gray"))
                                                                .padding(.leading, -7.5)
                                                        }
                                                    }
                                                }
                                                .padding(.horizontal,12)
                                                .padding(.top, -3)
                                                
                                                ZStack {
                                                    Rectangle()
                                                        .foregroundColor(.clear)
                                                        .frame(width: max(0, geometry.size.width - 22), height: 8)
                                                        .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6))
                                                        .cornerRadius(100)
                                                        .padding(.leading, 11)
                                                    
                                                    HStack {
                                                        Rectangle()
                                                            .foregroundColor(.clear)
                                                            .frame(width: max(0, geometry.size.width - 200), height: 8)
                                                            .background(Color("Secondary"))
                                                            .cornerRadius(100)
                                                        
                                                        Spacer()
                                                    }
                                                    .frame(width: max(0, geometry.size.width - 105))
                                                    .padding(.leading, -70)
                                                    
                                                    
                                                }
                                                .padding(.top, -5)
                                                
                                                HStack {
                                                    Text("Minimum Investment Amount - £\(min_investment_amount)")
                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.024))
                                                        .foregroundColor(Color("Custom_Gray"))
                                                        .frame(alignment: .leading)
                                                    Spacer()
                                                    
                                                    Text(target_raise)
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
                            }
                            .id(index)
                        }
                    }
                    .frame(width: max(0, geometry.size.width))
                    .navigationDestination(isPresented: $opportunity_shown) {
                        UserOpportunity(bg_image: $bg_image, logo: $logo, title: $title, progress: $progress, min_investment_amount: $min_investment_amount, target_raise: $target_raise)
                    }
            }
    }
}
//
//struct UserHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserHome()
//    }
//}
