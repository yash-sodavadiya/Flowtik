import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var estimatedMinutes: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Add New Task")
                            .font(.system(size: 28, weight: .bold))
                        Text("Create a new task for yourself or your team.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // MARK: - Task Name
                    CustomInputCard(title: "Task Name") {
                        TextField("Enter task name", text: $taskName)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    // MARK: - Description
                    CustomInputCard(title: "Description") {
                        TextEditor(text: $taskDescription)
                            .frame(height: 120)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    // MARK: - Estimated Time
                    CustomInputCard(title: "Estimated Time (in minutes)") {
                        TextField("e.g. 90", text: $estimatedMinutes)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    // MARK: - Submit Button
                    Button(action: submitTask) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.headline)
                            Text("Add Task")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: Color.purple.opacity(0.25), radius: 10, x: 0, y: 6)
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // MARK: - Error Message
                    if let error = viewModel.errorMessage {
                        Text("❌ \(error)")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func submitTask() {
        guard !taskName.isEmpty,
              let minutes = Double(estimatedMinutes),
              minutes > 0 else {
            print("❌ Validation failed")
            return
        }
        
        let estimatedHours = minutes / 60.0
        let assignedToId = UserDefaults.standard.integer(forKey: "authToken") // or any assigned user
        
        Task {
            await viewModel.addManualTask(
                title: taskName,
                description: taskDescription,
                estimatedHours: estimatedHours,
                assignedToId: assignedToId
            )
            
            if viewModel.errorMessage == nil {
                dismiss()
            }
        }
    }
}

// MARK: - Custom Input Card
struct CustomInputCard<Content: View>: View {
    var title: String
    var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
    }
}
