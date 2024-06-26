//
//  AdminPayoutForm.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

// This view is responsible for handling all form interactions when an admin wants to create payouts
struct AdminPayoutForm: View {
    @State var opportunity = ""
    @State var amount_offered = ""
    @State var revenue_generated = ""
    @State var payout_date = ""
    @State private var selectedOpportunity: DropdownMenuOption? = nil
    @Binding var opportunity_data : [DropdownMenuOption]
    @Binding var user_holdings_data : [[String: String]]
    @State private var date = Date()
    var date_range: ClosedRange<Date> = {
        var calendar = Calendar.current
        var startComponents = DateComponents(year: 2023, month: 11, day: 20)
        var endComponents = DateComponents(year: 2050, month: 12, day: 31)
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }()
    @State var admin_home_shown = false
    var valid_form_inputs: Bool { selectedOpportunity != nil && amount_offered.count>0 && revenue_generated.count>0 }
    @State var is_valid_input = true
    @State var isRevenueValid = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("Create Payout")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            .padding(.bottom, -5).padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                            .padding(.bottom, 5)
                        
                        Text("Opportunity").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.bottom, -5).padding(.leading,2.5)
                        
                        // Dropdown for admins to select which opportunity the payout should occur for
                        DropdownMenu(selected_option: self.$selectedOpportunity, placeholder: "Select", options: opportunity_data)
                            .frame(width: max(0, geometry.size.width - 45))
                            .padding(.leading,2.5)
                        
                        Text("Amount Offered (£)").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $amount_offered, prompt: Text("50000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                                .onChange(of: self.amount_offered, perform: { value in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        if self.amount_offered.count > 0 {
                                            if Int(self.amount_offered)! == 0 { is_valid_input = false }
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
                        
                        Text("Revenue Generated (past month)").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $revenue_generated, prompt: Text("750000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                                .onChange(of: self.revenue_generated, perform: { value in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        if self.revenue_generated.count > 0 {
                                            if Int(self.revenue_generated)! == 0 { isRevenueValid = false }
                                        } else { isRevenueValid = true }
                                    }
                                })
                        }
                        
                        if !isRevenueValid {
                            HStack {
                                Spacer()
                                Text("Amount should be greater than 0").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                            }
                        }
                        
                        Text("Payout Date").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        DatePicker("Select a Date", selection: $date, in: date_range, displayedComponents: [.date])
                            .padding([.horizontal, .top], 2.5)
                        
                        Spacer()
                        
                        Button(action: {
                            let components = selectedOpportunity!.option.components(separatedBy: "-")
                            if let opportunityID = Int((components.first?.trimmingCharacters(in: .whitespaces))!) {
                                var franchise = String(describing: components[1].trimmingCharacters(in: .whitespaces))
                                DispatchQueue.global(qos: .userInteractive).async {
                                    CreateDB().create_payout(franchise: franchise, revenue_generated: revenue_generated, opportunity_id: opportunityID, date_scheduled: String(describing: date), amount_offered: amount_offered, user_holdings: user_holdings_data) { response in
                                        if response == "Payout Created" {
                                            admin_home_shown.toggle()
                                        }
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Text("Submit")
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                            }
                            .frame(width: max(0, geometry.size.width-40), height: 55)
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
            .navigationDestination(isPresented: $admin_home_shown) {
                AdminHome().navigationBarBackButtonHidden(true)
            }
        }
    }
}
