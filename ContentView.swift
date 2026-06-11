import SwiftUI

struct DailyRecord: Identifiable, Codable {
    var id: String { dateKey }
    let dateKey: String
    var mathCompleted: Bool
    var englishCompleted: Bool
    var readingCompleted: Bool
    var completedCount: Int
    var gameTimeMinutes: Int
}

struct ScreenTimeManager {
    func applyGameTimeLimit(minutes: Int) {
        // Future integration point:
        // Add FamilyControls, ManagedSettings, and DeviceActivity here when
        // the app is ready to request Apple's Screen Time permissions.
    }
}

struct LearningTaskRow: View {
    let title: String
    let minutes: Int
    let color: Color
    @Binding var isCompleted: Bool

    var body: some View {
        Toggle(isOn: $isCompleted) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.18))
                        .frame(width: 44, height: 44)

                    Image(systemName: isCompleted ? "checkmark" : "book.closed")
                        .font(.headline)
                        .foregroundStyle(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)

                    Text("\(minutes) minutes")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 5)
    }
}

struct ContentView: View {
    @AppStorage("mathCompleted") private var mathCompleted = false
    @AppStorage("englishCompleted") private var englishCompleted = false
    @AppStorage("readingCompleted") private var readingCompleted = false
    @AppStorage("lastSavedDateKey") private var lastSavedDateKey = ""
    @AppStorage("dailyRecordsData") private var dailyRecordsData = ""

    private let totalTaskCount = 3
    private let gameMinutesPerTask = 10
    private let screenTimeManager = ScreenTimeManager()

    private var completedCount: Int {
        [mathCompleted, englishCompleted, readingCompleted].filter { $0 }.count
    }

    private var gameTimeMinutes: Int {
        completedCount * gameMinutesPerTask
    }

    private var allTasksCompleted: Bool {
        completedCount == totalTaskCount
    }

    private var todayKey: String {
        Self.dayFormatter.string(from: Date())
    }

    private var dailyRecords: [DailyRecord] {
        decodeRecords()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.18),
                        Color.green.opacity(0.12),
                        Color.white
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        headerView
                        gameSummaryView
                        taskListView
                        progressView
                        historyView
                        resetButton
                    }
                    .padding()
                }
            }
            .navigationTitle("KidDaily")
            .onAppear {
                prepareToday()
                saveTodayRecord()
            }
            .onChange(of: mathCompleted) { _ in updateTodayProgress() }
            .onChange(of: englishCompleted) { _ in updateTodayProgress() }
            .onChange(of: readingCompleted) { _ in updateTodayProgress() }
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Learning")
                .font(.largeTitle)
                .bold()

            Text("Finish learning tasks to earn game time.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var gameSummaryView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(allTasksCompleted ? "Game Time Unlocked: 30 min" : "Game Time Locked")
                .font(.title2)
                .bold()
                .foregroundStyle(allTasksCompleted ? .green : .red)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(gameTimeMinutes)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))

                Text("min earned")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            Text("Completed: \(completedCount) / \(totalTaskCount)")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.94))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 14, y: 8)
    }

    private var taskListView: some View {
        VStack(spacing: 12) {
            LearningTaskRow(
                title: "Math",
                minutes: 20,
                color: .blue,
                isCompleted: $mathCompleted
            )

            LearningTaskRow(
                title: "English",
                minutes: 20,
                color: .purple,
                isCompleted: $englishCompleted
            )

            LearningTaskRow(
                title: "Reading",
                minutes: 15,
                color: .orange,
                isCompleted: $readingCompleted
            )
        }
    }

    private var progressView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Daily Progress")
                .font(.headline)

            ProgressView(value: Double(completedCount), total: Double(totalTaskCount))
                .tint(allTasksCompleted ? .green : .blue)

            Text("Game time is earned automatically: \(gameMinutesPerTask) minutes per completed task.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var historyView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Records")
                .font(.headline)

            if dailyRecords.isEmpty {
                Text("No records yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(dailyRecords.prefix(7)) { record in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(record.dateKey)
                                .font(.subheadline)
                                .bold()

                            Text("\(record.completedCount) tasks completed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("\(record.gameTimeMinutes) min")
                            .font(.subheadline)
                            .bold()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var resetButton: some View {
        Button {
            mathCompleted = false
            englishCompleted = false
            readingCompleted = false
            updateTodayProgress()
        } label: {
            Label("Reset Today", systemImage: "arrow.counterclockwise")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.blue)
    }

    private func prepareToday() {
        guard lastSavedDateKey != todayKey else { return }

        mathCompleted = false
        englishCompleted = false
        readingCompleted = false
        lastSavedDateKey = todayKey
    }

    private func updateTodayProgress() {
        saveTodayRecord()
        screenTimeManager.applyGameTimeLimit(minutes: gameTimeMinutes)
    }

    private func saveTodayRecord() {
        var records = decodeRecords()
        let todayRecord = DailyRecord(
            dateKey: todayKey,
            mathCompleted: mathCompleted,
            englishCompleted: englishCompleted,
            readingCompleted: readingCompleted,
            completedCount: completedCount,
            gameTimeMinutes: gameTimeMinutes
        )

        records.removeAll { $0.dateKey == todayKey }
        records.insert(todayRecord, at: 0)
        records = Array(records.prefix(30))

        guard let data = try? JSONEncoder().encode(records),
              let json = String(data: data, encoding: .utf8) else {
            return
        }

        dailyRecordsData = json
    }

    private func decodeRecords() -> [DailyRecord] {
        guard let data = dailyRecordsData.data(using: .utf8),
              let records = try? JSONDecoder().decode([DailyRecord].self, from: data) else {
            return []
        }

        return records.sorted { $0.dateKey > $1.dateKey }
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

#Preview {
    ContentView()
}
