//
//  UserPortfolio.swift
//  PARC
//
//  Created by Ayman Ali on 19/10/2023.
//

import SwiftUI
import Charts

struct ChartData: Identifiable, Plottable {
    init?(primitivePlottable: Float) {
        self.primitivePlottable = primitivePlottable
        self.color = .blue
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

struct UserPortfolio: View {
    var metrics = ["£15,000.62", "£2,200.62", "23.49%"]
    var metric_description = ["Estimated Holdings", "Payouts Received", "Average Profit Margin"]
    var logo_images = ["McDonalds", "Starbucks", "Chipotle"]
    var invested_amount = [500, 200, 250]
    @State private var index = 0
    @Binding var portfolio_data: [[String: String]]
    @Binding var user_payouts_data: [[String: String]]
    @Binding var payouts_chart_values: [Float]
    @Binding var payouts_value: Int
    @Binding var holdings_value: Int
    @Binding var chart_values: [Float]
    @Binding var opportunity_data: [[String: String]]
    let random_colors: [Color] = [
        .red, .green, .blue, .orange, .purple, .pink, .yellow,
        .teal, .indigo, .cyan, .brown,
        .gray, .black, Color("Primary"),
        Color(red: 0.8, green: 0.2, blue: 0.6),
        Color(red: 0.4, green: 0.7, blue: 0.9),
        Color(red: 0.2, green: 0.5, blue: 0.3),
        Color(red: 0.9, green: 0.6, blue: 0.1),
        Color(red: 0.7, green: 0.4, blue: 0.8),
        Color(red: 0.1, green: 0.3, blue: 0.5),
        Color(red: 0.6, green: 0.8, blue: 0.4),
        Color(red: 0.3, green: 0.1, blue: 0.7),
        Color(red: 0.5, green: 0.9, blue: 0.2),
        Color(red: 0.8, green: 0.7, blue: 0.4),
        Color(red: 0.2, green: 0.4, blue: 0.6),
        Color(red: 0.9, green: 0.3, blue: 0.5),
        Color(red: 0.1, green: 0.6, blue: 0.8),
        Color(red: 0.7, green: 0.5, blue: 0.2),
        Color(red: 0.4, green: 0.8, blue: 0.1),
        Color(red: 0.6, green: 0.2, blue: 0.9),
        Color(red: 0.3, green: 0.9, blue: 0.7),
        Color(red: 0.5, green: 0.1, blue: 0.4),
    ]
    
    var body: some View {
        GeometryReader { geometry in
                
            VStack {
                Spacer()
                
                ScrollView(.vertical, showsIndicators: false) {
                    TabView(selection: $index) {
                        ForEach((0..<3), id: \.self) { index in
                            
                            ZStack {
                                if index == 0 {
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

                            VStack(alignment: .center) {
                                if index == 0 {
                                    Text("£\(formattedNumber(input_number: holdings_value))")
                                      .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.1))
                                      .foregroundColor(.black)
                                } else {
                                    Text("£\(formattedNumber(input_number: payouts_value))")
                                      .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.1))
                                      .foregroundColor(.black)
                                }
                                
                                Text(metric_description[index])
                                    .foregroundStyle(Color("Custom_Gray"))
                                    .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                    .padding(.top, -36)
                                
                            }
                        }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: geometry.size.height - 200)
                    
                    Divider()
                        .overlay(.black)
                        .padding(.top)
                        .frame(height: 1)
                        .padding(.bottom, 10)
                    
                    if portfolio_data.count != 0 {
                        ForEach(0..<portfolio_data.count, id: \.self) { index in
//                            Button(action: {}) {
                                HStack {
//                                    Text("\(index+1).")
//                                        .font(Font.custom("Nunito-Bold", size: 15))
                                    
                                    Image(logo_images[0])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .padding(.leading, 10)
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text(String(describing: opportunity_data[Int(portfolio_data[index]["opportunity_id"]!)! - 1]["franchise"]!))
                                          .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.045))
                                          .foregroundColor(.black)
                                        
//                                        Invested - £\(formattedNumber(input_number: Int(portfolio_data[index]["amount"]!)!))
                                        Text("Date Bought - \(convertDate(dateString: portfolio_data[index]["transaction_date"]!))")
                                          .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.027))
                                          .foregroundColor(Color("Custom_Gray"))
                                    }
                                    .padding(.leading)
                                    
                                    Spacer()
                                    
                                    //Should be something regarding payouts? or date created
                                    Text("+£\(formattedNumber(input_number: Int(portfolio_data[index]["amount"]!)!))")
                                      .font(Font.custom("Nunito-Black", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                    
//                                    if Int(portfolio_data[index]["amount"]!)! >= 500 {
//                                        Text("+£\(formattedNumber(input_number: Int(portfolio_data[index]["amount"]!)!))")
//                                          .font(Font.custom("Nunito-Black", size: min(geometry.size.width, geometry.size.height) * 0.055))
//                                          .foregroundColor(Color("Profit"))
//                                    } else {
//                                        Text("-£\(formattedNumber(input_number: Int(portfolio_data[index]["amount"]!)!))")
//                                          .font(Font.custom("Nunito-Black", size: min(geometry.size.width, geometry.size.height) * 0.055))
//                                          .foregroundColor(Color("Loss"))
//                                    }
                                    
                                }
                                
//                            }
                            Divider()
                                .overlay(Color("Custom_Gray"))
                                .frame(height: 0.5)
                            
                        }
                    } else {
                        Text("No investments yet.")
                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.055))
                    }
                }
                
            }
            .foregroundColor(.black)
            .frame(width: max(0, geometry.size.width))
            .onAppear {

                holdings_data = []
                payouts_data = []
                holdings_data.append(contentsOf: chart_values.compactMap { value in
                        return ChartData(primitivePlottable: value) ?? ChartData(primitivePlottable: 0)
                })
                
                payouts_data.append(contentsOf: payouts_chart_values.compactMap { value in
                        return ChartData(primitivePlottable: value) ?? ChartData(primitivePlottable: 0)
                })

                for (index, color) in random_colors.enumerated() {
                    if index < holdings_data.count {
                        holdings_data[index].color = color
                    } else {
                        
                    }
                }                
                
                for (index, color) in random_colors.enumerated() {
                    if index < payouts_data.count {
                        payouts_data[index].color = color
                    } else {
                        
                    }
                }
            }
        }
    }
}

//struct UserPortfolio_Previews: PreviewProvider {
//    static var previews: some View {
//        UserPortfolio(portfolio_data: .constant([[:]]), opportunity_data: .constant([[:]]))
//    }
//}
