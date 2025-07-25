import SwiftUI

struct TaskDetailView: View {
    @Binding var task: TaskResponseModel
    @State private var timer: Timer?

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                // Title
                Text(task.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Elapsed Time Info
                VStack(spacing: 4) {
                    Text("Elapsed Time")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
//                    Text("\(minutesToHours(task.elapsedMinutes)) / \(minutesToHours(task.totalMinutes))")
//                        .font(.title2)
//                        .fontWeight(.semibold)
                }

                // Progress Bar
//                ProgressView(value: Double(task.elapsedMinutes), total: Double(task.totalMinutes))
//                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
//                    .scaleEffect(x: 1, y: 5, anchor: .center)
//                    .padding(.horizontal, 24)
//                    .background(
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(Color(.systemGray6))
//                    )

                // Action Buttons
                VStack(spacing: 16) {
                    // Start / Pause
//                    Button(action: toggleTimer) {
//                        HStack {
//                            Image(systemName: task.isRunning ? "pause.fill" : "play.fill")
//                            Text(task.isRunning ? "Pause" : "Start")
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(task.isRunning ? Color.orange : Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                    }

                    // Only show if running AND not completed
//                    if task.isRunning && task.elapsedMinutes < task.totalMinutes {
//                        Button(action: markAsComplete) {
//                            HStack {
//                                Image(systemName: "checkmark.circle")
//                                Text("Mark as Complete")
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(12)
//                        }
//                    }

                    // If completed, show label
//                    if task.elapsedMinutes >= task.totalMinutes {
//                        Label("Completed", systemImage: "checkmark.seal.fill")
//                            .font(.headline)
//                            .foregroundColor(.green)
//                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 40)
            .padding(.bottom, 60)
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            stopTimer()
        }
    }

    // MARK: - Timer Functions

//    private func toggleTimer() {
//        task.isRunning.toggle()
//
//        if task.isRunning {
//            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
//                if task.elapsedMinutes < task.totalMinutes {
//                    task.elapsedMinutes += 1
//                } else {
//                    markAsComplete()
//                }
//            }
//        } else {
//            stopTimer()
//        }
//    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
      //  task.isRunning = false
    }

    private func markAsComplete() {
        stopTimer()
       // task.elapsedMinutes = task.totalMinutes
    }

    private func minutesToHours(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)h \(mins)m"
    }
}
