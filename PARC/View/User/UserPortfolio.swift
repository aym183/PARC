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

var data: [ChartData] = [].compactMap({ $0 })

struct UserPortfolio: View {
    var metrics = ["£15,000.62", "£2,200.62", "23.49%"]
    var metric_description = ["Estimated Holdings", "Payouts Received", "Average Profit Margin"]
    var logo_images = ["McDonalds", "Starbucks", "Chipotle"]
    var titles = ["McDonald's", "Starbucks", "Chipotle"]
    var invested_amount = [500, 200, 250]
    @State private var index = 0
    @Binding var portfolio_data: [[String: String]]
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
                            Chart(data) { item in
                                SectorMark(angle: .value("Label", item), innerRadius: .ratio(0.8))
                                    .foregroundStyle(item.color)
                            }
                            
                            VStack(alignment: .center) {
                                Text("£\(formattedNumber(input_number: holdings_value))")
                                  .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.1))
                                  .foregroundColor(.black)
                                
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
                
//                let chart_values: [String] = ["10.5", "20.3", "30.7"] // Replace with your actual values
//                let colors: [Color] = [.red, .green, .blue, ] // Replace with your actual colors

                data.append(contentsOf: chart_values.compactMap { value in
//                    /*if let floatValue = Float(value)*/ {
                        return ChartData(primitivePlottable: value) ?? ChartData(primitivePlottable: 0)
//                    }
//                    return nil
                })

                // Assuming colors.count matches chart_values.count
                for (index, color) in random_colors.enumerated() {
                    if index < data.count {
                        data[index].color = color
                    } else {
                        
                    }
                }
                
//                ForEach(0..<chart_values.count, id: \.self) { index in
//                    data.append(.init(primitivePlottable: Int(chart_values[index]), color: colors.randomElement() ?? .gray)!)
                    
//                    data.append(contentsOf: chart_values.compactMap { value in
//                        if let intValue = Int(chart_values[index]) {
//                            return ChartData(primitivePlottable: intValue) ?? ChartData(primitivePlottable: 0)
//                        }
//                        return nil
//                    })
                    
                    
//                    data.append(.init(primitivePlottable: , color: colors.randomElement() ?? .gray))
//                }
//                .init(primitivePlottable: 55, color: Color("Secondary")),
//                .init(primitivePlottable: 25, color: .yellow),
            }
        }
    }
}

//struct UserPortfolio_Previews: PreviewProvider {
//    static var previews: some View {
//        UserPortfolio(portfolio_data: .constant([[:]]), opportunity_data: .constant([[:]]))
//    }
//}
