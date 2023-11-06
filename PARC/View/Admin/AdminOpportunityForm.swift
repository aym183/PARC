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
    @State private var date = Date()
//    @State private var selectedDate = Date()
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2023, month: 11, day: 1)
        let endComponents = DateComponents(year: 2050, month: 12, day: 31)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
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
                        
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black, lineWidth: 1.25)
                                    )
                                    .frame(width: max(0, geometry.size.width - 125), height: 50)
                                
                                TextField("", text: $franchise).padding().frame(width: max(0, geometry.size.width-120), height: 50)
                                    .foregroundColor(.black)
                                    .cornerRadius(5)
                                    .font(Font.custom("Nunito-Bold", size: 16))
                            }
                            
                            Button(action: {}) {
                                ZStack {
                                    Circle()
                                        .fill(Color("Secondary"))
                                        .frame(width: 30, height: 30)
                                    
                                    Image(systemName: "plus")
                                        .font(Font.custom("Nunito-Black", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.top, 0.5)
                        
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
                                .font(Font.custom("Nunito-Bold", size: 16))
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
                                .font(Font.custom("Nunito-Bold", size: 16))
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
                        }
                        
                        Text("Opportunity Close Date").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 5)
//                                .fill(Color.white)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .stroke(Color.black, lineWidth: 1.25)
//                                )
//                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
//                            TextField("", text: $opportunity_close_date, prompt: Text("25/11/2023").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
//                                .foregroundColor(.black)
//                                .autocorrectionDisabled(true)
//                                .autocapitalization(.none)
//                                .font(Font.custom("Nunito-Bold", size: 16))
                            
                            DatePicker("Select a Date", selection: $date, in: dateRange, displayedComponents: [.date])
                            .padding([.horizontal, .top], 2)
//                                            .datePickerStyle(GraphicalDatePickerStyle())
//                                            .labelsHidden()
                            
//                        }
                        
                        Spacer()
                        
                        Button(action: {
                            print(franchise)
                            print(location)
                            print(asking_price)
                            print(equity_offered)
                            print(min_investment_amount)
                            print(date)
                        }) {
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
