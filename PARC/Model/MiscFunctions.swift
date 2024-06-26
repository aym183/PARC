//
//  MiscFunctions.swift
//  PARC
//
//  Created by Ayman Ali on 08/11/2023.
//

import Foundation
import SwiftUI

/// Converts dates from "yyyy-MM-dd" to dd/MM/yyyy format
/// - Parameter dateString: Original date string
/// - Returns: Modified date string
func convert_date(dateString: String) -> String {
    
    let components = dateString.components(separatedBy: " ")
    if let datePart = components.first {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: datePart)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let unwrappedDate = date {
            let formattedDate = dateFormatter.string(from: unwrappedDate)
            return formattedDate
        } else {
            return("nil")
        }
    }
    return("nil")
}

/// Checks to see if Secondary Market trading windows are active (i.e. if target date is within the start and end date)
/// - Parameters:
///   - targetDate: The current date
///   - startDate: Start of the trading window
///   - endDate: End of the trading window
///   - status: Current status of the trading window
/// - Returns: Boolean identifying if the trading window is active
func is_trading_window_active(targetDate: String, start startDate: String, end endDate: String, status: String) -> Bool? {
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


/// Checks to see if Secondary Market trading windows are completed (i.e. if target date after the end date)
/// - Parameters:
///   - targetDate: The current date
///   - endDate: End of the trading window
///   - status: Current status of the trading window
/// - Returns: Boolean identifying if the trading window is completed
func is_trading_window_complete(targetDate: String, end endDate: String, status: String) -> Bool? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    if status == "Cancelled" || status == "Completed" {
        return false
    } else {
        if let target = dateFormatter.date(from: targetDate),
           let end = dateFormatter.date(from: endDate) {
            return target > end
        }
    }
    return nil
}


/// Takes a date and returns the days remaining till that date from present day
/// - Parameter date_input: Date to compare
/// - Returns: Integer showing the number of days remaining
func get_days_remaining(date_input: String) -> Int? {
    let date_formatter = DateFormatter()
    date_formatter.dateFormat = "dd/MM/yyyy"
    
    if let future_date = date_formatter.date(from: date_input) {
        let current_date = Date()
        let current_calendar = Calendar.current
        let output_components = current_calendar.dateComponents([.day], from: current_date, to: future_date)
        
        if output_components.day! < 0 {
            return 0
        } else {
            return output_components.day
        }
    }
    return nil
}

/// Fetches the date after adding x number of days
/// - Parameters:
///   - days: Number of days to add
///   - dateString: Date to start with
/// - Returns: Formatted date after adding days
func date_string_by_adding_days(days: Int, dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    if days <= 0 {
        return dateString
    }
    
    if let inputDate = dateFormatter.date(from: dateString) {
        let calendar = Calendar.current
        if let modifiedDate = calendar.date(byAdding: .day, value: days, to: inputDate) {
            let newDateString = dateFormatter.string(from: modifiedDate)
            return newDateString
        }
    }
    
    return nil
}


/// Takes a number and returns it as a formatted string with the appropriate ","
/// - Parameter input_number: Number to be formatted
/// - Returns: Formatted number
func formatted_number(input_number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter.string(from: NSNumber(value: input_number)) ?? ""
}


/// Takes an array of arrays and calculates the total value by parsing through the values at key x of each index
/// - Parameters:
///   - input: Array of arrays to be parsed
///   - field: Key from which values are to be fetched
/// - Returns: Total value
func calculate_total_value(input: [[String: String]], field: String) -> Int {
    
    var final_amount = 0
    if input.count != 0 {
        for x in input {
            if let fieldValue = x[field], let intValue = Int(fieldValue) {
                final_amount += intValue
            } else {
                final_amount += 0
            }
        }
        return final_amount
    }
    return 0
}


/// Takes an array and calculates the % each holding contributes to the total value
/// - Parameters:
///   - input: Array of arrays of user holdings
///   - holdings_value: Total value of holdings
/// - Returns: Array with the split of each holding and its contribution
func calculate_portion_holdings(input: [[String: String]], holdings_value: Int) -> [Float] {
    var output_array: [Float] = []
    if input.count != 0 {
        for holding in input {
            if let amountString = holding["amount"], let amountValue = Float(amountString) {
                output_array.append((amountValue/Float(holdings_value))*100)
            } else {
                output_array.append(0)
            }
        }
        return output_array
    }
    return [0]
}


/// Calculates how much a user recived in payouts for each holding
/// - Parameter input: Array of arrays of holdings
/// - Returns: Payouts for each holding
func calculate_payout_opportunities(input: [[String: String]]) -> [Float] {
    var outputArray: [Float] = []
    var indexMap: [String: Int] = [:]
    
    for dict in input {
        if let opportunityID = dict["opportunity_id"],
           let equity = dict["equity"] {
            let uniqueIdentifier = "\(opportunityID)-\(equity)"
            
            if let index = indexMap[uniqueIdentifier] {
                outputArray[index] += 1
            } else {
                indexMap[uniqueIdentifier] = outputArray.count
                outputArray.append(1)
            }
        }
    }
    return outputArray
}

