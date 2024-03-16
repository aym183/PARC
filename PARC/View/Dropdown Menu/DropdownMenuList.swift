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
    let onSelectedAction: (_ option: DropdownMenuOption) -> Void
    var body: some View {
        ScrollView(showsIndicators: true) {
            LazyVStack(alignment: .leading, spacing: 2) {
                ForEach(options) { option in
                    DropdownMenuListRow(option: option, onSelectedAction: self.onSelectedAction)
                }
            }
        }
        .frame(height: 100)
        .padding(.vertical, 5)
        .overlay(alignment: .top) {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 1.25)
        }
    }
}

#Preview {
    DropdownMenuList(options: DropdownMenuOption.testAllValues, onSelectedAction: {_ in})
}
