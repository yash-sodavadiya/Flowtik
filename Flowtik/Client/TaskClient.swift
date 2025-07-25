//
//  TaskClient.swift
//  Flowtik
//
//  Created by Admin on 24/07/25.
//

import Foundation

class TaskClient {
    static let shared = TaskClient()

       private let baseURL = "http://10.25.5.55:5112/api/Tasks/assigned"

       private let decoder: JSONDecoder = {
           let decoder = JSONDecoder()

           // Fix: Custom date formatter
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
           formatter.locale = Locale(identifier: "en_US_POSIX")
           formatter.timeZone = TimeZone(secondsFromGMT: 0)

           decoder.dateDecodingStrategy = .formatted(formatter)
           return decoder
       }()

       func fetchTasks(forUserID id: Int) async throws -> [TaskResponseModel] {
           guard let url = URL(string: "\(baseURL)/\(id)") else {
               throw URLError(.badURL)
           }

           let (data, response) = try await URLSession.shared.data(from: url)

           guard let httpResponse = response as? HTTPURLResponse,
                 (200...299).contains(httpResponse.statusCode) else {
               throw URLError(.badServerResponse)
           }

           do {
               let tasks = try decoder.decode([TaskResponseModel].self, from: data)
               return tasks
           } catch {
               let raw = String(data: data, encoding: .utf8) ?? "Invalid JSON"
               print("❌ Decoding failed with error: \(error)")
               print("🔍 Raw JSON:\n\(raw)")
               throw error
           }
       }
    
    func startTask(with id: Int) async throws -> String {
           guard let url = URL(string: "\(baseURL)/start/\(id)") else {
               throw URLError(.badURL)
           }

           let (data, response) = try await URLSession.shared.data(from: url)

           guard let httpResponse = response as? HTTPURLResponse,
                 (200...299).contains(httpResponse.statusCode) else {
               throw URLError(.badServerResponse)
           }

           return String(data: data, encoding: .utf8) ?? "Success"
       }
    
    private let baseURLmanual = "http://10.25.5.55:5112/api/Tasks"
    func addManualTask(_ task: CreateTaskModel) async throws -> Int {
            guard let url = URL(string: "\(baseURLmanual)/manual") else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let jsonData = try JSONEncoder().encode(task)
            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                let errorMsg = try? JSONDecoder().decode([String: String].self, from: data)
                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMsg?["message"] ?? "Unknown error"])
            }

            let responseData = try JSONDecoder().decode([String: Int].self, from: data)
            return responseData["taskId"] ?? -1
        }

    // You can also add POST, PUT, DELETE methods here as needed
}
