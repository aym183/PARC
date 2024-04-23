//
//  AdminOpportunityForm.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

// This view is responsible for handling all form interactions when an admin wants to create an opportunity
struct AdminOpportunityForm: View {
    @Binding var franchise_data: [DropdownMenuOption]
    @State var franchise = ""
    @State var location = ""
    @State var asking_price = ""
    @State var equity_offered = ""
    @State var min_investment_amount = ""
    @State var opportunity_close_date = ""
    @State var franchise_form_shown = false
    @State var admin_home_shown = false
    @State private var selected_franchise: DropdownMenuOption? = nil
    @State private var date = Date()
    let date_range: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2024, month: 05, day: 1)
        let endComponents = DateComponents(year: 2050, month: 12, day: 31)
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }()
    var valid_form_inputs: Bool {
        selected_franchise != nil && location.count>0 && asking_price.count>0 && equity_offered.count>0 && min_investment_amount.count>0
    }
    @State var is_valid_input = true
    @State var is_equity_valid = true
    @State var is_min_invest_valid = true
    
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
                        
                        HStack(spacing: 15) {
                            
                            DropdownMenu(selected_option: self.$selected_franchise, placeholder: "Select", options: franchise_data)
                                .frame(width: max(0, geometry.size.width - 100))
                            
                            Button(action: { franchise_form_shown.toggle() }) {
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
                        .padding(.top, 0.5).padding(.leading, 2.5)
                        
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
                            
                            TextField("", text: $location, prompt: Text("London").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
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
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                                .onChange(of: self.asking_price, perform: { value in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        if self.asking_price.count > 0 {
                                            if Int(self.asking_price)! == 0 { is_valid_input = false }
                                        } else { is_valid_input = true }
                                    }
                                })
                        }
                        
                        if !is_valid_input {
                            HStack {
                                Spacer()
                                Text("Amount should be greater than 0").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                            }
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
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                                .onChange(of: self.equity_offered, perform: { value in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        if self.equity_offered.count > 0 {
                                            if Int(self.equity_offered)! == 0 { is_equity_valid = false }
                                            else if Int(self.equity_offered)! > 100 { is_equity_valid = false }
                                        } else { is_equity_valid = true }
                                    }
                                })
                        }
                        
                        if !is_equity_valid {
                            HStack {
                                Spacer()
                                Text("Amount should be between 0 and 100").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                            }
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
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                                .onChange(of: self.min_investment_amount, perform: { value in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        if self.min_investment_amount.count > 0 {
                                            if Int(self.min_investment_amount)! == 0 { is_min_invest_valid = false }
                                        } else { is_min_invest_valid = true }
                                    }
                                })
                        }
                        
                        if !is_min_invest_valid {
                            HStack {
                                Spacer()
                                Text("Amount should be greater than 0").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                            }
                        }
                        
                        Text("Opportunity Close Date").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        DatePicker("Select a Date", selection: $date, in: date_range, displayedComponents: [.date])
                            .padding([.horizontal, .top], 2)
                        
                        Spacer()
                        
                        Button(action: {
                            DispatchQueue.global(qos: .userInteractive).async {
                                CreateDB().create_opportunity(franchise_name: selected_franchise!.option, location: location, asking_price: asking_price, equity_offered: equity_offered, min_invest_amount: min_investment_amount, close_date: String(describing: date)) { response in
                                    if response == "Opportunity Created" {
                                        admin_home_shown.toggle()
                                    }
                                }
                            }
                            
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
                        .disabled(valid_form_inputs ? false : true)
                        .opacity(valid_form_inputs ? 1 : 0.75)
                        
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height))
                    .foregroundColor(.black)
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .sheet(isPresented: $franchise_form_shown) {
                AdminFranchiseForm(franchise_form_shown: $franchise_form_shown, franchise_data: $franchise_data).presentationDetents([.height(750)])
            }
            .navigationDestination(isPresented: $admin_home_shown) {
                AdminHome().navigationBarBackButtonHidden(true)
            }
        }
    }
}

