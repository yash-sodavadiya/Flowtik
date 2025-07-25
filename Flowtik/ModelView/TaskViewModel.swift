//
//  TaskViewModel.swift
//  Flowtik
//
//  Created by Admin on 24/07/25.
//

import Foundation

@MainActor
class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskResponseModel] = []
    @Published var selectedTask: TaskResponseModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadTasks() async {
        isLoading = true
        errorMessage = nil

        // Assuming "authToken" is storing the user ID as Int
        let userId = UserDefaults.standard.integer(forKey: "authToken")

        do {
            let fetchedTasks = try await TaskClient.shared.fetchTasks(forUserID: userId)
            self.tasks = fetchedTasks
            print("✅ Loaded tasks: \(fetchedTasks.count)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Error loading tasks: \(error.localizedDescription)")
        }

        isLoading = false
    }
    
    func startTask(id: Int) async {
            do {
                let response = try await TaskClient.shared.startTask(with: id)
                print("✅ Start API Response:", response)
            } catch {
                print("❌ Failed to start task:", error.localizedDescription)
            }
        }
    
    func addManualTask(
            title: String,
            description: String,
            estimatedHours: Double,
            assignedToId: Int
        ) async {
            isLoading = true
            errorMessage = nil

            // Assuming user ID is saved as authToken
            let createdById = UserDefaults.standard.integer(forKey: "authToken")

            let request = CreateTaskModel(
                title: title,
                description: description,
                estimatedHours: estimatedHours,
                assignedToId: createdById,
                createdById: createdById
            )

            do {
                let taskId = try await TaskClient.shared.addManualTask(request)
                print("✅ Task created with ID: \(taskId)")
                await loadTasks() // Refresh tasks after adding
            } catch {
                errorMessage = error.localizedDescription
                print("❌ Failed to create task:", error.localizedDescription)
            }

            isLoading = false
        }
}
