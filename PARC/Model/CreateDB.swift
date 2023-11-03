//
//  CreateDB.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import Foundation

class CreateDB: ObservableObject {
    
    func createUser(email: String, first_name: String, last_name: String, full_name: String, picture: String, completion: @escaping (String?) -> Void) {
        let currentDate = Date()
        
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/users?email=\(email)&first_name=\(first_name)&last_name=\(last_name)&full_name=\(full_name)&picture=\(picture)&date_joined=\(currentDate)")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(responseText)
                    completion("User Created")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error creating user: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func create_onboarding_email(name: String, email: String) {
        let apiUrl = URL(string: "https://brdh472ip2.execute-api.us-east-1.amazonaws.com/beta/emails/send-intro-email?email=\(email)&name=\(name)")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(responseText)
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error creating onboarding email: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
