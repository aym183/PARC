//
//  ReadDB.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import Foundation
import SwiftUI
import FirebaseStorage
import Dispatch

class ReadDB: ObservableObject {
    @Published var franchise_data_dropdown: [DropdownMenuOption] = []
    @Published var franchise_data: [[String: String]] = []
    @Published var admin_opportunity_data: [[String: String]] = []
    @Published var user_opportunity_data: [[String: String]] = []
    @Published var payout_data: [[String: String]] = []
    @Published var user_payout_data: [[String: String]] = []
    @Published var listed_shares: [String: [[String: String]]] = [:]
    @Published var secondary_market_data: [(key: String, value: Any)] = []
    @Published var user_holdings_data: [[String: String]] = []
    @Published var sold_shares: [[String: String]] = []
    @Published var user_holdings_data_dropdown: [DropdownMenuOption] = []
    @Published var trading_window_data: [[String: String]] = []
    @Published var transformed_trading_window_transactions_data: [String: Int] = [:]
    @Published var trading_window_transactions_data: [[String: String]] = []
    @Published var full_user_holdings_data: [[String: String]] = []
    @Published var opportunity_data_dropdown: [DropdownMenuOption] = []
    @Published var secondary_market_transactions_ind: Int = 0
    @Published var franchise_images: [[String: UIImage]] = []
    @State var current_formatted_date: String = convert_date(dateString: String(describing: Date()))
    @AppStorage("email") var email: String = ""
    let dispatch_group = DispatchGroup()
    let api_key = AppConfig.apiKey
    
    /// Retrieves all the franchises data from the database. This is base information displayed on the home page to all investors
    func get_franchises() {
        var temp_dict: [String: String] = [:]
        let keysArray = ["description", "avg_revenue_18_months", "name", "logo", "display_image", "industry", "no_of_franchises", "ebitda_estimate", "avg_franchise_mom_revenues", "avg_startup_capital"]
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/franchises")! // Cloudfront CDN
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String: Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let nameDictionary = value[data] as? [String: String] {
                                            if let sValue = nameDictionary["S"] {
                                                temp_dict[data] = sValue
                                            }
                                        }
                                    }
                                    self.franchise_data.append(temp_dict)
                                    
                                    // Fetching images from the cache
                                    if UserDefaults.standard.object(forKey: temp_dict["logo"]!) == nil {
                                        self.get_image(path: temp_dict["logo"]!)
                                    }
                                    
                                    if UserDefaults.standard.object(forKey: temp_dict["display_image"]!) == nil {
                                        self.get_image(path: temp_dict["display_image"]!)
                                    }
                                    
