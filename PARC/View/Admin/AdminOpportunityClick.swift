//
//  AdminOpportunity Click.swift
//  PARC
//
//  Created by Ayman Ali on 29/10/2023.
//

import SwiftUI

struct AdminOpportunityClick: View {
    var data_titles = ["Opportunity ID", "Location", "Type", "Money Raised", "Target Raised", "Investors", "Minimum Investment", "Investment Deadline"]
    var data_values = ["24", "Stratford, London", "Equity", "£400,000", "£1,000,000", "500", "£100", "18/08/2023"]
    @Binding var opportunity_logo: UIImage?
    @Binding var opportunity_data: [String:String]
    @State var admin_home_shown = false
    @State var showingDeleteAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack(spacing: 20) {
                            Image(uiImage: opportunity_logo!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                            
                            Text(String(describing: opportunity_data["franchise"]!))
                                .font(Font.custom("Nunito-Bold", size: 30))
                        }
                        
                        if opportunity_data["status"]! == "Active" {
                            
                            Button(action: { showingDeleteAlert.toggle() }) {
                                HStack {
                                    Text("Close Opportunity")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.038))
                                }
                                .frame(width: geometry.size.width*0.4, height: 45)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
                                .cornerRadius(5)
                                .padding(.bottom)
                            }
                            //                            }
                            .padding(.top)
                        }
                        
                        HStack {
                            Text("Opportunity Details")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                                .padding(.bottom, -5)
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(.black)
                            .padding(.bottom, 5)
                        
                        HStack {
                            Text("Opportunity ID")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(describing: opportunity_data["opportunity_id"]!))
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Location")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(describing: opportunity_data["location"]!))
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Type")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Equity")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Money Raised")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("£\(formattedNumber(input_number: Int(opportunity_data["amount_raised"]!)!))")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Target Raised")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("£\(formattedNumber(input_number: Int(opportunity_data["asking_price"]!)!))")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Investors")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(String(describing: opportunity_data["investors"]!))")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Minimum Investment")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("£\(formattedNumber(input_number: Int(opportunity_data["min_invest_amount"]!)!))")
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        HStack {
                            Text("Investment Deadline")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(String(describing: opportunity_data["close_date"]!))
                        }
                        .font(Font.custom("Nunito-Medium", size: 14))
                        .padding(.vertical, 6)
                        
                        Divider()
                            .overlay(.gray)
                            .frame(height: 1)
                            .opacity(0.5)
                        
                        
                        Spacer()
                    }
                    .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                    .foregroundColor(.black)
                    .padding(.top)
                }
            }
            .navigationDestination(isPresented: $admin_home_shown) {
                AdminHome().navigationBarBackButtonHidden(true)
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Are you sure you want to close this opportunity?"),
                    primaryButton: .default(Text("Yes")) {
                        DispatchQueue.global(qos: .userInteractive).async {
                            UpdateDB().updateTable(primary_key: "opportunity_id", primary_key_value: opportunity_data["opportunity_id"]!, table: "opportunities", updated_key: "status", updated_value: "Completed") { response in
                                if response == "opportunities status updated" {
                                    admin_home_shown.toggle()
                                }
                            }
                        }
                    },
                    secondaryButton: .destructive(Text("No")) {
                    }
                )
            }
        }
    }
}
