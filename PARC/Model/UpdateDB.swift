//
//  UpdateDB.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import Foundation

class UpdateDB: ObservableObject {
    let api_key = AppConfig.apiKey
    
    
    /// Updates a table's records in the database
    /// - Parameters:
    ///   - primary_key: Primary key of table to be updated
    ///   - primary_key_value: Primary key value
    ///   - table: Name of DB table
    ///   - updated_key: Updated column name
    ///   - updated_value: Updated value at column of given row
    func update_table(primary_key: String, primary_key_value: String, table: String, updated_key: String, updated_value: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts?primary_key=\(primary_key)&primary_key_value=\(Int(primary_key_value)!)&table=\(table)&updated_key=\(updated_key)&updated_value=\(updated_value)")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "PUT"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
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
    
    
    /// Updates a table's records with an integer value in the database
    /// - Parameters:
    ///   - primary_key: Primary key of table to be updated
    ///   - primary_key_value: Primary key value
    ///   - table: Name of DB table
    ///   - updated_key: Updated column name
    ///   - updated_value: Updated value at column of given row
    func update_user_table(primary_key: String, primary_key_value: String, table: String, updated_key: String, updated_value: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts?primary_key=\(primary_key)&primary_key_value=\(primary_key_value)&table=\(table)&updated_key=\(updated_key)&updated_value=\(updated_value)")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "PUT"
        request.addValue(self.api_key, forHTTPHeaderField: "x-api-key")
        
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
