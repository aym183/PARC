//
//  DropdownMenu.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import SwiftUI

struct DropdownMenu: View {
    @State var isOptionsPresented: Bool = false
    @Binding var selectedOption: DropdownMenuOption?
    @State private var selectedBackground: DropdownMenuOption? = nil
    let placeholder: String
    let options: [DropdownMenuOption]
    
    let dropdownListHeight: CGFloat = 180
    let padding_bottom_value: CGFloat = 130
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.isOptionsPresented.toggle()
            }
        }) {
            HStack {
                Text(selectedOption == nil ? placeholder : selectedOption!.option)
                    .font(Font.custom("Nunito-Medium", size: 15))
                    .foregroundColor(selectedOption == nil ? .gray : .black)
                
                Spacer()
                
                Image(systemName: self.isOptionsPresented ? "chevron.up" : "chevron.down")
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
                if self.isOptionsPresented {
                    if self.options.count == 0 {
                        Spacer(minLength: dropdownListHeight - 20)
                        Text("No available options")
                            .font(Font.custom("Nunito-Medium", size: 15))
                            .foregroundColor(.black)
                        
                    } else {
                        Spacer(minLength: dropdownListHeight)
                        DropdownMenuList(options: self.options) { option in
                            self.isOptionsPresented = false
                            self.selectedOption = option
                        }
                    }
                }
            }
        }
        .padding(.bottom, self.isOptionsPresented ? padding_bottom_value : 0)
    }
}

#Preview {
    DropdownMenu(
        selectedOption: .constant(nil),
        placeholder: "Select your background",
        options: DropdownMenuOption.testAllValues
    )
}
