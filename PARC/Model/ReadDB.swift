//
//  ReadDB.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import Foundation
import SwiftUI

class ReadDB: ObservableObject {
    @Published var franchise_data_dropdown: [DropdownMenuOption] = []
    @Published var franchise_data: [[String: String]] = []
    @Published var opportunity_data: [[String: String]] = []
    @Published var payout_data: [[String: String]] = []
    @Published var user_holdings_data: [[String: String]] = []
    @Published var opportunity_data_dropdown: [DropdownMenuOption] = []
    
    func getFranchises() {
        var temp_dict: [String: String] = [:]
        let keysArray = ["description", "avg_revenue_18_months", "name", "logo", "industry", "no_of_franchises", "ebitda_estimate", "avg_franchise_mom_revenues", "avg_startup_capital"]
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
                                    self.franchise_data_dropdown.append(DropdownMenuOption(option: temp_dict["name"]!))
                                    temp_dict = [:]
//                                    print(value)
//                                    if let nameDictionary = value["name"] as? [String: String], let sValue = nameDictionary["S"] {
//                                        self.franchise_data_dropdown.append(DropdownMenuOption(option: sValue))
//                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("Error getting franchises: \(error.localizedDescription)")
                }
            }
//                    print(responseText)
//                let decoder = JSONDecoder()
//                if let result = try? decoder.decode(Data.self, from: data) {
//                    print("Error here")
//                    self.franchise_data = result
//                }
//                
//            } else if let error = error {
//                DispatchQueue.main.async {
//                    print("Error getting franchises: \(error.localizedDescription)")
//                }
//            }
        }.resume()
    }
    
    func getOpportunities(completion: @escaping (String?) -> Void) {
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
                                    self.opportunity_data.append(temp_dict)
                                    self.opportunity_data_dropdown.append(DropdownMenuOption(option: "\(temp_dict["opportunity_id"]!) - \(temp_dict["franchise"]!) - \(temp_dict["location"]!) - \(temp_dict["date_created"]!)"))
                                    temp_dict = [:]
//                                    self.opportunity_data.append(value)
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
    
    func getPayouts() {
        var keysArray = ["revenue_generated", "date_scheduled", "status", "opportunity_id", "date_created", "payout_id", "amount_offered"]
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
                                                temp_dict[data] = sValue
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
                            }
                        }
                    }
                } catch {
                    print("Error getting payots: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func getUserHoldings(email: String, completion: @escaping (String?) -> Void) {
        
        var keysArray = ["user_holdings_id", "user_email", "status", "opportunity_id", "equity", "amount", "transaction_date"]
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
                                        if let emailCheck = value["user_email"] as? [String: String], emailCheck["S"] == email {
                                            if let nameDictionary = value[data] as? [String: String] {
                                                    if data == "opportunity_id" || data == "user_holdings_id" {
                                                            temp_dict[data] = nameDictionary["N"]
                                                    }
                                                    else if let sValue = nameDictionary["S"] {
                                                        temp_dict[data] = sValue
                                                    }
                                            }
                                        }
//                                        if let nameDictionary = value[data] as? [String: String], let sValue = nameDictionary["S"] {
//                                            temp_dict[data] = sValue
//                                        }
                                    }
//                                    let revenue_generated = Int(temp_dict["revenue_generated"] ?? "0") ?? 0
//                                    let amount_offered = Int(temp_dict["amount_offered"] ?? "1") ?? 1
//                                    let percentage_of_revenue = (Double(amount_offered) / Double(revenue_generated))*100
//                                    temp_dict["percentage_of_revenue"] = "\(String(describing: percentage_of_revenue))%"
                                    if temp_dict != [:] {
                                        self.user_holdings_data.append(temp_dict)
                                        temp_dict = [:]
                                    }
                                    
                                    
//                                    self.opportunity_data.append(value)
                                }
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
    
}
