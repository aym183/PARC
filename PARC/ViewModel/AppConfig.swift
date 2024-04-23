//
//  appConfig.swift
//  PARC
//
//  Created by Ayman Ali on 31/01/2024.
//

import Foundation

struct AppConfig {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let api_key = config["API_KEY"] as? String else {
            fatalError("Info.plist or API_KEY not found")
        }
        return api_key
    }
}
