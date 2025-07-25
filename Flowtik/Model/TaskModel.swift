//
//  TaskModel.swift
//  Flowtik
//
//  Created by Batch1 on 24/07/25.
//


import Foundation

struct TaskModel: Codable, Identifiable {
//    var id: Int { taskId }
//
//    let taskId: Int
//    let title: String
//    let description: String
//    let estimatedHours: Int
//    let assignedToId: Int
//    let assignedToUserName: String?
//    let assignedToEmail: String?
//    let createdById: Int
//    let createdByUserName: String?
//    let createdByEmail: String?
//    let isCompleted: Bool
//    let createdAt: Date
//    let totalHoursWorked: Int
//    let isCurrentlyActive: Bool
//    let lastStartTime: Date?
//    let queriesCount: Int
    
    let id = UUID()
       let title: String
       let totalMinutes: Int
       var elapsedMinutes: Int = 0
       var isRunning: Bool = false
}

