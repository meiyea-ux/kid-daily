import SwiftUI

struct LearningTaskRow: View {
    let title: String
    let minutes: Int
    @Binding var isCompleted: Bool

    var body: some View {
        Toggle(isOn: $isCompleted) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text("\(minutes) minutes")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ContentView: View {
    @AppStorage("mathCompleted") private var mathCompleted = false
    @AppStorage("englishCompleted") private var englishCompleted = false
    @AppStorage("readingCompleted") private var readingCompleted = false

    private let totalTaskCount = 3

    private var completedCount: Int {
        [mathCompleted, englishCompleted, readingCompleted].filter { $0 }.count
    }

    private var gameTimeMinutes: Int {
        completedCount * 10
    }

    private var allTasksCompleted: Bool {
        completedCount == totalTaskCount
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerView
                    taskListView
                    progressView
                    gameTimeView
                    resetButton
                }
                .padding()
            }
            .navigationTitle("KidDaily")
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Learning")
                .font(.largeTitle)
                .bold()

            Text("Complete all tasks to unlock game time.")
                .foregroundStyle(.secondary)
        }
    }

    private var taskListView: some View {
        VStack(spacing: 12) {
            LearningTaskRow(
                title: "Math",
                minutes: 20,
                isCompleted: $mathCompleted
            )

            LearningTaskRow(
                title: "English",
                minutes: 20,
                isCompleted: $englishCompleted
            )

            LearningTaskRow(
                title: "Reading",
                minutes: 15,
                isCompleted: $readingCompleted
            )
        }
    }

    private var progressView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Completed: \(completedCount) / \(totalTaskCount)")
                .font(.headline)

            ProgressView(value: Double(completedCount), total: Double(totalTaskCount))
                .tint(allTasksCompleted ? .green : .blue)
        }
    }

    private var gameTimeView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Game Time: \(gameTimeMinutes) min")
                .font(.headline)

            Text(allTasksCompleted ? "Game Time Unlocked: 30 min" : "Game Time Locked")
                .font(.title3)
                .bold()
                .foregroundStyle(allTasksCompleted ? .green : .red)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(allTasksCompleted ? Color.green.opacity(0.12) : Color.red.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var resetButton: some View {
        Button("Reset Today") {
            mathCompleted = false
            englishCompleted = false
            readingCompleted = false
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    ContentView()
}
