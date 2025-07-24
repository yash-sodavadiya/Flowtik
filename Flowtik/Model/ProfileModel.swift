//
//  ProfileModel.swift
//  Flowtik
//
//  Created by Admin on 24/07/25.
//


import Foundation

struct ProfileModel: Codable, Identifiable {
    var id: Int { userId }  // For SwiftUI Identifiable
    let userId: Int
    let userName: String
    let email: String
    let role: String?
}
