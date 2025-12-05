//
//  User.swift
//  meow
//
//  Created by Warintira Pureprasert on 2/12/2568 BE.
//

import Foundation

struct User: Identifiable, Codable {
    let id:String
    let fullname:String
    let email:String
    
    var initials:String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
    
    var isAdmin: Bool {
        return email == "adminCat@gmail.com"
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Paponsak", email: "test@meow.com")
}

