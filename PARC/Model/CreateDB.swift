//
//  CreateDB.swift
//  PARC
//
//  Created by Ayman Ali on 03/11/2023.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseStorage

class CreateDB: ObservableObject {
    let currentDate = Date()
    let apiKey = AppConfig.apiKey
    
    
    /// Adds a record of a newly registered user to the database
    /// - Parameters:
    ///   - email: User email
    ///   - first_name: User first name
    ///   - last_name: User last name
    ///   - full_name: User full name
    ///   - picture: User profile picture
    func createUser(email: String, first_name: String, last_name: String, full_name: String, picture: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/users")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        let keysArray = ["email"]
        var email_found = false
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let itemsArray = jsonObject["Items"] as? [[String: Any]] {
                            for value in itemsArray.reversed() {
                                for data in keysArray.reversed() {
                                    if let nameDictionary = value[data] as? [String: String] {
                                        if let sValue = nameDictionary["S"], sValue == email {
                                            email_found = true
                                            completion("User already exists")
                                        }
                                    }
                                }
                            }
                            if !email_found {
                                let userApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/users?email=\(email)&first_name=\(first_name)&last_name=\(last_name)&full_name=\(full_name)&picture=\(picture)&date_joined=\(Date.now)&balance=0")!
                                
                                var postRequest = URLRequest(url: userApiUrl)
                                postRequest.httpMethod = "POST"
                                postRequest.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
                                
                                URLSession.shared.dataTask(with: postRequest) { postData, postResponse, postError in
                                    if let postData = postData, let postResponseText = String(data: postData, encoding: .utf8) {
                                        DispatchQueue.main.async {
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
    
    
    /// Sends an onboarding email to a newly created user via Resend
    /// - Parameters:
    ///   - name: User name
    ///   - email: User email
    func create_onboarding_email(name: String, email: String) {
        let apiUrl = URL(string: "https://brdh472ip2.execute-api.us-east-1.amazonaws.com/development/emails/send-intro-email?email=\(email)&name=\(name)")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        
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
    
    
    /// Sends user confirmation on investment via Resend
    /// - Parameters:
    ///   - email: User email
    ///   - amount: User amount
    ///   - opportunity_name: User opportunity
    ///   - type: Type of investment (buyer confirmation, seller confirmation)
    func createInvestmentConfirmation(email: String, amount: String, opportunity_name: String, type: String) {
        if type == "buyer" {
            let apiUrl = URL(string: "https://brdh472ip2.execute-api.us-east-1.amazonaws.com/development/emails/investment-confirmed?email=\(email)&amount=\(amount)&opportunity_name=\(opportunity_name)")
            var request = URLRequest(url: apiUrl!)
            request.httpMethod = "POST"
            request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
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
        } else {
            let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/transactions-secondary-market/seller-investment-confirmed?email=\(email)&amount=\(amount)&opportunity_name=\(opportunity_name)")
            var request = URLRequest(url: apiUrl!)
            request.httpMethod = "POST"
            request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
            
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
        
    }
    
    
    /// Adds record of a franchise to the database
    /// - Parameters:
    ///   - name: Franchise name
    ///   - logo: Franchise logo
    ///   - display_image: Display image
    ///   - description: Description
    ///   - no_of_franchises: The number of franchise locaations
    ///   - avg_franchise_mom_revenues: Average month-of-month revenues
    ///   - avg_startup_capital: Average franchise startup capital
    ///   - avg_revenue_18_months: Average revenue after 18 months
    ///   - ebitda_estimate: Franchise EBITDA (Earnings before interest, taxes, depreciation, and ammortisation) estimate
    func createFranchise(name: String, logo: String, description: String, no_of_franchises: String, avg_franchise_mom_revenues: String, avg_startup_capital: String, avg_revenue_18_months: String, ebitda_estimate: String, completion: @escaping (String?) -> Void) {
        
        var bg_images = ["store_live_3", "store_live_4", "store_live_5", "store_live_6", "store_live_7", "store_live_8"]
        let display_image = bg_images.randomElement()
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/franchises?name=\(name)&logo=\(logo)&display_image=\(display_image!)&description=\(description)&no_of_franchises=\(no_of_franchises)&avg_franchise_mom_revenues=\(avg_franchise_mom_revenues)&avg_startup_capital=\(avg_startup_capital)&avg_revenue_18_months=\(avg_revenue_18_months)&ebitda_estimate=\(ebitda_estimate)")!
        print(apiUrl)
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                print(data)
                DispatchQueue.main.async {
                    completion("Franchise Created")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error creating franchise: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Adds new investment opportunity record to the database
    /// - Parameters:
    ///   - franchise_name: Name of the franchise
    ///   - location: Location of the franchise in the UK
    ///   - asking_price: Amount looking to be raised (in £)
    ///   - equity_offered: Equity offered to investors (in %)
    ///   - min_invest_amount: Minimum investment amount per investor
    ///   - close_date: Closing date of the opportunity where users can invest
    func create_opportunity(franchise_name: String, location: String, asking_price: String, equity_offered: String, min_invest_amount: String, close_date: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/opportunities")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["ScannedCount"] as? Int {
                                let arrayLength = itemsArray+1
                                let opportunityApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/opportunities?opportunity_id=\(arrayLength)&franchise_name=\(franchise_name)&location=\(location)&asking_price=\(asking_price)&equity_offered=\(equity_offered)&min_invest_amount=\(min_invest_amount)&close_date=\(convertDate(dateString: close_date))&date_created=\(formattedDate)&amount_raised=0&status=\("Active")&investors=0")!
                                
                                var request = URLRequest(url: opportunityApiUrl)
                                request.httpMethod = "POST"
                                request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
                                
                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                                        DispatchQueue.main.async {
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
    
    
    /// Uploads images to Firebase Storage
    /// - Parameters:
    ///   - image: UIImage record of the image
    ///   - folder: Path of the firebase storage folder
    /// - Returns: Path of the image stored in firebase
    func upload_logo_image(image: UIImage, folder: String) -> String {
        @AppStorage("email") var email: String = ""
        let imageData = image.jpegData(compressionQuality: 0.8)
        guard imageData != nil else { return ""}
        let randomID = UUID().uuidString
        let path = "\(folder)/\(randomID).jpg"
        
        DispatchQueue.global(qos: .background).async {
            let storage = Storage.storage().reference()
            let fileRef = storage.child("\(folder)/\(randomID).jpg")
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading \(folder) \(error.localizedDescription)")
                }
            }
        }
        
        if folder == "profile_images" {
            UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: "profile_image")
        } else {
            UserDefaults.standard.set(image.jpegData(compressionQuality: 0.8), forKey: path)
        }
        return path
    }
    
    
    /// Creats a payout record. This is just to keep track of the overall payout and not the actual sending out of the payouts to investors
    /// - Parameters:
    ///   - franchise: Franchise for which payout is created
    ///   - revenue_generated: Amount of revenue generated
    ///   - opportunity_id: Opportunity for which payout is created
    ///   - date_scheduled: Date of payout
    ///   - amount_offered: Total amount offered to investors
    ///   - user_holdings: All the investors and the equity they own
    func createPayout(franchise: String, revenue_generated: String, opportunity_id: Int, date_scheduled: String, amount_offered: String, user_holdings: [[String: String]], completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        
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
                                request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
                                
                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                                        DispatchQueue.main.async {
                                            CreateDB().createUserPayout(opportunity_id: opportunity_id, user_holdings: user_holdings, amount_offered: amount_offered)
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
    
    
    /// Calculates how much each investor is owed in payouts and sends it to them
    /// - Parameters:
    ///   - opportunity_id: Opportunity for which payout is created
    ///   - user_holdings:  All the investors and the equity they own
    ///   - amount_offered:  Total amount offered to investors
    func createUserPayout(opportunity_id: Int, user_holdings: [[String: String]], amount_offered: String) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/payouts/user-payouts")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
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
                                    request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
                                    
                                    URLSession.shared.dataTask(with: request) { data, response, error in
                                        if let error = error {
                                            DispatchQueue.main.async {
                                                print("Error creating user payout: \(error.localizedDescription)")
                                            }
                                        } else if let httpResponse = response as? HTTPURLResponse {
                                            if (200..<300).contains(httpResponse.statusCode), let data = data {
                                                if let responseText = String(data: data, encoding: .utf8) {
                                                    DispatchQueue.main.async {
                                                        print("Response: \(responseText)")
                                                    }
                                                }
                                            } else {
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
    
    /// Creates a record of investments in opportunities in the database
    /// - Parameters:
    ///   - opportunity_id: The opportunity for which a transaction was made
    ///   - email: Email of the investor
    ///   - amount: Amount invested (in £)
    func createOpportunityTransaction(opportunity_id: String, email: String, amount: String) {
        
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/transactions")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        
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
                                request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
                                
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
    
    
    /// Creates a record of the user's holding in the database after investing in an opportunity
    /// - Parameters:
    ///   - opportunity_name: The opportunity invested in
    ///   - opportunity_id: The opportunity for which an investment was made
    ///   - email: Email of the investor
    ///   - equity: Equity owned by the user after successful investment
    ///   - amount: Amount invested in the opportunity
    func createUserInvestmentHolding(opportunity_name: String, opportunity_id: String, email: String, equity: String, amount: String) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/user-holdings")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        
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
                                request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
                                
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
    
    
    /// Creates a record for a secondary market trading window in the database
    /// - Parameters:
    ///   - start_date: Start date of the trading window
    ///   - duration: Duration of the secondary market trading window (in days)
    ///   - status: Status of the trading window (initially "Active")
    func createTradingWindow(start_date: String, duration: String, status: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/trading-windows")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        
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
                                request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
                                
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
    
    
    /// Creates a record for a secondary market transaction in the database
    /// - Parameters:
    ///   - opportunity_id: The opportunity for which an investment was made
    ///   - trading_window_id: The trading_window_id during which the investment was made
    ///   - price: Price of the transaction
    ///   - equity: Equity in the opportunity now owned by the buyer
    ///   - user_buying: Email of buyer
    ///   - user_selling: Email of seller
    func createSecondaryMarketTransaction(opportunity_id: String, trading_window_id: String, price: String, equity: String, user_buying: String, user_selling: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/transactions-secondary-market")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            if let itemsArray = jsonObject["ScannedCount"] as? Int {
                                let arrayLength = itemsArray+1
                                let opportunityApiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/transactions-secondary-market?transaction_id=\(arrayLength)&opportunity_id=\(Int(opportunity_id)!)&trading_window_id=\(Int(trading_window_id)!)&price=\(price)&equity=\(equity)&user_buying=\(user_buying)&user_selling=\(user_selling)&transaction_date=\(Date.now)")!
                                
                                var request = URLRequest(url: opportunityApiUrl)
                                request.httpMethod = "POST"
                                request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
                                
                                URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                                        DispatchQueue.main.async {
                                            print(responseText)
                                            completion("Transactions Secondary Market Created")
                                        }
                                    } else if let error = error {
                                        DispatchQueue.main.async {
                                            print("Error creating transaction: \(error.localizedDescription)")
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
    
    
    /// Creates a withdrawal confirmation email for investors
    /// - Parameters:
    ///   - email: Email of the investor
    ///   - amount: Amount withdrawn
    func createWithdrawalConfirmation(email: String, amount: String) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/users/withdrawals?email=\(email)&amount=\(amount)")
        var request = URLRequest(url: apiUrl!)
        request.httpMethod = "POST"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print("Withdrawal confirmation created \(responseText)")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error creating withdrawal confirmation: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    /// Creates a request that gets sent to Amazon Bedrock to fetch the chatbot's response
    /// - Parameters:
    ///   - message: Message created by the user
    func createChatbotRequest(message: String, completion: @escaping (String?) -> Void) {
        let apiUrl = URL(string: "https://q3dck5qp1e.execute-api.us-east-1.amazonaws.com/development/chatbot?user_input=\(message)")
        var request = URLRequest(url: apiUrl!)
        request.httpMethod = "POST"
        request.addValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseText = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    completion(responseText.replacingOccurrences(of: "\n\n", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: ""))
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    print("Error creating message response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
