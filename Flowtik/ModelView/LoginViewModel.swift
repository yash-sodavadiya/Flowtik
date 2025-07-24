//
//  LoginViewModel.swift
//  Flowtik
//
//  Created by Batch1 on 24/07/25.
//

import Foundation
import SwiftUI

class LoginViewModel:ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMassege: String = ""
    @Published var isSecure: Bool = true
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    

    
    func login() async {
        do {
            let response = try await LoginClient.shared.login(email: email, password: password)
            
            // Update UI state on main thread
            await MainActor.run {
                if(response.role == "Employee")
                {
                    print("Login successful. Token: \(response.userId)")
                    
                    UserDefaults.standard.set(response.userId, forKey: "authToken")
                    isLoggedIn = true // @AppStorage update MUST be on main thread
                }
                else{
                    errorMassege = "Unauthorize Role"
                    isLoggedIn = false
                }
            }
            
        } catch {
            await MainActor.run {
                errorMassege = "Login failed: \(error.localizedDescription)"
                isLoggedIn = false
            }
        }
    }
    
}
