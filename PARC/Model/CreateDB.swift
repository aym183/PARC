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
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/users")!
        var getRequest = URLRequest(url: apiUrl)
        getRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: getRequest) { data, response, error in
            if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let itemsArray = jsonObject["Items"] as? [[String: Any]] {
                            let userExists = itemsArray.contains { item in
                                if let itemEmail = item["email"] as? String {
                                    return itemEmail == email
                                }
                                return false
                            }
                            if userExists {
                                DispatchQueue.main.async {
                                    completion("User already exists")
                                }
                            } else {
                                let userApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/users?email=\(email)&first_name=\(first_name)&last_name=\(last_name)&full_name=\(full_name)&picture=\(picture)&date_joined=\(Date.now)&balance=0")!

                                var postRequest = URLRequest(url: userApiUrl)
                                postRequest.httpMethod = "POST"

                                URLSession.shared.dataTask(with: postRequest) { postData, postResponse, postError in
                                    if let postData = postData, let postResponseText = String(data: postData, encoding: .utf8) {
                                        DispatchQueue.main.async {
                                            print(postResponseText)
                                            completion("User Created")
                                        }
                                    } else if let postError = postError {
                                        DispatchQueue.main.async {
                                            print("Error creating User: \(postError.localizedDescription)")
                                        }
                                    }
                                }.resume()
                            }
                        }
                    }
                } catch {
                    print("Error parsing JSON")
                }
            } else if let error = error {
                print("Error performing GET request: \(error.localizedDescription)")
            }
        }.resume()
    }
        
