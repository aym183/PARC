//
//  AdminOpportunityTradingForm.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

// This view is responsible for handling all form interactions when an admin wants to create secondary market windows
struct AdminTradingForm: View {
    @State var start_date = Date()
    @State var end_date = Date()
    @State var duration = ""
    @State var admin_home_shown = false
    let date_range: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2023, month: 11, day: 1)
        let endComponents = DateComponents(year: 2050, month: 12, day: 31)
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }()
    var valid_form_inputs: Bool {
        duration.count>0
    }
    @State var is_valid_input = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("Create Trading Window")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                            .padding(.bottom, -5).padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                            .padding(.bottom, 5)
                        
                        Text("Start Date").font(Font.custom("Nunito-Bold", size: 18))
                            .padding(.bottom, -5).padding(.leading,2.5)
                        
                        DatePicker("Select a Date", selection: $start_date, in: date_range, displayedComponents: [.date])
                            .padding([.horizontal, .top], 2)
                        
                        HStack(spacing: 5) {
                            Text("Duration").font(Font.custom("Nunito-Bold", size: 18))
                            Text("(in days)").font(Font.custom("Nunito-SemiBold", size: 15))
                        }
                        .padding(.top, 10).padding(.bottom, -5).padding(.leading,2.5)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: max(0, geometry.size.width - 45), height: 50)
                            
                            TextField("", text: $duration, prompt: Text("30").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .keyboardType(.numberPad)
                                .onChange(of: self.duration, perform: { value in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        if self.duration.count > 0 {
                                            if Int(self.duration)! == 0 { is_valid_input = false }
                                            else if Int(self.duration)! > 60 { is_valid_input = false }
                                        } else { is_valid_input = true }
                                    }
                                })
                        }
                        
                        if !is_valid_input {
                            HStack {
                                Spacer()
                                Text("Amount should be between 0 and 60").foregroundColor(.red).font(Font.custom("Nunito-Medium", size: min(geometry.size.width, geometry.size.height) * 0.035)).fontWeight(.bold)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            CreateDB().create_trading_window(start_date: String(describing: start_date), duration: duration, status: "Scheduled") { response in
                                if response == "Trading Window Created" {
                                    admin_home_shown.toggle()
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

#Preview {
    AdminTradingForm()
}
