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
    @Published var secondary_market_data: [String: Any] = [:]
    @Published var user_holdings_data: [[String: String]] = []
    @Published var user_holdings_data_dropdown: [DropdownMenuOption] = []
    @Published var trading_window_data: [[String: String]] = []
    @Published var transformed_trading_window_transactions_data: [String: Int] = [:]
    @Published var trading_window_transactions_data: [[String: String]] = []
    @Published var full_user_holdings_data: [[String: String]] = []
    @Published var opportunity_data_dropdown: [DropdownMenuOption] = []
    @Published var secondary_market_transactions_ind: Int = 0
    @Published var franchise_images: [[String: UIImage]] = []
    @State var currentFormattedDate: String = convertDate(dateString: String(describing: Date()))
    @AppStorage("email") var email: String = ""
    let dispatchGroup = DispatchGroup()

    func getFranchises() {
        var temp_dict: [String: String] = [:]
        let keysArray = ["description", "avg_revenue_18_months", "name", "logo", "display_image", "industry", "no_of_franchises", "ebitda_estimate", "avg_franchise_mom_revenues", "avg_startup_capital"]
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/franchises")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String: Any]] {
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
                                    self.franchise_data.append(temp_dict)
//                                    self.getImage(path: temp_dict["logo"]!)
//                                    self.getImage(path: temp_dict["display_image"]!)
                                    
                                    self.franchise_data_dropdown.append(DropdownMenuOption(option: temp_dict["name"]!))
                                    temp_dict = [:]
                                }
