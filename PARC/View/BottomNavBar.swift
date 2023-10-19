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

struct BottomNavBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                        .foregroundColor(selectedTab == tab ? Color("Secondary") : .black)
                        .font(.system(size: 22))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    
                    Spacer()
                }
            }
        }
        .frame(width: nil, height: 60)
        .background(.thinMaterial)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar(selectedTab: .constant(.house))
    }
}
