//
//  UserChatbot.swift
//  PARC
//
//  Created by Ayman Ali on 25/02/2024.
//

import SwiftUI

struct UserChatbot: View {
    @State var text_input = ""
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.white).ignoresSafeArea()
                VStack {
                    Text("Chat with our franchise expert 🧐")
                        .font(Font.custom("Nunito-Bold", size: min(geometry.size.width, geometry.size.height) * 0.05))
                        .multilineTextAlignment(.center)
                    Divider()
                        .overlay(Color("Custom_Gray"))
                        .frame(height: 1)
                        .frame(width: max(0, geometry.size.width))
                    
                    Spacer()
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack {
                            HStack {
                                Text("Hei")
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Text("Hei")
                            }
                        }
                    }
                    .frame(width: max(0, geometry.size.width-40))
                    .padding(.top)
                    
                    HStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1.25)
                                )
                                .frame(width: geometry.size.width*0.65, height: 50)
                            
                            TextField("", text: $text_input, prompt: Text("Enter your input here...").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().padding(.horizontal, 40).frame(width: max(0, geometry.size.width-40), height: 50)
                                .foregroundColor(.black)
                                .font(Font.custom("Nunito-SemiBold", size: 16))
                                .frame(width: geometry.size.width*0.65, height: 50)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: geometry.size.width*0.05))
                                    
                            }
                            .frame(width:  geometry.size.width*0.14, height: geometry.size.height*0.0725)
                            .background(Color("Secondary"))
                            .cornerRadius(100)
                        }
                    }
                    
                }
                .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
            }
        }
    }
}

#Preview {
    UserChatbot()
}
