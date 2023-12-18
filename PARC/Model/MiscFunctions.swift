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

// GPT - REFERENCE
func isTradingWindowActive(targetDate: String, start startDate: String, end endDate: String) -> Bool? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"

    if let target = dateFormatter.date(from: targetDate),
       let start = dateFormatter.date(from: startDate),
       let end = dateFormatter.date(from: endDate) {

        return target >= start && target <= end
    }

    return nil
}

func isTradingWindowComplete(targetDate: String, end endDate: String) -> Bool? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"

    if let target = dateFormatter.date(from: targetDate),
       let end = dateFormatter.date(from: endDate) {

        return target > end
    }

    return nil
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

// GPT - REFERENCE
func dateStringByAddingDays(days: Int, dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    if let inputDate = dateFormatter.date(from: dateString) {
        let calendar = Calendar.current
        if let modifiedDate = calendar.date(byAdding: .day, value: days, to: inputDate) {
            let newDateString = dateFormatter.string(from: modifiedDate)
            return newDateString
        }
    }
    
    return nil
}

func formattedNumber(input_number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter.string(from: NSNumber(value: input_number)) ?? ""
}

func calculateTotalValue(input: [[String: String]], field: String) -> Int {
    
    var final_amount = 0
    
    if input.count != 0 {
        for x in input {
            final_amount += Int(x[field]!)!
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
        }
        return output_array
    }
    return [0]
    
}

// GPT - REFERENCE
func calculatePayoutOpportunities(input: [[String: String]]) -> [Float] {
    var outputArray: [Float] = []
    var indexMap: [String: Int] = [:]

    for dict in input {
        if let opportunityID = dict["opportunity_id"] {
            if let index = indexMap[opportunityID] {
                outputArray[index] += 1
            } else {
                indexMap[opportunityID] = outputArray.count
                outputArray.append(1)
            }
        }
    }
    return outputArray
}

// GPT - REFERENCE
func sortArrayByDate(inputArray: [[String: String]]) -> [[String: String]] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    let sortedArray = inputArray.sorted { dict1, dict2 in
        guard let dateString1 = dict1["transaction_date"],
              let dateString2 = dict2["transaction_date"],
              let date1 = dateFormatter.date(from: dateString1),
              let date2 = dateFormatter.date(from: dateString2) else {
            return false
        }
        return date1 > date2
    }

    return sortedArray
}
