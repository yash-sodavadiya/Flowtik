//
//  LoginResponse.swift
//  Flowtik
//
//  Created by Admin on 24/07/25.
//

import Foundation

struct LoginResponse: Codable {
    let message: String
    let userId: Int
    let role: String
}
