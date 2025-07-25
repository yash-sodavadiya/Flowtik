//
//  CreateTaskModel.swift
//  Flowtik
//
//  Created by Admin on 25/07/25.
//

import Foundation

struct CreateTaskModel: Codable {
    let title: String
    let description: String
    let estimatedHours: Double
    let assignedToId: Int
    let createdById: Int
}

