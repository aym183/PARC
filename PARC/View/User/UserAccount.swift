//
//  UserAccount.swift
//  PARC
//
//  Created by Ayman Ali on 19/10/2023.
//

import SwiftUI

struct UserAccount: View {
    @Binding var account_shown: Bool
    
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
                                .font(Font.custom("Nunito-ExtraBold", size: 30))

                            Text("Member since November 2023")
                                .font(Font.custom("Nunito-SemiBold", size: 12))
                                .foregroundColor(Color("Custom_Gray"))
                        }
                        .padding(.leading, 10)
                    }
                    .frame(width: max(0, geometry.size.width-40))
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            Text("Verification Status")
                                .font(Font.custom("Nunito-SemiBold", size: 20))
                            Spacer()
                            Text("Completed")
                                .font(Font.custom("Nunito-Bold", size: 20))
                                .foregroundColor(Color("Profit"))
                        }
                        .padding(.horizontal).padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                        
                        HStack {
                            Text("Transaction History")
                                .font(Font.custom("Nunito-SemiBold", size: 20))
                            Spacer()
                            Button(action: {}) {
                                HStack {
                                    Text("Check")
                                        .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                        .fontWeight(.bold)
                                }
                                .frame(width: 100, height: 35)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
                                .border(Color.black, width: 1)
                                .cornerRadius(5)
                            }
                        }
                        .padding(.horizontal).padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                        
                        HStack {
                            Text("Set Pin")
                                .font(Font.custom("Nunito-SemiBold", size: 20))
                            Spacer()
                            Button(action: {}) {
                                HStack {
                                    Text("Set")
                                        .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                        .fontWeight(.bold)
                                }
                                .frame(width: 100, height: 35)
                                .background(Color("Secondary"))
                                .foregroundColor(Color.white)
                                .border(Color.black, width: 1)
                                .cornerRadius(5)
                            }
                        }
                        .padding(.horizontal).padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                        
                        HStack {
                            Text("Balance")
                                .font(Font.custom("Nunito-SemiBold", size: 20))
                            Spacer()
                            Text("£10,000")
                                .font(Font.custom("Nunito-Bold", size: 20))
                                .foregroundColor(.black)
                                .padding(.trailing, 13)
                        }
                        .padding(.horizontal).padding(.top, 10)
                    }
                    .padding(.top)
                    .foregroundColor(Color("Custom_Gray"))
                
                    Button(action: {}) {
                        HStack {
                            Text("Withdraw")
                                .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                .fontWeight(.bold)
                        }
                        .frame(width: 335, height: 45)
                        .background(Color("Secondary"))
                        .foregroundColor(Color.white)
                        .border(Color.black, width: 1)
                        .cornerRadius(5)
                    }
                    .padding(.top, 40)
                    
                    HStack {
                        
                        Button(action: {}) {
                            HStack {
                                Text("Log out")
                                    .font(Font.custom("Nunito", size: min(geometry.size.width, geometry.size.height) * 0.055))
                                    .fontWeight(.bold)
                            }
                            .frame(width: 160, height: 45)
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
                            .frame(width: 160, height: 45)
                            .background(Color("Loss"))
                            .foregroundColor(Color.white)
                            .border(Color.black, width: 1)
                            .cornerRadius(5)
                        }
                        .padding(.leading, 5)
                        
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .frame(width: max(0, geometry.size.width-40))
            .multilineTextAlignment(.center)
            .padding(.leading).padding(.top)
            .foregroundColor(.black)
        }
    }
}

//struct UserAccount_Previews: PreviewProvider {
//    static var previews: some View {
//        UserAccount()
//    }
//}
