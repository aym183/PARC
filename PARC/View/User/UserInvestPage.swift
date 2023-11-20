//
//  UserInvestPage.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

struct UserInvestPage: View {
    
    // Slider code chatGPT and YT
    
    @State var investment_amount = ""
    @State var net_worth: Double = 0
    @State var net_worth_int: Int = 0
    @State var annual_income: Double = 0
    @State var annual_income_int: Int = 0
    @State var investment_threshold = 102000
    @State var investment_limit = 0
    @State var min_investment = 100
    @State var isInvestmentAmountValid: Bool = false
    @State var home_page_shown = false
    @State var isInvestmentConfirmed = true
    @State var user_ready_to_invest = false
    @State var isShownHomePage = false
    @Binding var user_invest_shown: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Invest")
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                        .padding(.bottom, -5)
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(.black)
                    
                    
                    HStack {
                        if net_worth_int >= 1000000 {
                            Text("Net Worth: £\(net_worth_int)+")
                        } else {
                            Text("Net Worth: £\(net_worth_int)")
                        }
                    }
                    .font(Font.custom("Nunito-Medium", size: 18))
                    .padding(.top).padding(.bottom, -5)
                    
                    Slider(value: $net_worth, in: 10000...1000000, step: 1000)
                        .onReceive([net_worth].publisher.first()) { value in
                            net_worth_int = Int(net_worth)
                            calculateInvestmentLimit()
                            withAnimation(.easeOut(duration: 0.2)) {
                                user_ready_to_invest = true
                            }
                        }
                        .accentColor(Color("Secondary"))
                    
//                    HStack {
//                        if annual_income_int >= 200000 {
//                            Text("Annual Income: £\(annual_income_int)+")
//                        } else {
//                            Text("Annual Income: £\(annual_income_int)")
//                        }
//                    }
//                    .font(Font.custom("Nunito-Medium", size: 18))
//                    .padding(.top, 10).padding(.bottom, -5)
//                    
//                    Slider(value: $annual_income, in: 20000...200000, step: 1000)
//                        .onReceive([annual_income].publisher.first()) { value in
//                            annual_income_int = Int(annual_income)
//                            calculateInvestmentLimit()
//                            withAnimation(.easeOut(duration: 0.2)) {
//                                user_ready_to_invest = true
//                            }
//                        }
//                        .accentColor(Color("Secondary"))
//                    
                    Divider()
                        .overlay(Color("Custom_Gray"))
                        .opacity(0.5)
                        .frame(height: 1)
                        .padding(.top, 5)
                        .padding(.bottom, -7.5)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Your investment limit")
                                .font(Font.custom("Nunito-Medium", size: 18))
                                .padding(.top).padding(.bottom, -5)
                            
                            // Reference to investor.gov for calculation formula
                            
                            Text("£\(investment_limit)")
                                .font(Font.custom("Nunito-Bold", size: 25))
                                .padding(.bottom, -5)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Min investment")
                                .font(Font.custom("Nunito-Medium", size: 18))
                                .padding(.top).padding(.bottom, -5)
                            
                            Text("£100")
                                .font(Font.custom("Nunito-Bold", size: 25))
                                .padding(.bottom, -5)
                        }
                        .padding(.leading)
                    }
                    
                    Divider()
                        .overlay(Color("Custom_Gray"))
                        .opacity(0.5)
                        .frame(height: 1)
                        .padding(.top, 7.5)
                        .padding(.bottom, -7.5)
                    
                    if investment_limit > 0 {
                        Text("Investment Amount (£)").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top).padding(.bottom, -2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 40), height: 50)
                                .opacity(0.5)
                            
                            TextField("", text: $investment_amount, prompt: Text("500").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .cornerRadius(5)
                                .font(Font.custom("Nunito-Bold", size: 16))
                                .onChange(of: investment_amount) {
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            validateInvestmentAmount()
                                        }
                                }
                                .keyboardType(.numberPad)
                            
                            // Add disable check for investment amount
                        }
                    }
                    
                    if !isInvestmentAmountValid && investment_amount != "" {
                        HStack {
                            Spacer()
                            Text("Invalid Amount").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                        }
                    }
                    
                    Spacer()
                    Button(action: { home_page_shown.toggle() }) {
                        HStack {
                            Text("Confirm Investment")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                        }
                        .frame(width: max(0, geometry.size.width-40), height: 55)
                        .background(Color("Secondary"))
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                        .padding(.bottom)
                    }
                    .disabled(isInvestmentAmountValid ? false : true)
                    .opacity(isInvestmentAmountValid ? 1 : 0.75)
                }
                .frame(height: max(0, geometry.size.height - 20))
                .padding(.horizontal, 5)
                    
            }
                .padding(.top, 10)
                .foregroundColor(.black)
                .frame(width: max(0, geometry.size.width - 40))
            }
            .navigationDestination(isPresented: $home_page_shown) {
                UserHome(isInvestmentConfirmed: $isInvestmentConfirmed, isShownHomePage: $isShownHomePage).navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func validateInvestmentAmount() {
        if investment_amount != "" && (Int(investment_amount)! >= min_investment && Int(investment_amount)! <= investment_limit) {
            isInvestmentAmountValid = true
        } else {
            isInvestmentAmountValid = false
        }
    }
    
    private func calculateInvestmentLimit() {
        investment_limit = 10*(net_worth_int/100)
    }
}

//#Preview {
//    UserInvestPage()
//}
