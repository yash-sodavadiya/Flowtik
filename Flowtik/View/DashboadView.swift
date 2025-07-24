import SwiftUI

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
        TaskModel(title: "Client Follow-Up", totalMinutes: 45),
        TaskModel(title: "UI Design Revision", totalMinutes: 90),
        TaskModel(title: "Team Meeting Preparation", totalMinutes: 30),
        TaskModel(title: "Code Review", totalMinutes: 50)
    ]
//    @StateObject var 
    @State private var totalWorkedMinutes = 0
    @State private var timer: Timer?
    @State private var selectedTaskIndex: Int? = nil   // <- track selected index
     @State private var isDetailViewActive = false      // <- for NavigationLink program
    
    // Some beautiful gradients for task cards
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
                    // Header Section
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome back, John Doe 👋")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Today • \(formattedDate())")
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Work Summary
                    HStack(spacing: 20) {
                        SummaryCard(title: "Worked Today", value: minutesToHours(totalWorkedMinutes), systemImage: "clock.fill", color: Color.blue)
                        
                        SummaryCard(title: "Daily Goal", value: "8h 0m", systemImage: "flag.fill", color: Color.green)
                    }
                    .padding(.horizontal)
                    
                    // Task List Title
                    Text("Your Tasks")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    // Task Cards
                    VStack(spacing: 16) {
                        ForEach(tasks.indices, id: \.self) { index in
                            Button(action:{
                                selectedTaskIndex = index
                                isDetailViewActive = true
                            }){
                                ColorfulTaskCard(
                                    taskTitle: tasks[index].title,
                                    elapsedMinutes: tasks[index].elapsedMinutes,
                                    totalMinutes: tasks[index].totalMinutes,
                                    isCompleted: tasks[index].elapsedMinutes >= tasks[index].totalMinutes,
                                    gradientColors: cardGradients[index % cardGradients.count],
                                    onToggle: {
                                        toggleTimer(for: index)
                                    },
                                    onComplete: {
                                        completeTask(at: index)
                                    },
                                    isRunning: tasks[index].isRunning
                                )

                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                    
                    // Hidden NavigationLink
                    NavigationLink(
                        destination: selectedTaskIndex.map { index in
                            TaskDetailView(task: $tasks[index])
                        },
                        isActive: $isDetailViewActive,
                        label: { EmptyView() }
                    )

                }
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

    // Toggle task timer, only one task can run at a time
    private func toggleTimer(for index: Int) {
        if tasks[index].isRunning {
            // Stop timer
            tasks[index].isRunning = false
            timer?.invalidate()
            timer = nil
        } else {
            // Stop all other tasks
            for i in tasks.indices {
                tasks[i].isRunning = false
            }
            tasks[index].isRunning = true
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                if tasks[index].elapsedMinutes < tasks[index].totalMinutes {
                    tasks[index].elapsedMinutes += 1
                    totalWorkedMinutes += 1
                } else {
                    tasks[index].isRunning = false
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
    }
    
    // Format date
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
    
    // Convert minutes to hours and minutes string
    private func minutesToHours(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)h \(mins)m"
    }
}

// Summary Card View for Worked Today & Daily Goal
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

// Colorful Task Card with start/stop button & progress bar
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
                    Button(action: onToggle) {
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



struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

