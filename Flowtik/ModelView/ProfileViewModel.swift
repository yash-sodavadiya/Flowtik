import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileModel?

    func loadUser() async {
        let userId = UserDefaults.standard.integer(forKey: "authToken")
        print("\(userId)")
        guard userId != 0 else {
            print("Invalid user ID")
            return
        }

        do {
            let user = try await ProfileClient.shared.fetchUser(by: userId)
            self.profile = user
        } catch {
            print("Error fetching user: \(error)")
        }
    }
}
