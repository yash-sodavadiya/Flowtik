//
//  TaskModel.swift
//  Flowtik
//
//  Created by Batch1 on 24/07/25.
//

import Foundation

struct TaskModel: Identifiable {
    let id = UUID()
    let title: String
    let totalMinutes: Int
    var elapsedMinutes: Int = 0
    var isRunning: Bool = false
    
}
