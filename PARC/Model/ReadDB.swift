//
//  ReadDB.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import Foundation

class ReadDB: ObservableObject {
    @Published var franchise_data: [DropdownMenuOption] = []
    
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
                    print("error")
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
}
