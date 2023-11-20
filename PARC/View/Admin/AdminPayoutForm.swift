//
//  AdminPayoutForm.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

struct AdminPayoutForm: View {
    @State var opportunity = ""
    @State var amount_offered = ""
    @State var revenue_generated = ""
    @State var payout_date = ""
    @State private var selectedOpportunity: DropdownMenuOption? = nil
    @Binding var opportunity_data : [DropdownMenuOption]
    @State private var date = Date()
//    @State private var selectedDate = Date()
    var dateRange: ClosedRange<Date> = {
        var calendar = Calendar.current
        var startComponents = DateComponents(year: 2023, month: 11, day: 20)
        var endComponents = DateComponents(year: 2050, month: 12, day: 31)
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
                        Text("Create Payout")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            .padding(.bottom, -5).padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                            .padding(.bottom, 5)
                        
                        // Change to dropdown
                        Text("Opportunity").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.bottom, -5).padding(.leading,2.5)
                        
                        DropdownMenu(selectedOption: self.$selectedOpportunity, placeholder: "Select", options: opportunity_data)
                            .frame(width: max(0, geometry.size.width - 45))
                            .padding(.leading,2.5)
                        
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 5)
//                                .fill(Color.white)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .stroke(Color.black, lineWidth: 1.25)
//                                )
//                                .frame(width: max(0, geometry.size.width - 45), height: 50)
//                            
//                            TextField("", text: $opportunity).padding().frame(width: max(0, geometry.size.width-40), height: 50)
//                                .foregroundColor(.black)
//                                .autocorrectionDisabled(true)
//                                .autocapitalization(.none)
//                            //                            .border(Color.black, width: 1)
//                                .cornerRadius(5)
//                                .font(Font.custom("Nunito-Bold", size: 16))
//                            
//                            
//                        }
                        
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
                                .font(Font.custom("Nunito-Bold", size: 16))
                                .keyboardType(.numberPad)
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
                                .font(Font.custom("Nunito-Bold", size: 16))
                                .keyboardType(.numberPad)
                        }
                        
                        Text("Payout Date").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        DatePicker("Select a Date", selection: $date, in: dateRange, displayedComponents: [.date])
                            .padding([.horizontal, .top], 2.5)
                        
                        Spacer()
                        
                        Button(action: {
                            print(selectedOpportunity!.option)
                            print(amount_offered)
                            print(revenue_generated)
                            print(date)
                            
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
                        
                        
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height))
                    .foregroundColor(.black)
                }
            }
    }
    }
}

#Preview {
    AdminPayoutForm(opportunity_data: .constant([]))
}
