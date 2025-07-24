//
//  UserModel.swift
//  Flowtik
//
//  Created by Batch1 on 24/07/25.
//

import Foundation

class UserModel: Identifiable,Codable {
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
