//
//  UserHomeView.swift
//  PARC
//
//  Created by Ayman Ali on 18/10/2023.
//

import SwiftUI

struct UserHome: View {
    var bg_images = ["store_live", "store_live_2"]
    var logo_images = ["McDonalds", "Starbucks"]
    var titles = ["McDonald's", "Starbucks"]
    @State private var selectedTab: Tab = .house
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack(alignment: .leading) {
                    HStack {
                        Text("PARC").font(Font.custom("Nunito-Black", size: 60)).foregroundColor(Color("Secondary"))
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                    
                    Text("New Opportunities")
                        .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.065))
                        .padding(.bottom, -5)
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(.black)
                    
                    
                    ScrollView(.vertical, showsIndicators: false){
                        ForEach(0..<2, id: \.self) {index in
                            
                            Button(action: {}) {
                                ZStack{
                                    Image(bg_images[index])
                                        .resizable()
                                        .frame(width: max(0, geometry.size.width-40), height: 250)
                                        .cornerRadius(5)
                                    
                                    Rectangle()
                                        .stroke(Color.gray, lineWidth: 2)
                                        .frame(width: max(0, geometry.size.width - 40), height: 250)
                                        .cornerRadius(2.5)
                                    
                                    VStack {
                                        Spacer()
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 5)
                                                    .fill(.white)
                                                    .frame(width: max(0, geometry.size.width-40), height: 150)
                                                    .border(.gray, width: 1)
                                            
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Image(logo_images[index])
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 35, height: 30)
                                                        .padding(.top,10).padding(.leading, 7)
                                                    
                                                    Text(titles[index])
                                                    .font(Font.custom("Nunito-ExtraBold", size: min(geometry.size.width, geometry.size.height) * 0.04))
                                                    .foregroundColor(.black)
                                                    .padding(.top, 10).padding(.leading, -5)
                                                    
                                                    Spacer()
                                                }
                                                
                                                Text("A golden opportunity for those seeking a turnkey, globally renowned business in the fast-food industry, backed by a proven system of success and ongoing support.")
                                                    .foregroundColor(Color("Custom_Gray"))
                                                    .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.026))
                                                    .frame(height: 50)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.horizontal, 12).padding(.top, -12)
                                                
                                                HStack {
                                                    Text("90% - 12 days left")
                                                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.022))
                                                      .foregroundColor(Color("Custom_Gray"))
                                                      .frame(alignment: .leading)
                                                    Spacer()
                                                    
                                                    ZStack {
                                                        Rectangle()
                                                          .foregroundColor(.clear)
                                                          .frame(width: 40, height: 12)
                                                          .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.5))
                                                          .cornerRadius(5)
                                                        
                                                        HStack {
                                                            Image("gbr").resizable().frame(width: 10, height: 10)
                                                            Text("London")
                                                              .font(Font.custom("Nunito-Bold", size: 7))
                                                              .foregroundColor(Color("Custom_Gray"))
                                                              .padding(.leading, -7.5)
                                                        }
                                                    }
                                                }
                                                .padding(.horizontal,12)
                                                .padding(.top, -3)
                                                
                                                ZStack {
                                                    Rectangle()
                                                      .foregroundColor(.clear)
                                                      .frame(width: max(0, geometry.size.width - 63), height: 8)
                                                      .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6))
                                                      .cornerRadius(100)
                                                      .padding(.leading, 11)
                                                    
                                                    HStack {
                                                        Rectangle()
                                                          .foregroundColor(.clear)
                                                          .frame(width: max(0, geometry.size.width - 200), height: 8)
                                                          .background(Color("Secondary"))
                                                          .cornerRadius(100)
                                                        
                                                        Spacer()
                                                    }
                                                    .frame(width: max(0, geometry.size.width - 105))
                                                    .padding(.leading, -28)
                                                    
                                                    
                                                }
                                                .padding(.top, -5)
                                                
                                                HStack {
                                                        Text("Minimum Investment Amount - £100")
                                                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.022))
                                                            .foregroundColor(Color("Custom_Gray"))
                                                            .frame(alignment: .leading)
                                                        Spacer()
                                                    
                                                        Text("£3,500,000 Target")
                                                            .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.022))
                                                            .foregroundColor(Color("Custom_Gray"))
                                                            .frame(alignment: .leading)
                                                            
                                                }
                                                    .padding(.horizontal,12)
                                                    .padding(.top, -3)
                                                
                                                
                                                Spacer()
                                                
                                            }
                                            .frame(width: max(0, geometry.size.width - 40), height: 150)
                                        }
                                    }
                                }
                                .padding(.top)
                            }
                        }
                    }
                    
                    Spacer()
                    BottomNavBar(selectedTab: $selectedTab)
                    
                }
                .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                .foregroundColor(.black)
                
            }
            
        }
    }
}

struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserHome()
    }
}
