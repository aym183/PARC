//
//  DropdownMenuList.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//
//  Adopted from: https://github.com/aym183/openrack/blob/main/openrack/DropdownMenuList.swift

import SwiftUI

struct DropdownMenuList: View {
    let options: [DropdownMenuOption]
    let on_selected_action: (_ option: DropdownMenuOption) -> Void
    var body: some View {
        ScrollView(showsIndicators: true) {
            LazyVStack(alignment: .leading, spacing: 2) {
                ForEach(options) { option in
                    DropdownMenuListRow(selected_option: self.on_selected_action, option_init: option)
                }
            }
        }
        .frame(height: 100)
        .padding(.vertical, 5)
        .overlay(alignment: .top) {
            RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1.25)
        }
    }
}