                                    self.franchise_data_dropdown.append(DropdownMenuOption(option: temp_dict["name"]!))
                                    temp_dict = [:]
                                }
                            }
                        }
                    }
                } catch {
                    print("Error getting franchises: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Retrieves all the opportunities visible to users. This is only the active opprtunities that are available to invest.
    func get_user_opportunities(completion: @escaping (String?) -> Void) {
        var keysArray = ["min_invest_amount", "location", "date_created", "equity_offered", "amount_raised", "close_date", "status", "franchise", "asking_price", "opportunity_id", "investors"]
        var temp_dict: [String: String] = [:]
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/opportunities")! // Cloudfront CDN
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String : Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let activeCheck = value["status"] as? [String: String],
                                           let dateCheck = value["close_date"] as? [String: String],
                                           activeCheck["S"] == "Active" && get_days_remaining(date_input: dateCheck["S"]!)! < 1 {
                                            
                                            if let nameDictionary = value[data] as? [String: String] {
                                                if data == "opportunity_id" {
                                                    if let nValue = nameDictionary["N"] {
                                                        DispatchQueue.global(qos: .userInteractive).async {
                                                            UpdateDB().update_table(primary_key: "opportunity_id", primary_key_value: nValue, table: "opportunities", updated_key: "status", updated_value: "Completed") { response in
                                                                if response == "opportunities status updated" {
                                                                    print("opportunities status updated")
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        } else if let activeCheck = value["status"] as? [String: String], activeCheck["S"] == "Active"  {
                                            if let nameDictionary = value[data] as? [String: String] {
                                                if data == "opportunity_id" {
                                                    if let nValue = nameDictionary["N"] {
                                                        temp_dict[data] = nValue
                                                    }
                                                } else if let sValue = nameDictionary["S"] {
                                                    temp_dict[data] = sValue
                                                }
                                            }
                                        }
                                    }
                                    let amountRaised = Int(temp_dict["amount_raised"] ?? "0") ?? 0
                                    let askingPrice = Int(temp_dict["asking_price"] ?? "1") ?? 1
                                    let ratio = Double(amountRaised) / Double(askingPrice)
                                    if ratio != 0.0 {
                                        temp_dict["ratio"] = String(describing: ratio)
                                        self.user_opportunity_data.append(temp_dict)
                                    } else if temp_dict.count != 0 {
                                        temp_dict["ratio"] = "0.000001"
                                        self.user_opportunity_data.append(temp_dict)
                                    }
                                    temp_dict = [:]
                                }
                                self.user_opportunity_data = sort_by_days_remaining(array: self.user_opportunity_data)
                                completion("Fetched all opportunities")
                            }
                        }
                    }
                } catch {
                    print("Error getting opportunities: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Retrieves all the opportunities visible from the database. This is different to the previuous function as admins should be able to see all opportunities
    func get_admin_opportunities(completion: @escaping (String?) -> Void) {
        var keysArray = ["min_invest_amount", "location", "date_created", "equity_offered", "amount_raised", "close_date", "status", "franchise", "asking_price", "opportunity_id", "investors"]
        var temp_dict: [String: String] = [:]
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/opportunities")! // Cloudfront CDN
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String : Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let nameDictionary = value[data] as? [String: String] {
                                            if data == "opportunity_id" {
                                                if let nValue = nameDictionary["N"] {
                                                    temp_dict[data] = nValue
                                                }
                                            } else if let sValue = nameDictionary["S"] {
                                                temp_dict[data] = sValue
                                            }
                                        }
                                    }
                                    
                                    // Calculating how much of the target amount has been raised
                                    let amountRaised = Int(temp_dict["amount_raised"] ?? "0") ?? 0
                                    let askingPrice = Int(temp_dict["asking_price"] ?? "1") ?? 1
                                    let ratio = Double(amountRaised) / Double(askingPrice)
                                    temp_dict["ratio"] = String(describing: ratio)
                                    self.admin_opportunity_data.append(temp_dict)
                                    if temp_dict["status"] == "Completed" {
                                        self.opportunity_data_dropdown.append(DropdownMenuOption(option: "\(temp_dict["opportunity_id"]!) - \(temp_dict["franchise"]!) - \(temp_dict["location"]!) - \(temp_dict["date_created"]!)"))
                                    }
                                    temp_dict = [:]
                                }
                                // Sort in such a way that active shows first sorted then completed shows one
                                self.admin_opportunity_data = sort_by_days_remaining(array: self.admin_opportunity_data)
                                completion("Fetched all opportunities")
                            }
                        }
                    }
                } catch {
                    print("Error getting opportunities: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Retrieves all high-level payouts information such as total amount given out to investors
    func get_payouts(completion: @escaping (String?) -> Void) {
        var keysArray = ["franchise", "revenue_generated", "date_scheduled", "status", "opportunity_id", "date_created", "payout_id", "amount_offered"]
        var temp_dict: [String: String] = [:]
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/payouts")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String : Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let nameDictionary = value[data] as? [String: String] {
                                            if data == "opportunity_id" || data == "payout_id" {
                                                if let nValue = nameDictionary["N"] {
                                                    temp_dict[data] = nValue
                                                }
                                            } else if let sValue = nameDictionary["S"] {
                                                if data == "date_created" || data == "date_scheduled" {
                                                    temp_dict[data] = convert_date(dateString: sValue)
                                                } else {
                                                    temp_dict[data] = sValue
                                                }
                                            }
                                        }
                                    }
                                    let revenue_generated = Int(temp_dict["revenue_generated"] ?? "0") ?? 0
                                    let amount_offered = Int(temp_dict["amount_offered"] ?? "1") ?? 1
                                    let percentage_of_revenue = (Double(amount_offered) / Double(revenue_generated))*100
                                    temp_dict["percentage_of_revenue"] = "\(String(describing: percentage_of_revenue))%"
                                    self.payout_data.append(temp_dict)
                                    temp_dict = [:]
                                }
                                self.payout_data = sort_array_by_date(inputArray: self.payout_data, field_name: "date_created", date_type: "dd/MM/yyyy")
                                completion("Fetched payouts")
                            }
                        }
                    }
                } catch {
                    print("Error getting payots: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Fetches all individual payouts sent to users from the database. This wil include granular information such as how much a user has earned in payouts during an opportunity's lifetime
    /// - Parameters:
    ///   - email: Email of the user for whom payouts need to be checked
    func get_user_payouts(email: String, completion: @escaping (String?) -> Void) {
        let keysArray = ["user_payout_id", "equity", "opportunity_id", "amount_received", "user_email", "payout_date"]
        var temp_dict: [String: String] = [:]
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/payouts/user-payouts")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String : Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let emailCheck = value["user_email"] as? [String: String], emailCheck["S"] == email {
                                            if let nameDictionary = value[data] as? [String: String] {
                                                if data == "user_payout_id" {
                                                    temp_dict[data] = nameDictionary["N"]
                                                } else if let sValue = nameDictionary["S"] {
                                                    if data == "date_created" {
                                                        temp_dict[data] = convert_date(dateString: sValue)
                                                    } else {
                                                        temp_dict[data] = sValue
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if temp_dict != [:] {
                                        self.user_payout_data.append(temp_dict)
                                        temp_dict = [:]
                                    }
                                }
                                self.user_payout_data = sort_array_by_date(inputArray: self.user_payout_data, field_name: "date_created", date_type: "dd/MM/yyyy")
                                completion("Fetched user payouts")
                            }
                        }
                    }
                } catch {
                    print("Error getting user payots: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Fetches a user's investment holdings from the database
    /// - Parameters:
    ///   - email: Email of the user for whom holdings need to be retrieved
    func get_user_holdings(email: String, completion: @escaping (String?) -> Void) {
        var keysArray = ["opportunity_name", "user_holdings_id", "user_email", "status", "opportunity_id", "equity", "amount", "transaction_date"]
        var temp_dict: [String: String] = [:]
        var listed_temp_dict: [String: String] = [:]
        var sold_temp_dict: [String: String] = [:]
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/user-holdings")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String : Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let ownedCheck = value["status"] as? [String: String], let emailCheck = value["user_email"] as? [String: String], emailCheck["S"] == email && ownedCheck["S"] == "Owned" {
                                            if let nameDictionary = value[data] as? [String: String] {
                                                if data == "opportunity_id" || data == "user_holdings_id" {
                                                    temp_dict[data] = nameDictionary["N"]
                                                } else if data == "transaction_date" {
                                                    temp_dict[data] = convert_date(dateString: nameDictionary["S"]!)
                                                } else if let sValue = nameDictionary["S"] {
                                                    temp_dict[data] = sValue
                                                }
                                            }
                                        } else if let listedCheck = value["status"] as? [String: String], let emailCheck = value["user_email"] as? [String: String], listedCheck["S"] == "Listed" && emailCheck["S"] != email {
                                            if let nameDictionary = value[data] as? [String: String] {
                                                if data == "opportunity_id" || data == "user_holdings_id" {
                                                    listed_temp_dict[data] = nameDictionary["N"]
                                                }
                                                else if let sValue = nameDictionary["S"] {
                                                    listed_temp_dict[data] = sValue
                                                }
                                            }
                                        } else if let ownedCheck = value["status"] as? [String: String], let emailCheck = value["user_email"] as? [String: String], emailCheck["S"] == email && ownedCheck["S"] == "Sold" {
                                            if let nameDictionary = value[data] as? [String: String] {
                                                if data == "opportunity_id" || data == "user_holdings_id" {
                                                    sold_temp_dict[data] = nameDictionary["N"]
                                                } else if data == "transaction_date" {
                                                    sold_temp_dict[data] = convert_date(dateString: nameDictionary["S"]!)
                                                } else if let sValue = nameDictionary["S"] {
                                                    sold_temp_dict[data] = sValue
                                                }
                                            }
                                        }
                                    }
                                    if temp_dict != [:] {
                                        self.user_holdings_data.append(temp_dict)
                                        self.user_holdings_data_dropdown.append(DropdownMenuOption(option: "\(temp_dict["user_holdings_id"]!) - \(temp_dict["opportunity_name"]!) - £\(temp_dict["amount"]!) - \( temp_dict["transaction_date"]!)"))
                                        temp_dict = [:]
                                    } else if listed_temp_dict != [:] {
                                        if self.listed_shares.keys.contains(listed_temp_dict["opportunity_name"]!) {
                                            self.listed_shares[listed_temp_dict["opportunity_name"]!]!.append(listed_temp_dict)
                                        } else {
                                            self.listed_shares[listed_temp_dict["opportunity_name"]!] = [listed_temp_dict]
                                        }
                                        listed_temp_dict = [:]
                                    } else if sold_temp_dict != [:] {
                                        self.sold_shares.append(sold_temp_dict)
                                        sold_temp_dict = [:]
                                    }
                                }
                                self.secondary_market_data = transform_listed_shares(listed_shares: self.listed_shares)
                                self.user_holdings_data = sort_array_by_date(inputArray: self.user_holdings_data, field_name: "transaction_date", date_type: "dd/MM/yyyy")
                                self.sold_shares = sort_array_by_date(inputArray: self.sold_shares, field_name: "transaction_date", date_type: "dd/MM/yyyy")
                                completion("Fetched user holdings")
                            }
                        }
                    }
                } catch {
                    print("Error getting payots: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Retrieves all user holdings for the admin to keep track of investments made for an opportunity
    func get_all_user_holdings() {
        var keysArray = ["opportunity_name", "user_holdings_id", "user_email", "status", "opportunity_id", "equity", "amount", "transaction_date"]
        var temp_dict: [String: String] = [:]
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/user-holdings")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String : Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let nameDictionary = value[data] as? [String: String] {
                                            if data == "opportunity_id" || data == "user_holdings_id" {
                                                temp_dict[data] = nameDictionary["N"]
                                            }
                                            else if let sValue = nameDictionary["S"] {
                                                temp_dict[data] = sValue
                                            }
                                        }
                                    }
                                    if temp_dict != [:] {
                                        self.full_user_holdings_data.append(temp_dict)
                                        temp_dict = [:]
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("Error getting payots: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Retrieves all trading windows from the database for the admin to manage each
    func get_trading_windows() {
        var keysArray = ["trading-window-id", "start_date", "status", "duration", "trading_volume"]
        var temp_dict: [String: String] = [:]
        var current_status = ""
        var trading_window_id = ""
        var trading_window_active = false
        var trading_window_completed = false
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/trading-windows")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async { [self] in
                            if let itemsArray = jsonObject["Items"] as? [[String : Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let nameDictionary = value[data] as? [String: String] {
                                            if data == "trading-window-id" {
                                                if let nValue = nameDictionary["N"] {
                                                    temp_dict[data] = nValue
                                                }
                                            } else if let sValue = nameDictionary["S"] {
                                                if data == "start_date" {
                                                    temp_dict[data] = convert_date(dateString: sValue)
                                                } else {
                                                    temp_dict[data] = sValue
                                                }
                                            }
                                        }
                                    }
                                    self.trading_window_data.append(temp_dict)
                                    
                                    if is_trading_window_active(targetDate: current_formatted_date, start: temp_dict["start_date"]!, end: date_string_by_adding_days(days: Int(temp_dict["duration"]!)!, dateString: temp_dict["start_date"]!)!, status: temp_dict["status"]!)! {
                                        trading_window_active = true
                                        current_status = temp_dict["status"]!
                                        trading_window_id = temp_dict["trading-window-id"]!
                                        UserDefaults.standard.set("true", forKey: "trading_window_active")
                                        UserDefaults.standard.set(temp_dict["trading-window-id"], forKey: "trading_window_id")
                                        
                                    } else if is_trading_window_complete(targetDate: current_formatted_date, end: date_string_by_adding_days(days: Int(temp_dict["duration"]!)!, dateString: temp_dict["start_date"]!)!, status: temp_dict["status"]!)! {
                                        trading_window_completed = true
                                        current_status = temp_dict["status"]!
                                        trading_window_id = temp_dict["trading-window-id"]!
                                        UserDefaults.standard.set("false", forKey: "trading_window_active")
                                    }
                                    temp_dict = [:]
                                }
                                self.trading_window_data = sort_array_by_date(inputArray: self.trading_window_data, field_name: "start_date", date_type: "dd/MM/yyyy")
                                if trading_window_active && current_status == "Scheduled"  {
                                    UpdateDB().update_table(primary_key: "trading-window-id", primary_key_value: trading_window_id, table: "trading-windows", updated_key: "status", updated_value: "Ongoing") { response in
                                        
                                        if response == "trading-windows status updated" {
                                            print("Trading window ongoing updated")
                                        }
                                        
                                    }
                                }
                                
                                else if trading_window_completed && current_status == "Ongoing" {
                                    UpdateDB().update_table(primary_key: "trading-window-id", primary_key_value: trading_window_id, table: "trading-windows", updated_key: "status", updated_value: "Completed") { response in
                                        
                                        if response == "trading-windows status updated" {
                                            print("Trading window completed updated")
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("Error getting opportunities: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Retrieves all trading window transactions to show each trading window's performance to the admin
    func get_trading_window_transactions() {
        var temp_dict: [String: String] = [:]
        let keysArray = ["user_selling", "user_buying", "trading_window_id", "opportunity_id", "equity", "transaction_date", "transaction_id", "price"]
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/transactions-secondary-market")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String: Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let nameDictionary = value[data] as? [String: String] {
                                            if data == "opportunity_id" || data == "trading_window_id" || data == "transaction_id" {
                                                if let nValue = nameDictionary["N"] {
                                                    temp_dict[data] = nValue
                                                }
                                            } else if let sValue = nameDictionary["S"] {
                                                temp_dict[data] = sValue
                                            }
                                        }
                                    }
                                    self.trading_window_transactions_data.append(temp_dict)
                                    temp_dict = [:]
                                }
                                self.transformed_trading_window_transactions_data = transform_trading_window_data(listed_shares: self.trading_window_transactions_data)
                            }
                        }
                    }
                } catch {
                    print("Error getting franchises: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Retrieves all trading window transactions that involves the seller being the logged in user. This is to add the balance from sales to the user's withdrawable amount
    func get_trading_window_transactions_email() {
        let keysArray = ["user_selling", "user_buying", "trading_window_id", "opportunity_id", "equity", "transaction_date", "transaction_id", "price"]
        let apiUrl = URL(string: "https://d2nin7ltw63dl6.cloudfront.net/transactions-secondary-market")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String: Any]] {
                                for value in itemsArray.reversed() {
                                    for data in keysArray.reversed() {
                                        if let emailCheck = value["user_selling"] as? [String: String], emailCheck["S"] == self.email {
                                            if let nameDictionary = value[data] as? [String: String] {
                                                if data == "price" {
                                                    if let sValue = nameDictionary["S"] {
                                                        self.secondary_market_transactions_ind += Int(sValue)!
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("Error getting franchises: \(error.localizedDescription)")
                }
            }
        }.resume()
        
    }
    
    
    /// Retrieves an image from Firebase Storage
    /// - Parameter path: The path from which the image is retrieved
    func get_image(path: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path)
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
            }
            
            if let data = data, let image = UIImage(data: data) {
                UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: path)
            }
        }
    }
    
    
    /// Retrieves an image from Firebase Storage
    /// - Parameter path: The path from which the image is retrieved
    func get_dis_image(path: String, completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path)
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
            }
            
            if let data = data, let image = UIImage(data: data) {
                if UserDefaults.standard.object(forKey: path) == nil {
                    completion(image)
                }
            }
        }
    }
}