//        
//        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/users?email=\(email)&first_name=\(first_name)&last_name=\(last_name)&full_name=\(full_name)&picture=\(picture)&date_joined=\(currentDate)&balance=0")!
//
//        var request = URLRequest(url: apiUrl)
//        request.httpMethod = "POST"
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data, let responseText = String(data: data, encoding: .utf8) {
//                DispatchQueue.main.async {
//                    print(responseText)
//                    completion("User Created")
//                }
//            } else if let error = error {
//                DispatchQueue.main.async {
//                    print("Error creating user: \(error.localizedDescription)")
//                }
//            }
//        }.resume()
//    }
    
    func create_onboarding_email(name: String, email: String) {
        let apiUrl = URL(string: "https://brdh472ip2.execute-api.us-east-1.amazonaws.com/development/emails/send-intro-email?email=\(email)&name=\(name)")!

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
    
    func createInvestmentConfirmation(email: String, amount: String, opportunity_name: String) {
        
        let apiUrl = URL(string: "https://brdh472ip2.execute-api.us-east-1.amazonaws.com/development/emails/investment-confirmed?email=\(email)&amount=\(amount)&opportunity_name=\(opportunity_name)")!

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print("Investment confirmation created \(responseText)")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error creating investment confirmation: \(error.localizedDescription)")
                }
            }
        }.resume()
        
    }
    
    func createFranchise(name: String, logo: String, description: String, no_of_franchises: String, avg_franchise_mom_revenues: String, avg_startup_capital: String, avg_revenue_18_months: String, ebitda_estimate: String, completion: @escaping (String?) -> Void) {
        

        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/franchises?name=\(name)&logo=\(logo)&description=\(description)&no_of_franchises=\(no_of_franchises)&avg_franchise_mom_revenues=\(avg_franchise_mom_revenues)&avg_startup_capital=\(avg_startup_capital)&avg_revenue_18_months=\(avg_revenue_18_months)&ebitda_estimate=\(ebitda_estimate)")!
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
//        request.addValue("VA3fCa55Hp3URYRtyziZu4XzSJZDe7sE39cXxlEc", forHTTPHeaderField: "x-api-key")
        
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
                                let opportunityApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/opportunities?opportunity_id=\(arrayLength)&franchise_name=\(franchise_name)&location=\(location)&asking_price=\(asking_price)&equity_offered=\(equity_offered)&min_invest_amount=\(min_invest_amount)&close_date=\(close_date)&date_created=\(Date.now)&amount_raised=0&status=\("active")&investors=0")!
                                
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
    
    func createPayout(franchise: String, revenue_generated: String, opportunity_id: Int, date_scheduled: String, amount_offered: String, user_holdings: [[String: String]], completion: @escaping (String?) -> Void) {
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
                                let opportunityApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts?status=Completed&revenue_generated=\(revenue_generated)&franchise=\(franchise)&payout_id=\(arrayLength)&opportunity_id=\(opportunity_id)&date_scheduled=\(date_scheduled)&date_created=\(Date.now)&amount_offered=\(amount_offered)")!
                                
                                var request = URLRequest(url: opportunityApiUrl)
                                request.httpMethod = "POST"

                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                                        DispatchQueue.main.async {
                                            print(responseText)
                                            CreateDB().createUserPayout(opportunity_id: opportunity_id, user_holdings: user_holdings, amount_offered: amount_offered, payout_id: arrayLength)
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
    
    // Reference GPT
    
    func createUserPayout(opportunity_id: Int, user_holdings: [[String: String]], amount_offered: String, payout_id: Int) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts/user-payouts")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        var request_data: [[String: String]] = []
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["ScannedCount"] as? Int {
                                var arrayLength = itemsArray+1
                                for holding in user_holdings {
                                    if Int(holding["opportunity_id"]!)! == opportunity_id && (holding["status"] == "Owned"){
                                        var calculated_amount = (Float(amount_offered)!*Float(holding["equity"]!)!)/100
                                        request_data.append(["opportunity_id": String(describing: opportunity_id), "user_email": String(describing: holding["user_email"]!), "equity": String(describing: holding["equity"]!), "amount_received": String(describing: Int(calculated_amount)), "user_payout_id": String(describing: arrayLength), "payout_date": String(describing: self.currentDate)])
                                        arrayLength+=1
                                    }
                                }
                                
                                if request_data.count != 0 {
                                    let jsonData: Data
                                    do {
                                        jsonData = try JSONSerialization.data(withJSONObject: request_data)
                                    } catch {
                                        print("Error encoding data to JSON: \(error)")
                                        return
                                    }
                                    
                                    let userPayoutApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts/user-payouts")!
                                    
                                    var request = URLRequest(url: userPayoutApiUrl)
                                    request.httpMethod = "POST"
                                    request.httpBody = jsonData
                                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                    
                                    URLSession.shared.dataTask(with: request) { data, response, error in
                                        if let error = error {
                                            DispatchQueue.main.async {
                                                print("Error creating user payout: \(error.localizedDescription)")
                                            }
                                        } else if let httpResponse = response as? HTTPURLResponse {
                                            if (200..<300).contains(httpResponse.statusCode), let data = data {
                                                // Success: HTTP status code is in the range [200, 300) and data is present
                                                if let responseText = String(data: data, encoding: .utf8) {
                                                    DispatchQueue.main.async {
                                                        print("Response: \(responseText)")
                                                    }
                                                }
                                            } else {
                                                // Error: HTTP status code is outside the range [200, 300)
                                                DispatchQueue.main.async {
                                                    print("Error creating user payout. Status code: \(httpResponse.statusCode)")
                                                }
                                            }
                                        }
                                    }.resume()

                                }
                            }
                        }
                    }
                } catch {
                    print("Error")
                }
            }
        }.resume()
    }
    
    func createOpportunityTransaction(opportunity_id: String, email: String, amount: String) {
        
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/transactions")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["ScannedCount"] as? Int {
                                let arrayLength = itemsArray+1
                                let opportunityApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/transactions?transaction_id=\(arrayLength)&opportunity_id=\(Int(opportunity_id)!)&status=Confirmed&user_email=\(email)&transaction_date=\(Date.now)&amount_paid=\(amount)")!
                                
                                var request = URLRequest(url: opportunityApiUrl)
                                request.httpMethod = "POST"

                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                                        DispatchQueue.main.async {
                                            print("Opportunity Transaction created: \(responseText)")
                                        }
                                    } else if let error = error {
                                        DispatchQueue.main.async {
                                            print("Error creating opportunity transaction: \(error.localizedDescription)")
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
    
    func createUserInvestmentHolding(opportunity_name: String, opportunity_id: String, email: String, equity: String, amount: String) {

        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/user-holdings")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["ScannedCount"] as? Int {
                                let arrayLength = itemsArray+1
                                let opportunityApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/user-holdings?user_holdings_id=\(arrayLength)&opportunity_name=\(opportunity_name)&opportunity_id=\(Int(opportunity_id)!)&status=Owned&user_email=\(email)&equity=\(equity)&amount=\(amount)&transaction_date=\(Date.now)")!
                                
                                var request = URLRequest(url: opportunityApiUrl)
                                request.httpMethod = "POST"

                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                                        DispatchQueue.main.async {
                                            print("User holding created: \(responseText)")
                                        }
                                    } else if let error = error {
                                        DispatchQueue.main.async {
                                            print("Error creating user holding: \(error.localizedDescription)")
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
    
    func createTradingWindow(start_date: String, duration: String, status: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/trading-windows")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["ScannedCount"] as? Int {
                                let arrayLength = itemsArray+1
                                let opportunityApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/trading-windows?trading_window_id=\(arrayLength)&status=\(status)&start_date=\(start_date)&duration=\(duration)")!
                                
                                var request = URLRequest(url: opportunityApiUrl)
                                request.httpMethod = "POST"

                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                                        DispatchQueue.main.async {
                                            print(responseText)
                                            completion("Trading Window Created")
                                        }
                                    } else if let error = error {
                                        DispatchQueue.main.async {
                                            print("Error creating trading window: \(error.localizedDescription)")
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
