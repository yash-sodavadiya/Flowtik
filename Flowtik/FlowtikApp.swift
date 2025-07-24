//
//  FlowtikApp.swift
//  Flowtik
//
//  Created by Batch1 on 24/07/25.
//

import SwiftUI

@main
struct FlowtikApp: App {
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
           if isLoggedIn
            {
                MainTabbar()
                    
            }
            else{
                LoginView()
            }
        }
    }
}
