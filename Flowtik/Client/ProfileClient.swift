import Foundation

class ProfileClient {
    static let shared = ProfileClient()
    
    let baseURL = "http://192.168.29.112:5112/api/Users"

    func fetchUser(by id: Int) async throws -> ProfileModel {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // Optional: Check response status
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }

        let user = try JSONDecoder().decode(ProfileModel.self, from: data)
        return user
    }
}
