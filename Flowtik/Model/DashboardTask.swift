//
//  DashboardTask.swift
//  Flowtik
//
//  Created by Admin on 24/07/25.
//


import Foundation

struct DashboardTask: Identifiable {
    let id: Int
    let title: String
    let totalMinutes: Int

    var elapsedMinutes: Int = 0
    var isRunning: Bool = false
}