/// Sorts an array by the date in descending order
/// - Parameters:
///   - inputArray: Array of arrays containing a date key
///   - field_name: Date key name
///   - date_type: Format of the date values
/// - Returns: Sorted date array
func sort_array_by_date(inputArray: [[String: String]], field_name: String, date_type: String) -> [[String: String]] {
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


/// Fetches the total amount of holdings available in secondary market listings per franchise
/// - Parameter listed_shares: Array of arrays containing the listed shares
/// - Returns: Array containing the total value of each franchise's listings
func transform_listed_shares(listed_shares: [String: [[String: String]]]) -> [(key: String, value: Any)] {
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


/// Fetches the total volume and number of trades for each secondary market trading window
/// - Parameter listed_shares: Array of arrays of all listed shares
/// - Returns: total figures for each trading window
func transform_trading_window_data(listed_shares: [[String: String]]) -> [String: Int] {
    var traversed_trading_window: [String: Int] = [:]
    
    for share in listed_shares {
        if let tradingWindowID = share["trading_window_id"] {
            var franchise = tradingWindowID
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
        } else {
            return ["nil": 0]
        }
    }
    return traversed_trading_window
}


/// Fetches characters from a string before an apostrophe
/// - Parameter input: String to be used
/// - Returns: String before apostrophe
func text_before_apostrophe(_ input: String) -> String? {
    guard let range = input.range(of: "'") else {
        return nil
    }
    return String(input[..<range.lowerBound])
}


/// Calculates how much payouts was sent out for each franchise
/// - Parameter payouts_array: Array of arrays containing payouts
/// - Returns: Total payouts for each franchise
func transform_payouts(payouts_array: [[String: String]]) -> [String: Any] {
    var traversed_payouts: [String:Any] = [:]
    
    for share in payouts_array {
        if let franchise = share["franchise"] {
            var amount = Int(share["amount_offered"]!)!
            if traversed_payouts.keys.contains(franchise) {
                let transformed_amount = traversed_payouts[franchise] as! Int + amount
                traversed_payouts[franchise] = transformed_amount
            } else {
                traversed_payouts[franchise] = amount
            }
        } else {
            return ["null": 0]
        }
    }
    return traversed_payouts
}


/// Uses the get_days_remaining function to sort an array based on these values
/// - Parameter array: Array of arrays
/// - Returns: Sorted array
func sort_by_days_remaining(array: [[String: String]]) -> [[String : String]] {
    var completedArray: [[String : String]] = []
    var closedArray: [[String : String]] = []
    var outputArray: [[String : String]]  = []
    
    for ind in array {
        if let status = ind["status"] {
            if status == "Closed" {
                closedArray.append(ind)
            } else if status == "Completed" {
                completedArray.append(ind)
            } else if get_days_remaining(date_input: ind["close_date"]!)! >= 1  {
                outputArray.append(ind)
            }
        } else {
            return [["null": "0"]]
        }
    }
    
    outputArray.sort {
        guard let closeDate1 = $0["close_date"], let closeDate2 = $1["close_date"] else {
            return false
        }
        return get_days_remaining(date_input: closeDate1)! < get_days_remaining(date_input: closeDate2)!
    }
    
    return outputArray + completedArray + closedArray
}

/// Calculates total paouts received by a user as part of their active portfolio (i.e. No listed or sold shares)
/// - Parameter entries: Array of arrays containing payouts
/// - Returns: Split of each payout with details about the opportunity it belongs to
func transform_payouts_array(entries: [[String:String]]) -> [[String: String]]{
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


///  Function that transforms numbers (example: 1000000 -> 1M)
/// - Parameter input_number: Number to be converted
/// - Returns: Transformed number
func convert_number_amount(input_number: Double) -> String {
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


/// Fetches UIImage record from cache
/// - Parameter key: Record of cache
/// - Returns: UIImage
func load_franchise_logo(key: String) -> UIImage {
    let imageData = UserDefaults.standard.data(forKey: key)
    let cachedImage = UIImage(data: imageData!)
    return cachedImage!
}


/// Fetches UIImage record from cache
/// - Parameter key: Record of cache
/// - Returns: UIImage
func load_display_image(key: String) -> UIImage {
    let imageData = UserDefaults.standard.data(forKey: key)
    let cachedImage = UIImage(data: imageData!)
    return cachedImage!
}


/// Fetches UIImage record from cache
/// - Parameter key: Record of cache
/// - Returns: UIImage
func load_profile_image(completion: @escaping (UIImage?) -> Void) {
    if let imageData = UserDefaults.standard.data(forKey: "profile_image"), let cachedImage = UIImage(data: imageData)  {
        completion(cachedImage)
        return
    }
}


/// Deletes all UserDefaults
func delete_all_user_defaults_data() {
    let keysToRemove = UserDefaults.standard.dictionaryRepresentation().keys.filter { $0 != "profile_image" }
    for key in keysToRemove {
        UserDefaults.standard.removeObject(forKey: key)
    }
    UserDefaults.standard.synchronize()
}