//                                completion("Fetched all franchises")
                            }
                        }
                    }
                } catch {
                    print("Error getting franchises: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // Separated admin and user so that admin can get all opportunities and and user can get only active ones
    func getUserOpportunities(completion: @escaping (String?) -> Void) {
        var keysArray = ["min_invest_amount", "location", "date_created", "equity_offered", "amount_raised", "close_date", "status", "franchise", "asking_price", "opportunity_id", "investors"]
        var temp_dict: [String: String] = [:]
        
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/opportunities")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
                                           activeCheck["S"] == "Active" && getDaysRemaining(dateString: dateCheck["S"]!)! < 1 {
                                            
                                            if let nameDictionary = value[data] as? [String: String] {
                                                if data == "opportunity_id" {
                                                    if let nValue = nameDictionary["N"] {
                                                        DispatchQueue.global(qos: .userInteractive).async {
                                                            UpdateDB().updateTable(primary_key: "opportunity_id", primary_key_value: nValue, table: "opportunities", updated_key: "status", updated_value: "Completed") { response in
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
    
    func getAdminOpportunities(completion: @escaping (String?) -> Void) {
        var keysArray = ["min_invest_amount", "location", "date_created", "equity_offered", "amount_raised", "close_date", "status", "franchise", "asking_price", "opportunity_id", "investors"]
        var temp_dict: [String: String] = [:]
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/opportunities")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
//                                        if let nameDictionary = value[data] as? [String: String], let sValue = nameDictionary["S"] {
//                                            temp_dict[data] = sValue
//                                        }
                                    }
                                    let amountRaised = Int(temp_dict["amount_raised"] ?? "0") ?? 0
                                    let askingPrice = Int(temp_dict["asking_price"] ?? "1") ?? 1
                                    let ratio = Double(amountRaised) / Double(askingPrice)
                                    temp_dict["ratio"] = String(describing: ratio)
                                    self.admin_opportunity_data.append(temp_dict)
                                    self.opportunity_data_dropdown.append(DropdownMenuOption(option: "\(temp_dict["opportunity_id"]!) - \(temp_dict["franchise"]!) - \(temp_dict["location"]!) - \(temp_dict["date_created"]!)"))
                                    temp_dict = [:]
//                                    self.opportunity_data.append(value)
                                }
                                self.admin_opportunity_data = sortByDaysRemaining(array: self.admin_opportunity_data)
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
    
    func getPayouts(completion: @escaping (String?) -> Void) {
        var keysArray = ["franchise", "revenue_generated", "date_scheduled", "status", "opportunity_id", "date_created", "payout_id", "amount_offered"]
        var temp_dict: [String: String] = [:]
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
                                                    temp_dict[data] = convertDate(dateString: sValue)
                                                } else {
                                                    temp_dict[data] = sValue
                                                }
                                            }
                                        }
//                                        if let nameDictionary = value[data] as? [String: String], let sValue = nameDictionary["S"] {
//                                            temp_dict[data] = sValue
//                                        }
                                    }
                                    let revenue_generated = Int(temp_dict["revenue_generated"] ?? "0") ?? 0
                                    let amount_offered = Int(temp_dict["amount_offered"] ?? "1") ?? 1
                                    let percentage_of_revenue = (Double(amount_offered) / Double(revenue_generated))*100
                                    temp_dict["percentage_of_revenue"] = "\(String(describing: percentage_of_revenue))%"
                                    self.payout_data.append(temp_dict)
                                    temp_dict = [:]
//                                    self.opportunity_data.append(value)
                                }
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
    
    func getUserPayouts(email: String, completion: @escaping (String?) -> Void) {
        let keysArray = ["user_payout_id", "equity", "opportunity_id", "amount_received", "user_email", "payout_date"]
        var temp_dict: [String: String] = [:]
        
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts/user-payouts")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
//                                                    if let nValue = nameDictionary["N"] {
                                                    temp_dict[data] = nameDictionary["N"]
//                                                    }
                                                } else if let sValue = nameDictionary["S"] {
                                                    temp_dict[data] = sValue
                                                }
                                            }
                                        }
                                    }
                                    if temp_dict != [:] {
                                        self.user_payout_data.append(temp_dict)
                                        temp_dict = [:]
                                    }
                                }
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
    
    func getUserHoldings(email: String, completion: @escaping (String?) -> Void) {
        
        var keysArray = ["opportunity_name", "user_holdings_id", "user_email", "status", "opportunity_id", "equity", "amount", "transaction_date"]
        var temp_dict: [String: String] = [:]
        var listed_temp_dict: [String: String] = [:]
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/user-holdings")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
                                                        temp_dict[data] = convertDate(dateString: nameDictionary["S"]!)
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
                                    }
                                }
                                self.secondary_market_data = transformListedShares(listed_shares: self.listed_shares)
                                self.user_holdings_data = sortArrayByDate(inputArray: self.user_holdings_data, field_name: "transaction_date", date_type: "dd/MM/yyyy")
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
    
    func getAllUserHoldings() {
        var keysArray = ["opportunity_name", "user_holdings_id", "user_email", "status", "opportunity_id", "equity", "amount", "transaction_date"]
        var temp_dict: [String: String] = [:]
        
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/user-holdings")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
    
    func getTradingWindows() {
        var keysArray = ["trading-window-id", "start_date", "status", "duration", "trading_volume"]
        var temp_dict: [String: String] = [:]
        var current_status = ""
        var trading_window_id = ""
        var trading_window_active = false
        var trading_window_completed = false
        
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/trading-windows")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
                                                    temp_dict[data] = convertDate(dateString: sValue)
                                                } else {
                                                    temp_dict[data] = sValue
                                                }
                                            }
                                        }
                                    }
                                    self.trading_window_data.append(temp_dict)
                        
                                    if isTradingWindowActive(targetDate: currentFormattedDate, start: temp_dict["start_date"]!, end: dateStringByAddingDays(days: Int(temp_dict["duration"]!)!, dateString: temp_dict["start_date"]!)!, status: temp_dict["status"]!)! {
                                            trading_window_active = true
                                            current_status = temp_dict["status"]!
                                            trading_window_id = temp_dict["trading-window-id"]!
                                            UserDefaults.standard.set("true", forKey: "trading_window_active")
                                            UserDefaults.standard.set(temp_dict["trading-window-id"], forKey: "trading_window_id")
                                        
                                    } else if isTradingWindowComplete(targetDate: currentFormattedDate, end: dateStringByAddingDays(days: Int(temp_dict["duration"]!)!, dateString: temp_dict["start_date"]!)!, status: temp_dict["status"]!)! {
                                            trading_window_completed = true
                                            current_status = temp_dict["status"]!
                                            trading_window_id = temp_dict["trading-window-id"]!
                                            UserDefaults.standard.set("false", forKey: "trading_window_active")
                                    } else {
                                        UserDefaults.standard.set("false", forKey: "trading_window_active")
                                    }
                                    temp_dict = [:]
                                }
                                self.trading_window_data = sortArrayByDate(inputArray: self.trading_window_data, field_name: "start_date", date_type: "dd/MM/yyyy")
                                if trading_window_active && current_status == "Scheduled"  {
                                    UpdateDB().updateTable(primary_key: "trading-window-id", primary_key_value: trading_window_id, table: "trading-windows", updated_key: "status", updated_value: "Ongoing") { response in
                                        
                                        if response == "trading-windows status updated" {
                                            print("Trading window ongoing updated")
                                        }
                                        
                                    }
                                } 
                                
                                else if trading_window_completed && current_status == "Ongoing" {
                                    UpdateDB().updateTable(primary_key: "trading-window-id", primary_key_value: trading_window_id, table: "trading-windows", updated_key: "status", updated_value: "Completed") { response in
                                        
                                        if response == "trading-windows status updated" {
                                            print("Trading window completed updated")
                                        }
                                        
                                    }
                                }
                                
                                //Add converting of Ongoing to Completed
                            }
                        }
                    }
                } catch {
                    print("Error getting opportunities: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func getTradingWindowTransactions() {
//        self.transformed_trading_window_data = transformTradingWindowData(listed_shares: self.full_user_holdings_data)
        var temp_dict: [String: String] = [:]
        let keysArray = ["user_selling", "user_buying", "trading_window_id", "opportunity_id", "equity", "transaction_date", "transaction_id", "price"]
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/transactions-secondary-market")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
                                self.transformed_trading_window_transactions_data = transformTradingWindowData(listed_shares: self.trading_window_transactions_data)
//                                completion("Trading window transactions fetched")
                            }
                        }
                    }
                } catch {
                    print("Error getting franchises: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func getTradingWindowTransactionsEmail() {
        
        let keysArray = ["user_selling", "user_buying", "trading_window_id", "opportunity_id", "equity", "transaction_date", "transaction_id", "price"]
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/transactions-secondary-market")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
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
    
    func getImage(path: String) {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imageRef = storageRef.child(path)
            
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("Error fetching image: \(error.localizedDescription)")
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        if UserDefaults.standard.object(forKey: path) == nil {
                            UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: path)
                        }
                    }
            }
    }
    
    func getDisImage(path: String, completion: @escaping (UIImage?) -> Void) {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imageRef = storageRef.child(path)
            
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("Error fetching image: \(error.localizedDescription)")
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        if UserDefaults.standard.object(forKey: path) == nil {
//                            UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: path)
                            completion(image)
                        }
                    }
            }
    }
}
