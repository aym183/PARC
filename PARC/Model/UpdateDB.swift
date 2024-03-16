//
//  UpdateDB.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import Foundation

class UpdateDB: ObservableObject {
    let apiKey = AppConfig.apiKey
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - primary_key: <#primary_key description#>
    ///   - primary_key_value: <#primary_key_value description#>
    ///   - table: <#table description#>
    ///   - updated_key: <#updated_key description#>
    ///   - updated_value: <#updated_value description#>
    ///   - completion: <#completion description#>
    func updateTable(primary_key: String, primary_key_value: String, table: String, updated_key: String, updated_value: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts?primary_key=\(primary_key)&primary_key_value=\(Int(primary_key_value)!)&table=\(table)&updated_key=\(updated_key)&updated_value=\(updated_value)")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "PUT"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    completion("\(table) \(updated_key) updated")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error updating \(table): \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - primary_key: <#primary_key description#>
    ///   - primary_key_value: <#primary_key_value description#>
    ///   - table: <#table description#>
    ///   - updated_key: <#updated_key description#>
    ///   - updated_value: <#updated_value description#>
    ///   - completion: <#completion description#>
    func updateUserTable(primary_key: String, primary_key_value: String, table: String, updated_key: String, updated_value: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts?primary_key=\(primary_key)&primary_key_value=\(primary_key_value)&table=\(table)&updated_key=\(updated_key)&updated_value=\(updated_value)")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "PUT"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    completion("\(table) \(updated_key) updated")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error updating \(table): \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
}
