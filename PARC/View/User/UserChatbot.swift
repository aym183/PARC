//
//  UserChatbot.swift
//  PARC
//
//  Created by Ayman Ali on 25/02/2024.
//

import SwiftUI

struct UserChatbot: View {
    @State var text_input = ""
    @State var test_input: [[String: String]] = [["type": "Receiver", "data": "Is there anything I can help with to you today with what I do today in for you to do this today if I want this"], ["type": "Sender", "data": "Yes of course, I would like some assistance with this. I have for franchises to select from - Starbucks, MCdondald, KFC. Which one do I invest in?"], ["type": "Receiver", "data": "Yes of course, I would like some assistance with this. I have for franchises to select from - Starbucks, MCdondald, KFC. Which one do I invest in?"], ["type": "Sender", "data": "Yes of course, I would like some assistance with this. I have for franchises to select from - Starbucks, MCdondald, KFC. Which one do I invest in?"]]

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
                    
                    ScrollViewReader { proxy in
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(0..<test_input.count, id: \.self) { index in
                                VStack {
                                    HStack {
                                        if test_input[index]["type"] == "Receiver" {
                                            Text(test_input[index]["data"]!)
                                                .padding(12.5)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color("Custom_Gray"))
                                                        .opacity(0.2)
                                                )
                                                .frame(width: geometry.size.width*0.5)
                                            Spacer()
                                        } else {
                                            Spacer()
                                        
                                            Text(test_input[index]["data"]!)
                                                .padding(15)
                                                .foregroundColor(.white)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color("Secondary"))
                                                )
                                                .frame(width: geometry.size.width*0.5)
                                        }

                                    }
                                    .padding(.top, 5)
                                    .multilineTextAlignment(.leading)

                                }
                                .font(Font.custom("Nunito-SemiBold", size: min(geometry.size.width, geometry.size.height) * 0.035))
                                .id(index)
                                .onChange(of: test_input) { _ in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        proxy.scrollTo(test_input.count-1, anchor: .bottom)
                                    }
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
                                    .frame(width: geometry.size.width*0.68, height: 50)
                                
                                TextField("", text: $text_input, prompt: Text("Enter your input here...").foregroundColor(.gray).font(Font.custom("Nunito-Medium", size: 16))).padding().padding(.horizontal, geometry.size.width*0.1).frame(width: max(0, geometry.size.width-40), height: 50)
                                    .foregroundColor(.black)
                                    .font(Font.custom("Nunito-SemiBold", size: 16))
                                    .frame(width: geometry.size.width*0.68, height: 50)

                            }
                            
                            Button(action: {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    if text_input.count != 0 {
                                        test_input.append(["type": "Sender", "data": text_input])
                                        text_input = ""
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: geometry.size.width*0.05))
                                        
                                }
                                .frame(width:  geometry.size.width*0.13, height: geometry.size.height*0.065)
                                .background(Color("Secondary"))
                                .cornerRadius(100)
                            }
                        }
                    }
                }
                .frame(width: max(0, geometry.size.width-40), height: max(0, geometry.size.height - 20))
                .padding(.vertical)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
}

#Preview {
    UserChatbot()
}
