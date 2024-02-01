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
    if let datePart = components.first {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: datePart)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date!)
        return formattedDate
    }
    return("nil")
}

// GPT - REFERENCE
func isTradingWindowActive(targetDate: String, start startDate: String, end endDate: String, status: String) -> Bool? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    if status == "Cancelled" || status == "Completed" {
        return false
    } else {
        if let target = dateFormatter.date(from: targetDate),
           let start = dateFormatter.date(from: startDate),
           let end = dateFormatter.date(from: endDate) {

            return target >= start && target <= end
        }
    }
    return nil
}

func isTradingWindowComplete(targetDate: String, end endDate: String, status: String) -> Bool? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    if status == "Cancelled" {
        return false
    } else {
        if let target = dateFormatter.date(from: targetDate),
           let end = dateFormatter.date(from: endDate) {

            return target > end
        }
    }
    return nil
}

func getDaysRemaining(dateString: String) -> Int? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"

    if let futureDate = formatter.date(from: dateString) {
        let today = Date()
        let calendar = Calendar.current

        let components = calendar.dateComponents([.day], from: today, to: futureDate)
        return components.day
    }
    return nil
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
func sortArrayByDate(inputArray: [[String: String]], field_name: String, date_type: String) -> [[String: String]] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = date_type
    let sortedArray = inputArray.sorted { dict1, dict2 in
        guard let dateString1 = dict1[field_name],
              let dateString2 = dict2[field_name],
              let date1 = dateFormatter.date(from: dateString1),
              let date2 = dateFormatter.date(from: dateString2) else {
            return false
        }
        return date1 > date2
    }

    return sortedArray
}

func transformListedShares(listed_shares: [String: [[String: String]]]) -> [(key: String, value: Any)] {
    var traversed_franchises: [String:Any] = [:]
    
    for (_, subArray) in listed_shares {
        for opportunity in subArray {
            var franchise = opportunity["opportunity_name"]
            var amount = Int(opportunity["amount"]!)!
            if traversed_franchises.keys.contains(franchise!) {
                let transformed_amount = traversed_franchises[franchise!] as! Int + amount
                traversed_franchises[franchise!] = transformed_amount
            } else {
                traversed_franchises[franchise!] = amount
            }
        }
    }
    return traversed_franchises.sorted { $0.value as! Int > $1.value as! Int }
}

func transformTradingWindowData(listed_shares: [[String: String]]) -> [String: Int] {
    var traversed_trading_window: [String: Int] = [:]
    
    for share in listed_shares {
            var franchise = share["trading_window_id"]!
            var amount = Int(share["price"]!)!
            if traversed_trading_window.keys.contains("\(franchise)_trades") {
                let transformed_amount = traversed_trading_window["\(franchise)_volume"]! + amount
                let transformed_count = traversed_trading_window["\(franchise)_trades"]! + 1
                traversed_trading_window["\(franchise)_volume"] = transformed_amount
                traversed_trading_window["\(franchise)_trades"] = transformed_count
            } else {
                traversed_trading_window["\(franchise)_volume"] = amount
                traversed_trading_window["\(franchise)_trades"] = 1
            }
    }
    return traversed_trading_window
}

func textBeforeApostrophe(_ input: String) -> String? {
    guard let range = input.range(of: "'") else {
        return nil
    }
    return String(input[..<range.lowerBound])
}

func transformPayouts(payouts_array: [[String: String]]) -> [String: Any] {
    var traversed_payouts: [String:Any] = [:]
    
    for share in payouts_array {
        var franchise = share["franchise"]!
        var amount = Int(share["amount_offered"]!)!
        if traversed_payouts.keys.contains(franchise) {
            let transformed_amount = traversed_payouts[franchise] as! Int + amount
            traversed_payouts[franchise] = transformed_amount
        } else {
            traversed_payouts[franchise] = amount
        }
    }
    return traversed_payouts
}

func sortByDaysRemaining(array: [[String: String]]) -> [[String : String]] {
    var completedArray: [[String : String]] = []
    var closedArray: [[String : String]] = []
    var outputArray: [[String : String]]  = []
    
    for ind in array {
        if ind["status"]! == "Closed" {
            closedArray.append(ind)
        } else if getDaysRemaining(dateString: ind["close_date"]!)! >= 1 {
            outputArray.append(ind)
        } else {
            completedArray.append(ind)
        }
    }
    
    outputArray.sort {
           guard let closeDate1 = $0["close_date"], let closeDate2 = $1["close_date"] else {
               return false
           }
           return getDaysRemaining(dateString: closeDate1)! < getDaysRemaining(dateString: closeDate2)!
    }

    return outputArray + completedArray + closedArray
}

// Reference GPT
// Wont show listed or sold shares
func transformPayoutsArray(entries: [[String:String]]) -> [[String: String]]{
    var resultDictionary: [String: Double] = [:]
        for entry in entries {
            if let opportunityID = entry["opportunity_id"], let equity = entry["equity"], let amountReceivedString = entry["amount_received"], let amountReceived = Double(amountReceivedString) {
                let key = "\(opportunityID)-\(equity)"
                resultDictionary[key, default: 0.0] += amountReceived
            }
        }

        var resultArray: [[String: String]] = []

        for (key, value) in resultDictionary {
            let components = key.components(separatedBy: "-")
            if components.count == 2 {
                let opportunityID = components[0]
                let equity = components[1]
                let resultEntry: [String: String] = [
                    "opportunity_id": opportunityID,
                    "equity": equity,
                    "amount_received": "\(value)"
                ]
                resultArray.append(resultEntry)
            }
        }

        return resultArray
}

// Reference GPT
func convertNumberAmount(input_number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    
    switch input_number {
    case 1_000_000_000...:
        formatter.maximumFractionDigits = 1
        return "\(formatter.string(from: NSNumber(value: input_number / 1_000_000_000)) ?? "")B"
    case 1_000_000...:
        formatter.maximumFractionDigits = 1
        return "\(formatter.string(from: NSNumber(value: input_number / 1_000_000)) ?? "")M"
    case 1_000...:
        formatter.maximumFractionDigits = 1
        return "\(formatter.string(from: NSNumber(value: input_number / 1_000)) ?? "")k"
    default:
        formatter.maximumFractionDigits = 0
        return "\(formatter.string(from: NSNumber(value: input_number)) ?? "")"
    }
}

func loadFranchiseLogo(key: String) -> UIImage {
    let imageData = UserDefaults.standard.data(forKey: key)
    let cachedImage = UIImage(data: imageData!)
    return cachedImage!
}

func loadDisplayImage(key: String) -> UIImage {
    let imageData = UserDefaults.standard.data(forKey: key)
    let cachedImage = UIImage(data: imageData!)
    return cachedImage!
}


func loadProfileImage(completion: @escaping (UIImage?) -> Void) {
    if let imageData = UserDefaults.standard.data(forKey: "profile_image"), let cachedImage = UIImage(data: imageData)  {
            completion(cachedImage)
            return
    }
}

func deleteAllUserDefaultsData() {
    let keysToRemove = UserDefaults.standard.dictionaryRepresentation().keys.filter { $0 != "profile_image" }
        for key in keysToRemove {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
}
