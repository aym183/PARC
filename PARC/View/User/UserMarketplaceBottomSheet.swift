//
//  UserMarketplaceBottomSheet.swift
//  PARC
//
//  Created by Ayman Ali on 23/10/2023.
//

import SwiftUI

struct UserMarketplaceBottomSheet: View {
    @Binding var marketplace_bottom_sheet_shown: Bool
    @Binding var marketplace_list_shares_shown: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack {
//                    Button(action: {}) {
//                        HStack {
//                            Text("Your Listed Shares")
//                                .font(Font.custom("Nunito-Bold", size: 22))
//                        }
//                        .frame(width: max(0, geometry.size.width-40), height: 55)
//                        .background(Color("Secondary"))
//                        .foregroundColor(Color.white)
//                        .cornerRadius(5)
//                        .padding(.top, 10)
//                    }
//                    
                    Button(action: {
                        marketplace_bottom_sheet_shown.toggle()
                        marketplace_list_shares_shown.toggle()
                    }) {
                        HStack {
                            Text("List Shares")
                                .font(Font.custom("Nunito-Bold", size: 22))
                        }
                        .frame(width: max(0, geometry.size.width-40), height: 55)
                        .background(Color("Secondary"))
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                        .padding(.top, 10)
                    }
                }
                .padding(.top,10)
                .frame(width: max(0, geometry.size.width - 40))
            }
            .foregroundColor(.black)
        }
    }
}
