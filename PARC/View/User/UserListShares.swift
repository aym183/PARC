//
//  UserListShares.swift
//  PARC
//
//  Created by Ayman Ali on 28/10/2023.
//

import SwiftUI

struct UserListShares: View {
    @State var franchise = ""
    @State var no_of_shares = ""
    @State var asking_price = ""
    @State var is_on = false
    @Binding var marketplace_shown: Bool
    @State var isInvestmentConfirmed = false
    @State var isShownHomePage = false
    
    //Refactor this view to show for loop components as compared to replicating
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .leading) {
                    
                    Text("List Shares")
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                        .padding(.bottom, -5)
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(.black)
                    
                    
                    Text("Franchise").font(Font.custom("Nunito-Bold", size: 18))
                        .padding(.top).padding(.bottom, -5)
                    
                    // Replace with dropdown of all added franchise
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1.25)
                            )
                            .frame(width: max(0, geometry.size.width - 40), height: 50)
                        
                        TextField("", text: $franchise).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                            .foregroundColor(.black)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
//                            .border(Color.black, width: 1)
                            .cornerRadius(5)
                            .font(Font.custom("Nunito-Bold", size: 16))

                        
                    }
                    
                    Text("Shares").font(Font.custom("Nunito-Bold", size: 18))
                        .padding(.top, 10).padding(.bottom, -5)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1.25)
                            )
                            .frame(width: max(0, geometry.size.width - 40), height: 50)
                        // Have some limit where user cant put more than the no of shares available
                        TextField("", text: $no_of_shares, prompt: Text("500").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                            .foregroundColor(.black)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .font(Font.custom("Nunito-Bold", size: 16))
                            .keyboardType(.numberPad)
                    }
                    
                    Text("Asking Price (£)").font(Font.custom("Nunito-Bold", size: 18))
                        .padding(.top, 10).padding(.bottom, -5)
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1.25)
                            )
                            .frame(width: max(0, geometry.size.width - 40), height: 50)
                        
                        TextField("", text: $asking_price, prompt: Text("1250000").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().frame(width: max(0, geometry.size.width-40), height: 50)
                            .foregroundColor(.black)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                            .font(Font.custom("Nunito-Bold", size: 16))
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Toggle(isOn: $is_on) {
                            HStack(spacing: 5) {
                                Text("I agree to the")
                                Text("terms and conditions")
                                    .foregroundColor(Color.blue)
                                    .underline()
                            }
                        }
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.035))
                        .padding(.top, 5)
                    }
                  
                    Spacer()
                    
                    Button(action: { 
                        marketplace_shown.toggle()
                    }) {
                        HStack {
                            Text("Submit Listing")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.06))
                        }
                        .frame(width: max(0, geometry.size.width-40), height: 55)
                        .background(Color("Secondary"))
                        .foregroundColor(Color.white)
//                        .border(Color.black, width: 1)
                        .cornerRadius(5)
                        .padding(.bottom)
                    }
                }
                .frame(width: max(0, geometry.size.width - 40))
                .padding(10)
            }
            .foregroundColor(.black)
            .navigationDestination(isPresented: $marketplace_shown) {
                UserHome(isInvestmentConfirmed: $isInvestmentConfirmed, isShownHomePage: $isShownHomePage).navigationBarBackButtonHidden(true)
            }
        }
    }
}
//
//#Preview {
//    UserListShares()
//}
