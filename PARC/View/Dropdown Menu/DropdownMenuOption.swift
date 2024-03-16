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
