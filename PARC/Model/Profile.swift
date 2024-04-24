//
//  Profile.swift
//  PARC
//
//  Created by Ayman Ali on 31/10/2023.
//
//  Adopted from: https://github.com/auth0-blog/auth0-swiftui-login-video/blob/main/iOS%20SwiftUI%20Login%20(complete)/iOS%20SwiftUI%20Login/Profile.swift

import Foundation
import JWTDecode

struct Profile {
    let id: String
    let given_name: String
    let family_name: String
    let name: String
    let email: String
    let picture: String
    let updated_at: String
}


extension Profile {
    static var empty: Self {
        return Profile(
            id: "",
            given_name: "",
            family_name: "",
            name: "",
            email: "",
            picture: "",
            updated_at: ""
        )
    }
    
    static func from(_ idToken: String) -> Self {
        guard
            let jwt = try? decode(jwt: idToken),
            let id = jwt.subject,
            let given_name = jwt.claim(name: "given_name").string,
            let family_name = jwt.claim(name: "family_name").string,
            let name = jwt.claim(name: "name").string,
            let email = jwt.claim(name: "email").string,
            let picture = jwt.claim(name: "picture").string,
            let updated_at = jwt.claim(name: "updated_at").string
        else { return .empty }
        
        return Profile(
            id: id,
            given_name: given_name,
            family_name: family_name,
            name: name,
            email: email,
            picture: picture,
            updated_at: updated_at
        )
    }
}
