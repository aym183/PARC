//
//  CreateDB.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import Foundation
import SwiftUI

class CreateDB: ObservableObject {
    let currentDate = Date()
    
    func createUser(email: String, first_name: String, last_name: String, full_name: String, picture: String, completion: @escaping (String?) -> Void) {
        
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
    
    func createFranchise(name: String, logo: String, description: String, no_of_franchises: String, avg_franchise_mom_revenues: String, avg_startup_capital: String, avg_revenue_18_months: String, ebitda_estimate: String, completion: @escaping (String?) -> Void) {
        
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/franchises?name=\(name)&logo=\(logo)&description=\(description)&no_of_franchises=\(no_of_franchises)&avg_franchise_mom_revenues=\(avg_franchise_mom_revenues)&avg_startup_capital=\(avg_startup_capital)&avg_revenue_18_months=\(avg_revenue_18_months)&ebitda_estimate=\(ebitda_estimate)")!
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(responseText)
                    completion("Franchise Created")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error creating franchise: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func create_opportunity(franchise_name: String, location: String, asking_price: String, equity_offered: String, min_invest_amount: String, close_date: String, completion: @escaping (String?) -> Void) {

        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/opportunities")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["ScannedCount"] as? Int {
                                let arrayLength = itemsArray+1
                                let opportunityApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/opportunities?opportunity_id=\(arrayLength)&franchise_name=\(franchise_name)&location=\(location)&asking_price=\(asking_price)&equity_offered=\(equity_offered)&min_invest_amount=\(min_invest_amount)&close_date=\(close_date)&date_created=\(self.currentDate)&amount_raised=0&status=\("active")&investors=0")!
                                
                                var request = URLRequest(url: opportunityApiUrl)
                                request.httpMethod = "POST"

                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                                        DispatchQueue.main.async {
                                            print(responseText)
                                            completion("Opportunity Created")
                                        }
                                    } else if let error = error {
                                        DispatchQueue.main.async {
                                            print("Error creating opportunity: \(error.localizedDescription)")
                                        }
                                    }
                                }.resume()
                            }
                        }
                    }
                } catch {
                    print("Error")
                }
            }
        }.resume()
    }
    
    func uploadFranchiseLogoImage(image: UIImage) {
        
        let imageData = image.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        let randomID = UUID().uuidString
        let path = "\(randomID).jpg"
        
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/images?image=\(imageData!)&image_title=\(path)")!
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(responseText)
//                    completion("Franchise Logo Image Created")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error uploading franchise logo: \(error.localizedDescription)")
                }
            }
        }.resume()
        
    }
    
    func createPayout(revenue_generated: String, opportunity_id: Int, date_scheduled: String, amount_offered: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["ScannedCount"] as? Int {
                                let arrayLength = itemsArray+1
                                let opportunityApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts?status=Scheduled&revenue_generated=\(revenue_generated)&payout_id=\(arrayLength)&opportunity_id=\(opportunity_id)&date_scheduled=\(date_scheduled)&date_created=\(self.currentDate)&amount_offered=\(amount_offered)")!
                                
                                var request = URLRequest(url: opportunityApiUrl)
                                request.httpMethod = "POST"

                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                                        DispatchQueue.main.async {
                                            print(responseText)
                                            completion("Payout Created")
                                        }
                                    } else if let error = error {
                                        DispatchQueue.main.async {
                                            print("Error creating opportunity: \(error.localizedDescription)")
                                        }
                                    }
                                }.resume()
                            }
                        }
                    }
                } catch {
                    print("Error")
                }
            }
        }.resume()
    }
}
