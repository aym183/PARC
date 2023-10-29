//
//  AdinAccount.swift
//  PARC
//
//  Created by Ayman Ali on 29/10/2023.
//

import SwiftUI

struct AdminAccount: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .center) {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 120, height: 120)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Ayman Ali")
                                .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.08))
                            
                            Text("Member since November 2023")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.03))
                                .foregroundColor(Color("Custom_Gray"))
                        }
                        .padding(.leading, 10)
                    }
                    .frame(width: max(0, geometry.size.width-40))
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            Text("Set Pin")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Text("Completed")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                                .foregroundColor(Color("Profit"))
                        }
                        .padding(.horizontal).padding(.top, 10)
                        
                        Divider()
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                            .frame(height: 1)
                        
                        HStack {
                            
                            Button(action: {}) {
                                HStack {
                                    Text("Log out")
                                        .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                        .fontWeight(.bold)
                                }
                                .frame(width: max(0, geometry.size.width-233), height: 45)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
                                .border(Color.black, width: 1)
                                .cornerRadius(5)
                            }
                            
                            Button(action: {}) {
                                HStack {
                                    Text("Withdraw")
                                        .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                        .fontWeight(.bold)
                                }
                                .frame(width: max(0, geometry.size.width-233), height: 45)
                                .background(Color("Loss"))
                                .foregroundColor(Color.white)
                                .border(Color.black, width: 1)
                                .cornerRadius(5)
                            }
                            .padding(.leading, 15)
                            
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                }
                }
                .frame(width: max(0, geometry.size.width-40))
                .multilineTextAlignment(.center)
                .padding(.leading).padding(.top)
                .foregroundColor(.black)
            }
        }
}

#Preview {
    AdminAccount()
}
