//
//  UserPortfolio.swift
//  PARC
//
//  Created by Ayman Ali on 19/10/2023.
//

import SwiftUI
import Charts

// Creates the charts in a way that each holding is identifiable and has a distinct colour
struct ChartData: Identifiable, Plottable {
    init?(primitivePlottable: Float) {
        self.primitivePlottable = primitivePlottable
        self.color = Color("Secondary")
    }
    
    init?(primitivePlottable: Float, color: Color) {
        self.primitivePlottable = primitivePlottable
        self.color = color
    }
    
    var id = UUID()
    let primitivePlottable: Float
    var color: Color
}

var holdings_data: [ChartData] = [].compactMap({ $0 })
var payouts_data: [ChartData] = [].compactMap({ $0 })

// Displays a user's portfolio that shows all holdings and payouts received
struct UserPortfolio: View {
    var metric_description = ["Estimated Holdings", "Payouts Received"]
    var logo_images = ["McDonalds", "Starbucks", "Chipotle"]
    @State private var index = 0
    @State var payouts_indexes: [Int] = []
    @State var text_selected = ""
    @State var payouts_colors: [String: Color] = [:]
    @Binding var portfolio_data: [[String: String]]
    @Binding var franchise_data: [[String: String]]
    @Binding var user_payouts_data: [[String: String]]
    @Binding var payouts_chart_values: [Float]
    @Binding var payouts_value: Int
    @Binding var holdings_value: Int
    @Binding var chart_values: [Float]
    @Binding var opportunity_data: [[String: String]]
    @State var appeared_before = 0
    // Colors shown in the chart that match the application theme
    let random_colors: [Color] = [
        Color(red: 0.41568627450980394, green: 0.5529411764705883, blue: 0.45098039215686275),
        Color(red: 0.9568627450980393, green: 0.9921568627450981, blue: 0.8509803921568627),
        Color(red: 0.8941176470588236, green: 1, blue: 0.8823529411764706),
        Color(red: 1, green: 0.9098039215686274, blue: 0.7607843137254902),
        Color(red: 0.9411764705882353, green: 0.6588235294117647, blue: 0.40784313725490196),
        Color(red: 0.1568627450980392, green: 0.3254901960784314, blue: 0.4196078431372549),
        Color(red: 0.7607843137254902, green: 0.5803921568627451, blue: 0.5411764705882353),
        Color(red: 0, green: 0.00392156862745098, blue: 0),
        Color(red: 0.043137254901960784, green: 0.23529411764705882, blue: 0.28627450980392155),
        Color(red: 0.45098039215686275, green: 0.09803921568627451, blue: 0.38823529411764707),
        Color(red: 0.45098039215686275, green: 0.11372549019607843, blue: 0.8470588235294118),
        Color(red: 0.2823529411764706, green: 0.6627450980392157, blue: 0.6509803921568628),
        Color(red: 0.8941176470588236, green: 0.8745098039215686, blue: 0.8549019607843137),
        Color(red: 0.8313725490196079, green: 0.7058823529411765, blue: 0.5137254901960784),
        Color(red: 0.7568627450980392, green: 0.4, blue: 0.4196078431372549),
        Color(red: 0.29411764705882354, green: 0.23137254901960785, blue: 0.25098039215686274),
        Color(red: 0.5098039215686274, green: 0.45098039215686275, blue: 0.3607843137254902),
        Color(red: 0.9411764705882353, green: 0.17647058823529413, blue: 0.22745098039215686),
        Color(red: 0.8666666666666667, green: 0.01568627450980392, blue: 0.14901960784313725),
        Color(red: 0.3058823529411765, green: 0.3254901960784314, blue: 0.25098039215686274)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    if portfolio_data.count != 0 {
                        ZStack {
                            if text_selected == "Holdings" || text_selected == "" {
                                Chart(holdings_data) { item in
                                    SectorMark(angle: .value("Label", item), innerRadius: .ratio(0.8))
                                        .foregroundStyle(item.color)
                                }
                            } else {
                                Chart(payouts_data) { item in
                                    SectorMark(angle: .value("Label", item), innerRadius: .ratio(0.8))
                                        .foregroundStyle(item.color)
                                }
                            }
                            
                            // Variably showing a user's holdings and payouts for each investment
                            VStack(alignment: .center) {
                                if text_selected == "Holdings" || text_selected == "" {
                                    Text("£\(formatted_number(input_number: holdings_value))")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.1))
                                        .foregroundColor(.black)
                                    Text(metric_description[0])
                                        .foregroundStyle(Color("Custom_Gray"))
                                        .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                        .padding(.top, -36)
                                } else {
                                    Text("£\(formatted_number(input_number: payouts_value))")
                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.1))
                                        .foregroundColor(.black)
                                    Text(metric_description[1])
                                        .foregroundStyle(Color("Custom_Gray"))
                                        .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                        .padding(.top, -36)
                                }
                                
                                
                            }
                        }
                        .frame(height: geometry.size.height - 200)
                        
                        
                        HStack(spacing: 80) {
                            Button(action : {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    text_selected = "Holdings"
                                }
                            }) {
                                VStack {
                                    Text("Holdings").font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                    
                                    if text_selected == "Holdings" || text_selected == "" {
                                        Divider()
                                            .frame(width: min(geometry.size.width, geometry.size.height) * 0.25, height: 2.5)
                                            .background(Color("Secondary"))
                                            .cornerRadius(5)
                                            .padding(.top, -7.5)
                                    }
                                }
                            }
                            
                            Button(action : {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    text_selected = "Payouts"
                                }
                            }) {
                                VStack {
                                    Text("Payouts").font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                                    if text_selected == "Payouts" {
                                        Divider()
                                            .frame(width: min(geometry.size.width, geometry.size.height) * 0.25, height: 2.5)
                                            .background(Color("Secondary"))
                                            .cornerRadius(5)
                                            .padding(.top, -7.5)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        
                        // Variably showing a user's holdings and payouts for each investment
                        if text_selected == "Holdings" || text_selected == "" {
                            Divider()
                                .overlay(Color("Custom_Gray"))
                                .padding([.top, .bottom], 10)
                                .frame(height: 1)
                        } else {
                            if let opportunityID = portfolio_data[index]["opportunity_id"],
                               let equity = portfolio_data[index]["equity"],
                               let userIndex = user_payouts_data.firstIndex(where: {
                                   $0["opportunity_id"] == opportunityID && $0["equity"] == equity
                               }) {
                                Divider()
                                    .overlay(Color("Custom_Gray"))
                                    .padding([.top, .bottom], 10)
                                    .frame(height: 1)
                                
                            } else {
                                Divider()
                                    .overlay(Color("Custom_Gray"))
                                    .padding(.top, 10).padding(.bottom, 30)
                                    .frame(height: 1)
                            }
                        }
                        
                        
                        if opportunity_data.count != 0 {
                            ForEach(0..<portfolio_data.count, id: \.self) { index in
                                HStack {
                                    
                                    // Variably showing a user's holdings and payouts for each investment
                                    if text_selected == "Holdings" || text_selected == "" {
                                        RoundedRectangle(cornerRadius: 5)
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(random_colors[index])
                                    } else {
                                        if let opportunityID = portfolio_data[index]["opportunity_id"],
                                           let equity = portfolio_data[index]["equity"],
                                           let userIndex = user_payouts_data.firstIndex(where: {
                                               $0["opportunity_id"] == opportunityID && $0["equity"] == equity
                                           }) {
                                            
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(payouts_colors["\(user_payouts_data[userIndex]["opportunity_id"]!) - \((user_payouts_data[userIndex]["equity"]!))"])
                                            
                                        }
                                    }

                                    VStack(alignment: .leading) {
                                        // Variably showing a user's holdings and payouts for each investment
                                        if text_selected == "Holdings" || text_selected == "" {
                                            if let opportunityID = Int(portfolio_data[index]["opportunity_id"]!) {
                                                if let opportunity = opportunity_data.first(where: { $0["opportunity_id"] == String(opportunityID) }) {
                                                    if let franchise = opportunity["franchise"] {
                                                        
                                                        HStack {
                                                            Text("\(franchise)")
                                                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                                            // .foregroundColor(random_colors[index])
                                                            
                                                            ZStack {
                                                                Rectangle()
                                                                    .foregroundColor(.clear)
                                                                    .frame(width: 70, height: 20)
                                                                    .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.5))
                                                                    .cornerRadius(5)
                                                                
                                                                HStack(spacing: 10) {
                                                                    Image("gbr").resizable().frame(width: 15, height: 15)
                                                                    Text(opportunity_data[opportunity_data.firstIndex(where: { $0["opportunity_id"] == portfolio_data[index]["opportunity_id"]!})!]["location"]!)
                                                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                                                                        .foregroundColor(Color("Custom_Gray"))
                                                                        .padding(.leading, -7.5)
                                                                }
                                                                
                                                            }
                                                        }
                                                    } else {
                                                        Text("Franchise key not found")
                                                    }
                                                } else {
                                                    Text("Opportunity not found")
                                                }
                                            } else {
                                                Text("Invalid opportunity_id value")
                                            }
                                            
                                            Text("Bought - \(portfolio_data[index]["transaction_date"]!)")
                                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                                                .foregroundColor(Color("Custom_Gray"))
                                            
                                            
                                        } else {
                                            if let opportunityID = portfolio_data[index]["opportunity_id"],
                                               let equity = portfolio_data[index]["equity"],
                                               let userIndex = user_payouts_data.firstIndex(where: {
                                                   $0["opportunity_id"] == opportunityID && $0["equity"] == equity
                                               }) {
                                                if let opportunityID = Int(portfolio_data[index]["opportunity_id"]!) {
                                                    if let opportunity = opportunity_data.first(where: { $0["opportunity_id"] == String(opportunityID) }) {
                                                        if let franchise = opportunity["franchise"] {
                                                            
                                                            HStack {
                                                                Text("\(franchise)")
                                                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                                                ZStack {
                                                                    Rectangle()
                                                                        .foregroundColor(.clear)
                                                                        .frame(width: 70, height: 20)
                                                                        .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.5))
                                                                        .cornerRadius(5)
                                                                    
                                                                    HStack(spacing: 10) {
                                                                        Image("gbr").resizable().frame(width: 15, height: 15)
                                                                        Text(opportunity_data[opportunity_data.firstIndex(where: { $0["opportunity_id"] == portfolio_data[index]["opportunity_id"]!})!]["location"]!)
                                                                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                                                                            .foregroundColor(Color("Custom_Gray"))
                                                                            .padding(.leading, -7.5)
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        } else {
                                                            Text("Franchise key not found")
                                                        }
                                                    } else {
                                                        Text("Opportunity not found")
                                                    }
                                                } else {
                                                    Text("Invalid opportunity_id value")
                                                }
                                                
                                                Text("Bought - \(portfolio_data[index]["transaction_date"]!)")
                                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                                                    .foregroundColor(Color("Custom_Gray"))
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // Variably showing a user's holdings and payouts for each investment
                                    if text_selected == "Holdings" || text_selected == "" {
                                        Text("£\(formatted_number(input_number: Int(portfolio_data[index]["amount"]!)!))")
                                            .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                    } else {
                                        if let opportunityID = portfolio_data[index]["opportunity_id"],
                                           let equity = portfolio_data[index]["equity"],
                                           let userIndex = user_payouts_data.firstIndex(where: {
                                               $0["opportunity_id"] == opportunityID && $0["equity"] == equity
                                           }) {
                                            let foundElement = user_payouts_data[userIndex]["amount_received"]!
                                            Text("+£\(foundElement)")
                                                .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                                .foregroundColor(Color("Profit"))
                                        }
                                    }
                                }
                                
                                // Variably showing a user's holdings and payouts for each investment
                                if text_selected == "Holdings" || text_selected == "" {
                                    Divider()
                                        .overlay(Color("Custom_Gray"))
                                        .frame(height: 0.5)
                                    
                                } else {
                                    if let opportunityID = portfolio_data[index]["opportunity_id"],
                                       let equity = portfolio_data[index]["equity"],
                                       let userIndex = user_payouts_data.firstIndex(where: {
                                           $0["opportunity_id"] == opportunityID && $0["equity"] == equity
                                       }) {
                                        Divider()
                                            .overlay(Color("Custom_Gray"))
                                            .frame(height: 0.5)
                                            .padding(.bottom, 10)
                                    }
                                }
                            }
                        }
                        
                    } else {
                        Spacer()
                        Text("☹️")
                            .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.3))
                            .padding(.bottom, -20)
                        
                        Text("No investments made yet")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                    }
                }
                
            }
            .foregroundColor(.black)
            .frame(width: max(0, geometry.size.width))
            .onAppear {
                user_payouts_data = transform_payouts_array(entries: user_payouts_data)
                holdings_data = []
                payouts_data = []
                holdings_data.append(contentsOf: chart_values.compactMap { value in
                    return ChartData(primitivePlottable: value) ?? ChartData(primitivePlottable: 0)
                })
                
                payouts_data.append(contentsOf: payouts_chart_values.compactMap { value in
                    return ChartData(primitivePlottable: value) ?? ChartData(primitivePlottable: 0)
                })
                
                for (index, value) in portfolio_data.enumerated() {
                    if let opportunityID = portfolio_data[index]["opportunity_id"],
                       let equity = portfolio_data[index]["equity"],
                       let userIndex = user_payouts_data.firstIndex(where: {
                           $0["opportunity_id"] == opportunityID && $0["equity"] == equity
                       }) {
                        payouts_colors["\(user_payouts_data[userIndex]["opportunity_id"]!) - \((user_payouts_data[userIndex]["equity"]!))"] = .red
                        
                    }
                }
                for (index, color) in random_colors.enumerated() {
                    if index < holdings_data.count {
                        holdings_data[index].color = color
                    } else {
                        
                    }
                }
                
                for (index, key) in payouts_colors.keys.enumerated() {
                    payouts_colors[key] = random_colors[index]
                    payouts_data[index].color = random_colors[index]
                }
            }
        }
    }
}
