//
//  LoginViewModel.swift
//  Flowtik
//
//  Created by Batch1 on 24/07/25.
//

import Foundation
import SwiftUI

class LoginViewModel:ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isSecure: Bool = true
    
    func login() -> Bool {
        if(username == "employee" && password == "password")
        {
            return true
        }
        return false
    }
    
}
