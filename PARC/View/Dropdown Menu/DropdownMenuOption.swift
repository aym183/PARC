//
//  DropdownMenuOption.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//
//  Adopted from: https://github.com/aym183/openrack/blob/main/openrack/DropdownMenus.swift

import Foundation

struct DropdownMenuOption: Identifiable, Hashable {
    let id = UUID().uuidString
    let option: String
}

extension DropdownMenuOption {
    static let testSingleValue: DropdownMenuOption = DropdownMenuOption(option: "Asset Management")
    static let testAllValues: [DropdownMenuOption] = [
        DropdownMenuOption(option: "Asset Management"),
        DropdownMenuOption(option: "Investment banking"),
        DropdownMenuOption(option: "Engineer"),
        DropdownMenuOption(option: "Sales"),
        DropdownMenuOption(option: "Product Management"),
        DropdownMenuOption(option: "Business Owner")
    ]
    static let boolValues: [DropdownMenuOption] = [
        DropdownMenuOption(option: "Yes"),
        DropdownMenuOption(option: "No")
    ]
}
