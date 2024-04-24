//
//  BottomNavBar.swift
//  PARC
//
//  Created by Ayman Ali on 18/10/2023.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case chartPie = "chart.pie"
    case bag
}

// View responsible for displaying the bottom navigation bar shown to users
struct BottomNavBar: View {
    @Binding var selected_tab: Tab
    private var fill_image: String {
        selected_tab.rawValue + ".fill"
    }
    var tab_names: [String:String] = ["house": "Home", "chartPie": "Portfolio", "bag": "Secondary Market"]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    VStack {
                        // Lines 30-38 adopted from: https://github.com/federicoazzu/Custom-Tab-Bar/blob/main/TestProject0105/CustomTabBar.swift
                        Image(systemName: selected_tab == tab ? fill_image : tab.rawValue)
                            .scaleEffect(selected_tab == tab ? 1.25 : 1.0)
                            .foregroundColor(selected_tab == tab ? Color("Secondary") : .black)
                            .font(.system(size: 22))
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.1)) {
                                    selected_tab = tab
                                }
                            }
                        
                        // All the options of the bottom navigation bar displayed
                        if tab.rawValue == "house" {
                            Text("Home")
                                .font(Font.custom("Nunito-Bold", size: 10))
                                .foregroundColor(selected_tab == tab ? Color("Secondary") : .black)
                                .padding(.top, 2)
                        } else if tab.rawValue == "chart.pie" {
                            Text("Portfolio")
                                .font(Font.custom("Nunito-Bold", size: 10))
                                .foregroundColor(selected_tab == tab ? Color("Secondary") : .black)
                                .padding(.top, 2)
                        } else if tab.rawValue == "bag" {
                            Text("Marketplace")
                                .font(Font.custom("Nunito-Bold", size: 10))
                                .foregroundColor(selected_tab == tab ? Color("Secondary") : .black)
                                .padding(.top, 2)
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(width: nil, height: 65)
        .background(.thinMaterial)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
