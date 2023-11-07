//
//  DropdownMenuListRow.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import SwiftUI

struct DropdownMenuListRow: View {
    let option: DropdownMenuOption
    let onSelectedAction: (_ option: DropdownMenuOption) -> Void
    
    var body: some View {
        Button(action: { self.onSelectedAction(option) }) {
            Text(option.option)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(Font.custom("Nunito-Medium", size: 15))
        .foregroundColor(.black)
        .padding(.vertical, 5)
        .padding(.horizontal)
    }
}

#Preview {
    DropdownMenuListRow(option: DropdownMenuOption.testSingleValue, onSelectedAction: {_ in})
}
