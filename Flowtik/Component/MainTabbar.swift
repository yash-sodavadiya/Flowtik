//
//  MainTabbar.swift
//  Flowtik
//
//  Created by Admin on 24/07/25.
//

import SwiftUI

struct MainTabbar: View {
    
    //    init() {
    //            let appearance = UITabBarAppearance()
    //            appearance.configureWithOpaqueBackground()
    //            appearance.backgroundColor = UIColor.white
    //
    //            UITabBar.appearance().standardAppearance = appearance
    //            UITabBar.appearance().scrollEdgeAppearance = appearance
    //            UITabBar.appearance().tintColor = UIColor.systemGreen
    //            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    //        }
    
    @State private var selectedTab: Tab = .tasks
    
    var body: some View {
        //TabView {
        //                   DashboardView()
        //                       .tabItem {
        //                           Label("Tasks", systemImage: "list.bullet.rectangle")
        //                       }
        //
        ////                   AttendanceView()
        ////                       .tabItem {
        ////                           Label("Attendance", systemImage: "calendar.badge.clock")
        ////                       }
        ////
        ////                   ProfileView()
        ////                       .tabItem {
        ////                           Label("Profile", systemImage: "person.crop.circle")
        ////                       }
        //               }
        //}
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .tasks:
                    DashboardView()
//                case .attendance:
                     //AttendanceView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
    
    
    enum Tab: String, CaseIterable {
        case tasks = "Tasks"
//        case attendance = "Attendance"
        case profile = "Profile"
    }
}
