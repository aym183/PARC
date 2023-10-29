//
//  AdminOpportunityForm.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

struct AdminOpportunityForm: View {
    @State var franchise = ""
    @State var location = ""
    @State var asking_price = ""
    @State var equity_offered = ""
    @State var min_investment_amount = ""
    @State var opportunity_close_date = ""
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("Create Opportunity")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            .padding(.bottom, -5).padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                            .padding(.bottom, 5)
                        
                        Text("Franchise").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.bottom, -5).padding(.leading,2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $franchise).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                            //                            .border(Color.black, width: 1)
                                .cornerRadius(5)
                                .font(Font.custom("Nunito-Bold", size: 16))
                            
                            
                        }
                        
                        Text("Location").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $location, prompt: Text("Stratford, London").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-Bold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        Text("Asking Price (£)").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $asking_price, prompt: Text("1500000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-Bold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        Text("Equity Offered (%)").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $equity_offered, prompt: Text("80").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-Bold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        Text("Minimum Investment Amount (£)").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $min_investment_amount, prompt: Text("150").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-Bold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        Text("Opportunity Close Date").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $opportunity_close_date, prompt: Text("25/11/2023").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-Bold", size: 16))
                                .keyboardType(.numberPad)
                            
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            HStack {
                                Text("Submit")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                            }
                            .frame(width: max(0, geometry.size.width-45), height: 55)
                            .background(Color("Secondary"))
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                            .padding(.bottom)
                        }
                        
                        
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height))
                    .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    AdminOpportunityForm()
}
