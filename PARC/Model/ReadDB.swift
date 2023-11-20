//
//  ReadDB.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import Foundation
import SwiftUI

class ReadDB: ObservableObject {
    @Published var franchise_data: [DropdownMenuOption] = []
    @Published var opportunity_data: [[String: String]] = []
    @Published var payout_data: [[String: String]] = []
    @Published var opportunity_data_dropdown: [DropdownMenuOption] = []
    
    func getFranchises() {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/franchises")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["Items"] as? [[String: Any]] {
                                for value in itemsArray {
                                    if let nameDictionary = value["name"] as? [String: String], let sValue = nameDictionary["S"] {
                                        self.franchise_data.append(DropdownMenuOption(option: sValue))
                                    }
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
    
}
