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
    let placeholder: String
    let options: [DropdownMenuOption]
    
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
                .stroke(.gray, lineWidth: 1.5)
        }
        .overlay {
            VStack {
                if self.isOptionsPresented {
                    Spacer(minLength: 280)
                    DropdownMenuList(options: self.options) { option in
                        self.isOptionsPresented = false
                        self.selectedOption = option
                    }
                }
            }
        }
//        .padding(.horizontal, 10)
        .padding(
            .bottom, self.isOptionsPresented
            ? CGFloat(self.options.count*32) > 300
                ? 350
                : CGFloat(self.options.count*32)
            : 0
        )
        
    }
}

#Preview {
    DropdownMenu(
        selectedOption: .constant(nil),
        placeholder: "Select your background",
        options: DropdownMenuOption.testAllValues
    )
}
