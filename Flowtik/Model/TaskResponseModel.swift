//
//  TaskResponseModel.swift
//  Flowtik
//
//  Created by Admin on 25/07/25.
//

import Foundation

class TaskResponseModel: Codable,Identifiable {
    let taskId: Int
       let title: String
       let description: String
       let estimatedHours: Int
       let assignedToId: Int
       let assignedToUserName: String?
       let assignedToEmail: String?
       let createdById: Int
       let createdByUserName: String?
       let createdByEmail: String?
       let isCompleted: Bool
       let createdAt: Date?
       var totalHoursWorked: Double
       var isCurrentlyActive: Bool
       let lastStartTime: Date?
       let queriesCount: Int
    
    init(taskId: Int, title: String, description: String, estimatedHours: Int, assignedToId: Int, assignedToUserName: String?, assignedToEmail: String?, createdById: Int, createdByUserName: String?, createdByEmail: String?, isCompleted: Bool, createdAt: Date, totalHoursWorked: Double, isCurrentlyActive: Bool, lastStartTime: Date?, queriesCount: Int) {
        self.taskId = taskId
        self.title = title
        self.description = description
        self.estimatedHours = estimatedHours
        self.assignedToId = assignedToId
        self.assignedToUserName = assignedToUserName
        self.assignedToEmail = assignedToEmail
        self.createdById = createdById
        self.createdByUserName = createdByUserName
        self.createdByEmail = createdByEmail
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.totalHoursWorked = totalHoursWorked
        self.isCurrentlyActive = isCurrentlyActive
        self.lastStartTime = lastStartTime
        self.queriesCount = queriesCount
    }
}
