//
//  DropdownMenuListRow.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//  Adopted from: https://github.com/aym183/openrack/blob/main/openrack/DropdownMenuListRow.swift

import SwiftUI

struct DropdownMenuListRow: View {
    let selected_option: (_ option: DropdownMenuOption) -> Void
    let option_init: DropdownMenuOption
    
    var body: some View {
        Button(action: { self.selected_option(option_init) }) {
            Text(option_init.option)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(Font.custom("Nunito-Medium", size: 15))
        .foregroundColor(.black)
        .padding(.vertical, 5).padding(.horizontal)
    }
}
