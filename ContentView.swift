import SwiftUI

struct DailyRecord: Identifiable, Codable {
    var id: String { dateKey }
    let dateKey: String
    var mathCompleted: Bool
    var englishCompleted: Bool
    var readingCompleted: Bool
    var completedCount: Int
    var gameTimeMinutes: Int

    var isFullyCompleted: Bool {
        completedCount == 3
    }
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
        .background(Color.white.opacity(0.94))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 5)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .foregroundStyle(color)

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(value)
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

struct RecordRow: View {
    let record: DailyRecord

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: record.isFullyCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundStyle(record.isFullyCompleted ? .green : .secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text(record.dateKey)
                    .font(.headline)

                Text("\(record.completedCount) / 3 tasks completed")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(record.gameTimeMinutes) min")
                .font(.headline)
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ContentView: View {
    @AppStorage("mathCompleted") private var mathCompleted = false
    @AppStorage("englishCompleted") private var englishCompleted = false
    @AppStorage("readingCompleted") private var readingCompleted = false
    @AppStorage("lastSavedDateKey") private var lastSavedDateKey = ""
    @AppStorage("dailyRecordsData") private var dailyRecordsData = ""
    @AppStorage("parentPIN") private var parentPIN = "1234"

    @State private var parentPINInput = ""
    @State private var newParentPIN = ""
    @State private var isParentUnlocked = false
    @State private var parentPINError = ""

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

    private var currentStreak: Int {
        streakCount(from: dailyRecords)
    }

    private var lastSevenRecords: [DailyRecord] {
        Array(dailyRecords.prefix(7))
    }

    private var lastSevenGameMinutes: Int {
        lastSevenRecords.reduce(0) { $0 + $1.gameTimeMinutes }
    }

    private var lastSevenCompletedDays: Int {
        lastSevenRecords.filter { $0.isFullyCompleted }.count
    }

    var body: some View {
        TabView {
            NavigationStack {
                appBackground {
                    todayView
                }
                .navigationTitle("KidDaily")
            }
            .tabItem {
                Label("Today", systemImage: "house.fill")
            }

            NavigationStack {
                appBackground {
                    recordsView
                }
                .navigationTitle("Daily Records")
            }
            .tabItem {
                Label("Records", systemImage: "calendar")
            }

            NavigationStack {
                appBackground {
                    if isParentUnlocked {
                        parentView
                    } else {
                        parentLockView
                    }
                }
                .navigationTitle("Parent")
            }
            .tabItem {
                Label("Parent", systemImage: "person.2.fill")
            }
        }
        .onAppear {
            prepareToday()
            saveTodayRecord()
        }
        .onChange(of: mathCompleted) { _ in updateTodayProgress() }
        .onChange(of: englishCompleted) { _ in updateTodayProgress() }
        .onChange(of: readingCompleted) { _ in updateTodayProgress() }
    }

    private var todayView: some View {
        VStack(alignment: .leading, spacing: 22) {
            headerView
            streakCard
            gameSummaryView
            taskListView
            progressView
            resetButton
        }
        .padding()
    }

    private var recordsView: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                StatCard(
                    title: "Current Streak",
                    value: "\(currentStreak)",
                    subtitle: "days",
                    color: .orange,
                    iconName: "flame.fill"
                )

                StatCard(
                    title: "Last 7 Days",
                    value: "\(lastSevenCompletedDays)",
                    subtitle: "perfect days",
                    color: .green,
                    iconName: "checkmark.circle.fill"
                )
            }

            Text("History")
                .font(.headline)

            if dailyRecords.isEmpty {
                emptyRecordsView
            } else {
                VStack(spacing: 10) {
                    ForEach(dailyRecords) { record in
                        RecordRow(record: record)
                    }
                }
            }
        }
        .padding()
    }

    private var parentView: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Parent Dashboard")
                    .font(.largeTitle)
                    .bold()

                Spacer()

                Button("Lock") {
                    isParentUnlocked = false
                    parentPINInput = ""
                    parentPINError = ""
                }
                .buttonStyle(.bordered)
            }

            Text("Review learning consistency and prepare future screen time controls.")
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                StatCard(
                    title: "Streak",
                    value: "\(currentStreak)",
                    subtitle: "days",
                    color: .orange,
                    iconName: "flame.fill"
                )

                StatCard(
                    title: "Game Time",
                    value: "\(lastSevenGameMinutes)",
                    subtitle: "min in 7 days",
                    color: .blue,
                    iconName: "gamecontroller.fill"
                )
            }

            parentControlCard
            parentPINCard
            parentNotesCard

            Spacer(minLength: 20)
        }
        .padding()
    }

    private var parentLockView: some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(systemName: "lock.fill")
                .font(.system(size: 44))
                .foregroundStyle(.blue)

            Text("Parent Area Locked")
                .font(.largeTitle)
                .bold()

            Text("Enter the parent PIN to view records and settings.")
                .foregroundStyle(.secondary)

            SecureField("Parent PIN", text: $parentPINInput)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            if !parentPINError.isEmpty {
                Text(parentPINError)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Button {
                unlockParentArea()
            } label: {
                Label("Unlock Parent Area", systemImage: "lock.open.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Text("Default PIN: 1234")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer(minLength: 20)
        }
        .padding()
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

    private var streakCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "flame.fill")
                .font(.title)
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 4) {
                Text("Continuous Learning")
                    .font(.headline)

                Text("\(currentStreak) day streak")
                    .font(.title3)
                    .bold()
            }

            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 18))
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

    private var parentControlCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lock.shield")
                    .foregroundStyle(.blue)

                Text("Screen Time API")
                    .font(.headline)
            }

            Text("Prepared for future integration with Apple's FamilyControls, ManagedSettings, and DeviceActivity frameworks.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Current earned limit: \(gameTimeMinutes) min")
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var parentPINCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "key.fill")
                    .foregroundStyle(.orange)

                Text("Parent PIN")
                    .font(.headline)
            }

            Text("Change the PIN used to open the Parent tab.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            SecureField("New 4-digit PIN", text: $newParentPIN)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Button("Save New PIN") {
                saveNewParentPIN()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var parentNotesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Parent Notes")
                .font(.headline)

            Text("Use this page later for parent passcode, app selection, daily limits, and approval history.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var emptyRecordsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "calendar")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("No daily records yet.")
                .font(.headline)

            Text("Complete or reset today's tasks to create a record.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.85))
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

    private func appBackground<Content: View>(@ViewBuilder content: () -> Content) -> some View {
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
                content()
            }
        }
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

    private func unlockParentArea() {
        if parentPINInput == parentPIN {
            isParentUnlocked = true
            parentPINInput = ""
            parentPINError = ""
        } else {
            parentPINError = "Incorrect PIN. Try again."
        }
    }

    private func saveNewParentPIN() {
        let trimmedPIN = newParentPIN.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedPIN.count >= 4 else { return }

        parentPIN = trimmedPIN
        newParentPIN = ""
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

    private func streakCount(from records: [DailyRecord]) -> Int {
        var streak = 0
        var date = Calendar.current.startOfDay(for: Date())

        while true {
            let key = Self.dayFormatter.string(from: date)
            guard records.first(where: { $0.dateKey == key })?.isFullyCompleted == true else {
                break
            }

            streak += 1

            guard let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date) else {
                break
            }

            date = previousDate
        }

        return streak
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
