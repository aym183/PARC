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
    @State var isInvestmentAmountValid: Bool = true
//    @Binding var user_invest_shown: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .leading) {
                    Text("Invest")
                        .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.065))
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
                        }
                        .accentColor(Color("Secondary"))
                    
                    HStack {
                        if annual_income_int >= 200000 {
                            Text("Annual Income: £\(annual_income_int)+")
                        } else {
                            Text("Annual Income: £\(annual_income_int)")
                        }
                    }
                    .font(Font.custom("Nunito-Medium", size: 18))
                        .padding(.top).padding(.bottom, -5)
                    
                    Slider(value: $annual_income, in: 20000...200000, step: 1000)
                        .onReceive([annual_income].publisher.first()) { value in
                            annual_income_int = Int(annual_income)
                            calculateInvestmentLimit()
                        }
                        .accentColor(Color("Secondary"))
                    
                    Text("Your investment limit")
                        .font(Font.custom("Nunito-Medium", size: 18))
                        .padding(.top).padding(.bottom, -5)
                    
                    // Create new method for function calculation
                    // Reference to investor.gov for calculation formula
                    
                    Text("£\(investment_limit)")
                        .font(Font.custom("Nunito-Bold", size: 25))
                        .padding(.bottom, -5)
                    
                    Text("Min investment")
                        .font(Font.custom("Nunito-Medium", size: 18))
                        .padding(.top).padding(.bottom, -5)
                    
                    Text("£100")
                        .font(Font.custom("Nunito-Bold", size: 25))
                        .padding(.bottom, -5)
                    
                    Text("Investment Amount(£)").font(Font.custom("Nunito-Bold", size: 18))
                        .padding(.top).padding(.bottom, -2.5)
                    
                    
                    // Replace with dropdown of all added franchise
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1.25)
                            )
                            .frame(width: max(0, geometry.size.width - 40), height: 50)
                        
                        TextField("", text: $investment_amount, prompt: Text("500").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                            .foregroundColor(.black)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
//                            .border(Color.black, width: 1)
                            .cornerRadius(5)
                            .font(Font.custom("Nunito-Bold", size: 16))
                            .keyboardType(.numberPad)
                            .onChange(of: investment_amount) { newValue in
                                withAnimation(.easeOut(duration: 0.2)) {
                                    validateInvestmentAmount()
                                }
                            }
                        
                    }
                    
                    if !isInvestmentAmountValid {
                        HStack {
                            Spacer()
                            Text("Invalid Amount").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                        }
                    }
                    
                    
                    Spacer()
                }
                .frame(width: max(0, geometry.size.width - 40))
                .padding(.top, 10)
                .foregroundColor(.black)
            }
        }
    }
    
    private func validateInvestmentAmount() {
        if Int(investment_amount)! >= min_investment && Int(investment_amount)! <= investment_limit {
            isInvestmentAmountValid = true
        } else {
            isInvestmentAmountValid = false
        }
    }
    
    private func calculateInvestmentLimit() -> Int {
        if net_worth_int >= investment_threshold && annual_income_int >= investment_threshold && annual_income_int > net_worth_int {
            investment_limit = 10*(annual_income_int/100)
        } else if  net_worth_int >= investment_threshold && annual_income_int >= investment_threshold && annual_income_int < net_worth_int {
            investment_limit = 10*(net_worth_int/100)
        } else if (net_worth_int < investment_threshold || annual_income_int < investment_threshold) && annual_income_int < net_worth_int {
            investment_limit = 5*(net_worth_int/100)
        } else if (net_worth_int < investment_threshold || annual_income_int < investment_threshold) && annual_income_int > net_worth_int {
            investment_limit = 5*(annual_income_int/100)
        } else {
            investment_limit = 0
        }
        return investment_limit
    }
}

#Preview {
    UserInvestPage()
}
