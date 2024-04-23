//
//  DropdownMenu.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//
//  Adopted from: https://github.com/aym183/openrack/blob/main/openrack/DropdownMenu.swift

import SwiftUI

struct DropdownMenu: View {
    @State var is_options_presented: Bool = false
    @Binding var selected_option: DropdownMenuOption?
    @State private var selected_background: DropdownMenuOption? = nil
    let placeholder: String
    let options: [DropdownMenuOption]
    let dropdown_list_height: CGFloat = 180
    let padding_bottom_value: CGFloat = 130
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.is_options_presented.toggle()
            }
        }) {
            HStack {
                Text(selected_option == nil ? placeholder : selected_option!.option)
                    .font(Font.custom("Nunito-Medium", size: 15))
                    .foregroundColor(selected_option == nil ? .gray : .black)
                
                Spacer()
                
                Image(systemName: self.is_options_presented ? "chevron.up" : "chevron.down")
                    .fontWeight(.medium)
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 1.25)
        }
        .overlay {
            VStack {
                if self.is_options_presented {
                    if self.options.count == 0 {
                        Spacer(minLength: dropdown_list_height - 20)
                        Text("No available options")
                            .font(Font.custom("Nunito-Medium", size: 15))
                            .foregroundColor(.black)
                        
                    } else {
                        Spacer(minLength: dropdown_list_height)
                        DropdownMenuList(options: self.options) { option in
                            self.is_options_presented = false
                            self.selected_option = option
                        }
                    }
                }
            }
        }
        .padding(.bottom, self.is_options_presented ? padding_bottom_value : 0)
    }
}
