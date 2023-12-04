//
//  MiscFunctions.swift
//  PARC
//
//  Created by Ayman Ali on 08/11/2023.
//

import Foundation
import SwiftUI

func convertDate(dateString: String) -> String {

    let components = dateString.components(separatedBy: " ")

    // The first component should contain the date part
    if let datePart = components.first {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: datePart)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date!)
        return formattedDate
    } else {
        print("Failed to extract the date.")
    }
      
//    return(formattedDate)
    return("nil")
}

func getDaysRemaining(dateString: String) -> Int? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy" // Set the date format to match "DD/MM/YYYY"

    if let futureDate = formatter.date(from: dateString) {
        let today = Date()
        let calendar = Calendar.current

        let components = calendar.dateComponents([.day], from: today, to: futureDate)
        return components.day
    }

    return nil // Return nil in case of any errors
}

func formattedNumber(input_number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter.string(from: NSNumber(value: input_number)) ?? ""
}

func calculateTotalHoldings(input: [[String: String]]) -> Int {
    
    var final_amount = 0
    
    if input.count != 0 {
        for x in input {
            final_amount += Int(x["amount"]!)!
        }
        return final_amount
    }
    return 0
}

func calculatePortionHoldings(input: [[String: String]], holdings_value: Int) -> [Float] {
    var output_array: [Float] = []
    
    if input.count != 0 {
        for holding in input {
            let amount = Float(holding["amount"]!)!
            output_array.append((amount/Float(holdings_value))*100)
//            print("-----")
        }
        return output_array
    }
    return [0]
    
}
