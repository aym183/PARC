//
//  UserAccount.swift
//  PARC
//
//  Created by Ayman Ali on 19/10/2023.
//

import SwiftUI
import URLImage

struct UserAccount: View {
    @Binding var imageURL: URL?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .center) {
                    HStack {
                        Button(action: {}) {
                            if imageURL != nil {
                                URLImage(imageURL!) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 100))
                                }
                            } else {
                                Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                            }
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
                            Text("Verification Status")
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
                            Text("Transaction History")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Button(action: {}) {
                                HStack {
                                    Text("Check")
                                        .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
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
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                            .frame(height: 1)
                            
                        
                        HStack {
                            Text("Set Pin")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Button(action: {}) {
                                HStack {
                                    Text("Set")
                                        .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
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
                            .overlay(Color("Custom_Gray"))
                            .opacity(0.75)
                            .frame(height: 1)
                        
                        HStack {
                            Text("Balance")
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.052))
                            Spacer()
                            Text("£10,000")
                                .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.052))
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
                        .frame(width: max(0, geometry.size.width-50), height: 45)
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
