//
//  LoginClient.swift
//  Flowtik
//
//  Created by Admin on 24/07/25.
//

import Foundation

class LoginClient{
    static let shared = LoginClient()
    
    let baseURL = "http://10.25.5.55:5112/api/Users/login"
    
    func login(email: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginBody = UserModel(email: email, password: password)
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(loginBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print(String(data: data, encoding: .utf8) ?? "No response body")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(LoginResponse.self, from: data)
        } catch {
            print("Decoding failed: \(error.localizedDescription)")
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "No readable data")")
            throw error
        }
    }
}
