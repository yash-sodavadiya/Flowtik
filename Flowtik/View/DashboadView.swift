import SwiftUI

// Task Model
//struct TaskModel: Identifiable {
//    let id = UUID()
//    let title: String
//    let totalMinutes: Int
//    var elapsedMinutes: Int = 0
//    var isRunning: Bool = false
//}

struct DashboardView: View {
    @State private var tasks: [TaskModel] = [
        TaskModel(title: "Update Project Report", totalMinutes: 60),
//        TaskModel(title: "Client Follow-Up", totalMinutes: 45),
//        TaskModel(title: "UI Design Revision", totalMinutes: 90),
//        TaskModel(title: "Team Meeting Preparation", totalMinutes: 30),
//        TaskModel(title: "Code Review", totalMinutes: 50)
    ]
    @StateObject private var taskView = TaskViewModel()
    @State private var totalWorkedMinutes = 0
    @State private var timer: Timer?
    @State private var selectedTaskIndex: Int? = nil
    @State private var isDetailViewActive = false
    @StateObject private var profileView = ProfileViewModel()
    @State private var isAddTask: Bool = false
    @State private var isRunningDict: [Int: Bool] = [:]
    @State private var elapsedMinutesDict: [Int: Int] = [:]


    private let cardGradients: [[Color]] = [
        [Color.purple, Color.blue],
        [Color.orange, Color.red],
        [Color.green, Color.teal],
        [Color.pink, Color.purple],
        [Color.indigo, Color.cyan]
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome back, \(profileView.profile?.userName ?? "demo") 👋")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Today • \(formattedDate())")
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Summary
                    HStack(spacing: 20) {
                        SummaryCard(title: "Worked Today", value: minutesToHours(totalWorkedMinutes), systemImage: "clock.fill", color: Color.blue)
                        SummaryCard(title: "Daily Goal", value: "8h 0m", systemImage: "flag.fill", color: Color.green)
                    }
                    .padding(.horizontal)
                    
                    // Title
                    Text("Your Tasks")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    // Task Cards
                    VStack(spacing: 16) {
                        ForEach(taskView.tasks.indices, id: \.self) { index in
                            Button(action:{
                                selectedTaskIndex = index
                                isDetailViewActive = true
                            }) {
                                ColorfulTaskCard(
                                    taskTitle: taskView.tasks[index].title,
                                    elapsedMinutes: Int(taskView.tasks[index].totalHoursWorked * 60),
                                    totalMinutes: Int(taskView.tasks[index].estimatedHours * 60),
                                    isCompleted: taskView.tasks[index].totalHoursWorked >= Double(taskView.tasks[index].estimatedHours),
                                    gradientColors: cardGradients[index % cardGradients.count],
                                    onToggle: {
//                                        Task {
//                                                if let id = taskView.tasks[index].taskId {
//                                                    await taskView.start(taskId: id)
//                                                }
                                                toggleTimer(for: index)
//                                            }
                                    },
                                    onComplete: {
                                        completeTask(at: index)
                                    },
                                    
                                    isRunning: taskView.tasks[index].isCurrentlyActive
                                )

                            }
                        }
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $isAddTask) {
                        AddTaskView(viewModel: taskView)
                    }
                    // Add Task Button
                    if taskView.tasks.isEmpty {
                        Button(action: {
                            isAddTask = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.title2)
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
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 5)
                            .padding(.horizontal)
                        }
                    } else {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.title2)
                                Text("Add Task")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5))
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .opacity(0.6)
                        }
                        .disabled(true)
                    }
                    
                    Spacer(minLength: 30)
                    
                    
                    NavigationLink(
                        destination: selectedTaskIndex.map { index in
                            TaskDetailView(task: $taskView.tasks[index])
                        },
                        isActive: $isDetailViewActive,
                        label: { EmptyView() }
                    )
                }
            }
            .task {
                await taskView.loadTasks()
                await profileView.loadUser()
            }
            .navigationTitle("Tasks")
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    private func completeTask(at index: Int) {
        timer?.invalidate()
        tasks[index].elapsedMinutes = tasks[index].totalMinutes
        tasks[index].isRunning = false
    }

    private func toggleTimer(for index: Int) {
        // Stop all other tasks
        for i in taskView.tasks.indices {
            taskView.tasks[i].isCurrentlyActive = false
        }

        // If already active, stop timer
        if taskView.tasks[index].isCurrentlyActive {
            taskView.tasks[index].isCurrentlyActive = false
            timer?.invalidate()
            timer = nil
        } else {
            // Start timer for selected task
            taskView.tasks[index].isCurrentlyActive = true
            timer?.invalidate()

            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                guard index < taskView.tasks.count else {
                    timer?.invalidate()
                    timer = nil
                    return
                }

                var task = taskView.tasks[index]

                let elapsedMinutes = task.totalHoursWorked * 60.0
                let estimatedMinutes = Double(task.estimatedHours) * 60.0


                if elapsedMinutes < estimatedMinutes {
                    task.totalHoursWorked += 1.0 / 60.0 // 1 minute
                    totalWorkedMinutes += 1
                    taskView.tasks[index] = task
                } else {
                    taskView.tasks[index].isCurrentlyActive = false
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
    }




    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
    
    private func minutesToHours(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)h \(mins)m"
    }
}

// Summary Card
struct SummaryCard: View {
    var title: String
    var value: String
    var systemImage: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 28))
                .foregroundColor(.white)
                .padding(12)
                .background(color)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 5)
        .frame(maxWidth: .infinity)
    }
}

// Task Card
struct ColorfulTaskCard: View {
    var taskTitle: String
    var elapsedMinutes: Int
    var totalMinutes: Int
    var isCompleted: Bool
    var gradientColors: [Color]
    var onToggle: () -> Void
    var onComplete: () -> Void
    var isRunning: Bool

    var progress: Double {
        guard totalMinutes > 0 else { return 0 }
        return Double(elapsedMinutes) / Double(totalMinutes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(taskTitle)
                .font(.title3)
                .bold()
                .foregroundColor(.white)

            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                .scaleEffect(x: 1, y: 5, anchor: .center)
                .cornerRadius(10)

            HStack {
                Text("\(elapsedMinutes) / \(totalMinutes) min")
                    .foregroundColor(.white.opacity(0.85))
                    .font(.subheadline)

                Spacer()

                if isCompleted {
                    Label("Completed", systemImage: "checkmark.seal.fill")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .padding(6)
                        .background(Color.white.opacity(0.25))
                        .clipShape(Capsule())
                } else {
                    Label(isRunning ? "In Progress" : "Paused", systemImage: isRunning ? "clock.fill" : "pause.fill")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .padding(6)
                        .background(Color.white.opacity(0.25))
                        .clipShape(Capsule())
                }
            }

            if isRunning {
                HStack(spacing: 12) {
                    Button(action: onToggle ) {
                        HStack {
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .font(.headline)
                        .foregroundColor(gradientColors.first ?? .white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }

                    Button(action: onComplete) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Complete")
                        }
                        .font(.headline)
                        .foregroundColor(gradientColors.first ?? .white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                }
            } else {
                Button(action: onToggle) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start")
                    }
                    .font(.headline)
                    .foregroundColor(gradientColors.first ?? .white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(25)
        .shadow(color: gradientColors.last?.opacity(0.5) ?? .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// Dummy Task Detail View (you can customize it)
//struct TaskDetailView: View {
//    @Binding var task: TaskModel
//    
//    var body: some View {
//        Text("Task Detail for \(task.title)")
//            .font(.title)
//    }
//}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
