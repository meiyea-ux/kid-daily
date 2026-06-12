import SwiftUI
import Foundation
import Combine

#if canImport(FamilyControls)
import FamilyControls
#endif

#if canImport(ManagedSettings)
import ManagedSettings
#endif

#if canImport(HealthKit)
import HealthKit
#endif

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

enum ScreenTimeAuthorizationState: String {
    case unavailable = "Unavailable"
    case notDetermined = "Not Determined"
    case denied = "Denied"
    case approved = "Approved"

    var color: Color {
        switch self {
        case .approved:
            return .green
        case .denied:
            return .red
        case .notDetermined:
            return .orange
        case .unavailable:
            return .secondary
        }
    }
}

@MainActor
final class ScreenTimeManager: ObservableObject {
    @Published var authorizationState: ScreenTimeAuthorizationState = .unavailable
    @Published var statusMessage = "Screen Time frameworks are not available in this build."

    #if canImport(ManagedSettings)
    private let store = ManagedSettingsStore()
    #endif

    init() {
        refreshAuthorizationState()
    }

    func refreshAuthorizationState() {
        #if canImport(FamilyControls)
        switch AuthorizationCenter.shared.authorizationStatus {
        case .notDetermined:
            authorizationState = .notDetermined
            statusMessage = "Screen Time permission has not been requested yet."
        case .denied:
            authorizationState = .denied
            statusMessage = "Screen Time permission was denied."
        case .approved:
            authorizationState = .approved
            statusMessage = "Screen Time permission is approved."
        @unknown default:
            authorizationState = .unavailable
            statusMessage = "Unknown Screen Time authorization status."
        }
        #else
        authorizationState = .unavailable
        statusMessage = "FamilyControls is unavailable in this build."
        #endif
    }

    func requestAuthorization() async {
        #if canImport(FamilyControls)
        statusMessage = "Requesting Screen Time permission..."
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            refreshAuthorizationState()
        } catch {
            authorizationState = .denied
            statusMessage = "Authorization failed: \(error.localizedDescription)"
        }
        #else
        authorizationState = .unavailable
        statusMessage = "FamilyControls is unavailable in this build."
        #endif
    }

    #if canImport(FamilyControls) && canImport(ManagedSettings)
    func applyGameTimeLimit(minutes: Int, selection: FamilyActivitySelection) {
        guard authorizationState == .approved else {
            statusMessage = "Approve Screen Time access before applying limits."
            return
        }

        guard minutes > 0 else {
            clearRestrictions()
            statusMessage = "No earned game time yet. Selected apps are not shielded."
            return
        }

        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
        statusMessage = "Screen Time shield updated for selected apps and categories."
    }
    #else
    func applyGameTimeLimit(minutes: Int) {
        statusMessage = "Screen Time frameworks are unavailable in this build."
    }
    #endif

    func clearRestrictions() {
        #if canImport(ManagedSettings)
        store.clearAllSettings()
        statusMessage = "Screen Time restrictions cleared."
        #else
        statusMessage = "ManagedSettings is unavailable in this build."
        #endif
    }
}

@MainActor
final class HealthSyncManager: ObservableObject {
    @Published var statusMessage = "Health sync is ready for iPhone and Apple Watch data."
    @Published var isSyncing = false
    @Published var steps = 0
    @Published var exerciseMinutes = 0
    @Published var activeEnergyKcal = 0
    @Published var latestWorkoutName = "No workout yet"
    @Published var latestWorkoutMinutes = 0

    #if canImport(HealthKit)
    private let healthStore = HKHealthStore()
    #endif

    var isHealthDataAvailable: Bool {
        #if canImport(HealthKit)
        HKHealthStore.isHealthDataAvailable()
        #else
        false
        #endif
    }

    func requestAuthorizationAndSync() async {
        #if canImport(HealthKit)
        guard isHealthDataAvailable else {
            statusMessage = "Health data is not available on this device. Test on a real iPhone."
            return
        }

        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime),
              let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            statusMessage = "HealthKit quantity types are unavailable."
            return
        }

        let readTypes: Set<HKObjectType> = [
            stepType,
            exerciseType,
            energyType,
            HKObjectType.workoutType()
        ]

        do {
            statusMessage = "Requesting Health permission..."
            try await requestHealthAuthorization(readTypes: readTypes)
            await syncTodayHealthData()
        } catch {
            statusMessage = "Health permission failed: \(error.localizedDescription)"
        }
        #else
        statusMessage = "HealthKit is unavailable in this build."
        #endif
    }

    func syncTodayHealthData() async {
        #if canImport(HealthKit)
        guard isHealthDataAvailable else {
            statusMessage = "Health data is not available on this device. Test on a real iPhone."
            return
        }

        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime),
              let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            statusMessage = "HealthKit quantity types are unavailable."
            return
        }

        isSyncing = true
        statusMessage = "Syncing today's Health data..."

        async let todaySteps = sumQuantity(stepType, unit: HKUnit.count())
        async let todayExercise = sumQuantity(exerciseType, unit: HKUnit.minute())
        async let todayEnergy = sumQuantity(energyType, unit: HKUnit.kilocalorie())
        async let workout = latestWorkout()

        let syncedSteps = await todaySteps
        let syncedExercise = await todayExercise
        let syncedEnergy = await todayEnergy
        let syncedWorkout = await workout

        steps = Int(syncedSteps.rounded())
        exerciseMinutes = Int(syncedExercise.rounded())
        activeEnergyKcal = Int(syncedEnergy.rounded())
        latestWorkoutName = syncedWorkout.name
        latestWorkoutMinutes = syncedWorkout.minutes
        isSyncing = false
        statusMessage = "Health data synced from iPhone / Apple Watch."
        #else
        statusMessage = "HealthKit is unavailable in this build."
        #endif
    }

    #if canImport(HealthKit)
    private func todayPredicate() -> NSPredicate {
        let start = Calendar.current.startOfDay(for: Date())
        return HKQuery.predicateForSamples(withStart: start, end: Date(), options: .strictStartDate)
    }

    private func requestHealthAuthorization(readTypes: Set<HKObjectType>) async throws {
        try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: NSError(domain: "KidDailyHealth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Health permission was not granted."]))
                }
            }
        }
    }

    private func sumQuantity(_ type: HKQuantityType, unit: HKUnit) async -> Double {
        await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: todayPredicate(),
                options: .cumulativeSum
            ) { _, statistics, _ in
                let value = statistics?.sumQuantity()?.doubleValue(for: unit) ?? 0
                continuation.resume(returning: value)
            }

            healthStore.execute(query)
        }
    }

    private func latestWorkout() async -> (name: String, minutes: Int) {
        await withCheckedContinuation { continuation in
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(
                sampleType: HKObjectType.workoutType(),
                predicate: todayPredicate(),
                limit: 1,
                sortDescriptors: [sort]
            ) { _, samples, _ in
                guard let workout = samples?.first as? HKWorkout else {
                    continuation.resume(returning: ("No workout yet", 0))
                    return
                }

                let minutes = Int((workout.endDate.timeIntervalSince(workout.startDate) / 60).rounded())
                continuation.resume(returning: (workout.workoutActivityType.displayName, minutes))
            }

            healthStore.execute(query)
        }
    }
    #endif
}

#if canImport(HealthKit)
private extension HKWorkoutActivityType {
    var displayName: String {
        switch self {
        case .running:
            return "Running"
        case .walking:
            return "Walking"
        case .cycling:
            return "Cycling"
        case .swimming:
            return "Swimming"
        case .traditionalStrengthTraining:
            return "Strength Training"
        case .yoga:
            return "Yoga"
        case .dance:
            return "Dance"
        default:
            return "Workout"
        }
    }
}
#endif

@MainActor
final class CloudSyncManager: ObservableObject {
    @Published var statusMessage = "Enter the pairing code from the parent web dashboard."
    @Published var isUploading = false

    private let supabaseUrl = "https://vjxainvzqawflspdchhg.supabase.co"
    private let supabasePublishableKey = "sb_publishable_ZpSnxUTDfmVnu0MMGbcjOw_b_icH-Jl"

    struct UploadPayload: Encodable {
        let p_pairing_code: String
        let p_report_date: String
        let p_math_completed: Bool
        let p_english_completed: Bool
        let p_reading_completed: Bool
        let p_completed_count: Int
        let p_game_time_minutes: Int
        let p_learning_minutes: Int
        let p_entertainment_minutes: Int
        let p_reading_minutes: Int
    }

    struct RemoteSettings: Decodable {
        let math_minutes: Int
        let english_minutes: Int
        let reading_minutes: Int
        let game_minutes_per_task: Int
        let math_note: String
        let english_note: String
        let reading_note: String
        let word_level: String?
        let daily_word_goal: Int?
        let custom_word_list: String?
        let ai_word_prompt: String?
    }

    func fetchRemoteSettings(pairingCode: String) async -> RemoteSettings? {
        let trimmedCode = pairingCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        guard !trimmedCode.isEmpty else {
            statusMessage = "Enter a pairing code before syncing settings."
            return nil
        }

        guard let url = URL(string: "\(supabaseUrl)/rest/v1/rpc/get_kiddaily_settings_by_pairing_code") else {
            statusMessage = "Invalid Supabase URL."
            return nil
        }

        do {
            isUploading = true
            statusMessage = "Syncing settings from web parent dashboard..."

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(supabasePublishableKey, forHTTPHeaderField: "apikey")
            request.setValue("Bearer \(supabasePublishableKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(["p_pairing_code": trimmedCode])

            let (data, response) = try await URLSession.shared.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            guard (200...299).contains(statusCode) else {
                statusMessage = "Settings sync failed. HTTP \(statusCode)."
                isUploading = false
                return nil
            }

            let settings = try JSONDecoder().decode([RemoteSettings].self, from: data)
            isUploading = false

            guard let firstSettings = settings.first else {
                statusMessage = "No remote settings found for this pairing code."
                return nil
            }

            statusMessage = "Remote settings synced."
            return firstSettings
        } catch {
            isUploading = false
            statusMessage = "Settings sync failed: \(error.localizedDescription)"
            return nil
        }
    }

    func uploadTodayRecord(
        pairingCode: String,
        reportDate: String,
        mathCompleted: Bool,
        englishCompleted: Bool,
        readingCompleted: Bool,
        completedCount: Int,
        gameTimeMinutes: Int,
        mathMinutes: Int,
        englishMinutes: Int,
        readingMinutes: Int
    ) async {
        let trimmedCode = pairingCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        guard !trimmedCode.isEmpty else {
            statusMessage = "Enter a pairing code before uploading."
            return
        }

        guard let url = URL(string: "\(supabaseUrl)/rest/v1/rpc/upload_kiddaily_record_by_pairing_code") else {
            statusMessage = "Invalid Supabase URL."
            return
        }

        let payload = UploadPayload(
            p_pairing_code: trimmedCode,
            p_report_date: reportDate,
            p_math_completed: mathCompleted,
            p_english_completed: englishCompleted,
            p_reading_completed: readingCompleted,
            p_completed_count: completedCount,
            p_game_time_minutes: gameTimeMinutes,
            p_learning_minutes: (mathCompleted ? mathMinutes : 0) + (englishCompleted ? englishMinutes : 0),
            p_entertainment_minutes: gameTimeMinutes,
            p_reading_minutes: readingCompleted ? readingMinutes : 0
        )

        do {
            isUploading = true
            statusMessage = "Uploading today's record..."

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(supabasePublishableKey, forHTTPHeaderField: "apikey")
            request.setValue("Bearer \(supabasePublishableKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(payload)

            let (_, response) = try await URLSession.shared.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            if (200...299).contains(statusCode) {
                statusMessage = "Uploaded to parent web dashboard."
            } else {
                statusMessage = "Upload failed. HTTP \(statusCode). Check pairing code and Supabase SQL."
            }
        } catch {
            statusMessage = "Upload failed: \(error.localizedDescription)"
        }

        isUploading = false
    }
}

struct LearningTaskRow: View {
    let title: String
    let minutes: Int
    let note: String
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

                    if !note.isEmpty {
                        Text(note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(isCompleted ? Color.green.opacity(0.16) : Color.white.opacity(0.94))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(isCompleted ? Color.green.opacity(0.45) : Color.clear, lineWidth: 2)
        }
        .shadow(color: .black.opacity(0.06), radius: 10, y: 5)
        .animation(.spring(response: 0.28, dampingFraction: 0.8), value: isCompleted)
    }
}

struct EncouragementCard: View {
    let completedCount: Int
    let totalTaskCount: Int
    let gameTimeMinutes: Int
    let maxGameTimeMinutes: Int

    private var iconName: String {
        completedCount == totalTaskCount ? "party.popper.fill" : "sparkles"
    }

    private var title: String {
        switch completedCount {
        case 0:
            return "Ready to start?"
        case 1:
            return "Nice start!"
        case 2:
            return "Almost there!"
        default:
            return "Great job!"
        }
    }

    private var message: String {
        switch completedCount {
        case 0:
            return "Complete your first task to earn game time."
        case 1:
            return "You earned \(gameTimeMinutes) minutes. Keep going."
        case 2:
            return "One more task unlocks the full reward."
        default:
            return "All tasks are done. You unlocked \(maxGameTimeMinutes) minutes."
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(completedCount == totalTaskCount ? Color.green.opacity(0.18) : Color.yellow.opacity(0.22))
                    .frame(width: 52, height: 52)

                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundStyle(completedCount == totalTaskCount ? .green : .orange)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(completedCount == totalTaskCount ? Color.green.opacity(0.14) : Color.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        .animation(.spring(response: 0.3, dampingFraction: 0.75), value: completedCount)
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

struct RecordDetailView: View {
    let record: DailyRecord

    var body: some View {
        List {
            Section("Summary") {
                HStack {
                    Text("Date")
                    Spacer()
                    Text(record.dateKey)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Completed")
                    Spacer()
                    Text("\(record.completedCount) / 3")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Game Time")
                    Spacer()
                    Text("\(record.gameTimeMinutes) min")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Tasks") {
                detailTaskRow(title: "Math", isCompleted: record.mathCompleted)
                detailTaskRow(title: "English", isCompleted: record.englishCompleted)
                detailTaskRow(title: "Reading", isCompleted: record.readingCompleted)
            }
        }
        .navigationTitle("Record Detail")
    }

    private func detailTaskRow(title: String, isCompleted: Bool) -> some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isCompleted ? .green : .secondary)

            Text(title)

            Spacer()

            Text(isCompleted ? "Done" : "Not Done")
                .foregroundStyle(.secondary)
        }
    }
}

struct ScreenTimeSetupStep: View {
    let number: Int
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(Color.blue)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct WordQuestion: Identifiable {
    let id = UUID()
    let word: String
    let pronunciation: String
    let correctMeaning: String
    let options: [String]
    let example: String
}

struct ContentView: View {
    @StateObject private var screenTimeManager = ScreenTimeManager()
    @StateObject private var cloudSyncManager = CloudSyncManager()
    @StateObject private var healthSyncManager = HealthSyncManager()

    @AppStorage("mathCompleted") private var mathCompleted = false
    @AppStorage("englishCompleted") private var englishCompleted = false
    @AppStorage("readingCompleted") private var readingCompleted = false
    @AppStorage("lastSavedDateKey") private var lastSavedDateKey = ""
    @AppStorage("dailyRecordsData") private var dailyRecordsData = ""
    @AppStorage("parentPIN") private var parentPIN = "1234"
    @AppStorage("mathMinutes") private var mathMinutes = 20
    @AppStorage("englishMinutes") private var englishMinutes = 20
    @AppStorage("readingMinutes") private var readingMinutes = 15
    @AppStorage("gameMinutesPerTask") private var gameMinutesPerTask = 10
    @AppStorage("childName") private var childName = "Kid"
    @AppStorage("mathNote") private var mathNote = "Practice number skills"
    @AppStorage("englishNote") private var englishNote = "Learn words and sentences"
    @AppStorage("readingNote") private var readingNote = "Read a story or book"
    @AppStorage("webPairingCode") private var webPairingCode = ""
    @AppStorage("wordLevel") private var wordLevel = "Starter"
    @AppStorage("dailyWordGoal") private var dailyWordGoal = 10
    @AppStorage("customWordList") private var customWordList = ""
    @AppStorage("aiWordPrompt") private var aiWordPrompt = ""
    @AppStorage("wrongWordsData") private var wrongWordsData = ""

    @State private var parentPINInput = ""
    @State private var newParentPIN = ""
    @State private var isParentUnlocked = false
    @State private var parentPINError = ""
    @State private var wordQuestionIndex = 0
    @State private var wordCorrectCount = 0
    @State private var wordFeedback = "Choose the correct meaning to pass each word gate."

    private let totalTaskCount = 3

    #if canImport(FamilyControls)
    @State private var activitySelection = FamilyActivitySelection()
    @State private var isActivityPickerPresented = false
    #endif

    private var completedCount: Int {
        [mathCompleted, englishCompleted, readingCompleted].filter { $0 }.count
    }

    private var gameTimeMinutes: Int {
        completedCount * gameMinutesPerTask
    }

    private var maxGameTimeMinutes: Int {
        totalTaskCount * gameMinutesPerTask
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

    private var wordChallengeFinished: Bool {
        wordQuestionIndex >= dailyWordQuestions.count
    }

    private var currentWordQuestion: WordQuestion {
        dailyWordQuestions[min(wordQuestionIndex, dailyWordQuestions.count - 1)]
    }

    private var dailyWordQuestions: [WordQuestion] {
        let customQuestions = parseCustomWordList()
        let source = customQuestions.isEmpty ? Self.words(for: wordLevel) : customQuestions
        return Array(source.prefix(max(1, min(dailyWordGoal, source.count))))
    }

    private var wrongWords: [String] {
        wrongWordsData
            .split(separator: "|")
            .map { String($0) }
            .filter { !$0.isEmpty }
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
                    wordChallengeView
                }
                .navigationTitle("Words")
            }
            .tabItem {
                Label("Words", systemImage: "textformat.abc")
            }

            NavigationStack {
                appBackground {
                    movementView
                }
                .navigationTitle("Move")
            }
            .tabItem {
                Label("Move", systemImage: "figure.walk")
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
            screenTimeManager.refreshAuthorizationState()
        }
        .onChange(of: mathCompleted) { _ in updateTodayProgress() }
        .onChange(of: englishCompleted) { _ in updateTodayProgress() }
        .onChange(of: readingCompleted) { _ in updateTodayProgress() }
        .onChange(of: gameMinutesPerTask) { _ in updateTodayProgress() }
        #if canImport(FamilyControls)
        .familyActivityPicker(isPresented: $isActivityPickerPresented, selection: $activitySelection)
        #endif
    }

    private var todayView: some View {
        VStack(alignment: .leading, spacing: 22) {
            headerView
            streakCard
            encouragementView
            gameSummaryView
            taskListView
            progressView
            resetButton
        }
        .padding()
    }

    private var wordChallengeView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Word Challenge")
                    .font(.largeTitle)
                    .bold()

                Text("Pass today's word gates to complete the English task.")
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                StatCard(
                    title: "Gate",
                    value: "\(min(wordQuestionIndex + 1, dailyWordQuestions.count))",
                    subtitle: "of \(dailyWordQuestions.count)",
                    color: .purple,
                    iconName: "flag.checkered"
                )

                StatCard(
                    title: "Correct",
                    value: "\(wordCorrectCount)",
                    subtitle: "words",
                    color: .green,
                    iconName: "checkmark.seal.fill"
                )
            }

            Text("Level: \(wordLevel) | Daily goal: \(dailyWordQuestions.count) words")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if wordChallengeFinished {
                wordChallengeCompleteCard
            } else {
                wordQuestionCard
            }

            wrongWordsReviewCard

            Text(wordFeedback)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button {
                resetWordChallenge()
            } label: {
                Label("Restart Word Challenge", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    private var wordQuestionCard: some View {
        let question = currentWordQuestion

        return VStack(alignment: .leading, spacing: 16) {
            Text("Word Gate \(wordQuestionIndex + 1)")
                .font(.headline)
                .foregroundStyle(.purple)

            Text(question.word)
                .font(.system(size: 48, weight: .bold, design: .rounded))

            Text(question.pronunciation)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(question.example)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(spacing: 10) {
                ForEach(question.options, id: \.self) { option in
                    Button {
                        answerWord(option)
                    } label: {
                        HStack {
                            Text(option)
                                .font(.headline)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.92))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.16), Color.blue.opacity(0.10), Color.white.opacity(0.92)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 14, y: 8)
    }

    private var wordChallengeCompleteCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "trophy.fill")
                .font(.largeTitle)
                .foregroundStyle(.yellow)

            Text("Challenge Complete")
                .font(.title)
                .bold()

            Text("Score: \(wordCorrectCount) / \(dailyWordQuestions.count)")
                .font(.headline)

            Text("English task is now completed. Your earned game time has been updated.")
                .foregroundStyle(.secondary)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 14, y: 8)
    }

    private var wrongWordsReviewCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "book.closed.fill")
                    .foregroundStyle(.orange)

                Text("Wrong Words")
                    .font(.headline)

                Spacer()

                Text("\(wrongWords.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            if wrongWords.isEmpty {
                Text("No wrong words yet. Keep going.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text(wrongWords.prefix(8).joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {
                wrongWordsData = ""
            } label: {
                Label("Clear Wrong Words", systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(wrongWords.isEmpty)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var movementView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Movement Check")
                    .font(.largeTitle)
                    .bold()

                Text("Sync exercise results from iPhone Health and Apple Watch.")
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                StatCard(
                    title: "Steps",
                    value: "\(healthSyncManager.steps)",
                    subtitle: "today",
                    color: .green,
                    iconName: "figure.walk"
                )

                StatCard(
                    title: "Exercise",
                    value: "\(healthSyncManager.exerciseMinutes)",
                    subtitle: "min today",
                    color: .orange,
                    iconName: "figure.run"
                )
            }

            HStack(spacing: 12) {
                StatCard(
                    title: "Active Energy",
                    value: "\(healthSyncManager.activeEnergyKcal)",
                    subtitle: "kcal",
                    color: .red,
                    iconName: "flame.fill"
                )

                StatCard(
                    title: "Latest Workout",
                    value: "\(healthSyncManager.latestWorkoutMinutes)",
                    subtitle: healthSyncManager.latestWorkoutName,
                    color: .blue,
                    iconName: "figure.cooldown"
                )
            }

            movementSyncCard
        }
        .padding()
    }

    private var movementSyncCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .foregroundStyle(.red)

                Text("Health Data Sync")
                    .font(.headline)
            }

            Text("Reads today's steps, Apple exercise minutes, active energy, and latest workout. Apple Watch workouts appear here after they sync to the iPhone Health app.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                Task {
                    await healthSyncManager.requestAuthorizationAndSync()
                }
            } label: {
                Label("Request Health Permission", systemImage: "heart.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(healthSyncManager.isSyncing)

            Button {
                Task {
                    await healthSyncManager.syncTodayHealthData()
                }
            } label: {
                Label(healthSyncManager.isSyncing ? "Syncing..." : "Sync Health Data", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(healthSyncManager.isSyncing)

            Text(healthSyncManager.statusMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
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
                        NavigationLink {
                            RecordDetailView(record: record)
                        } label: {
                            RecordRow(record: record)
                        }
                        .buttonStyle(.plain)
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
            screenTimeSetupCard
            parentMovementCard
            cloudSyncCard
            childProfileCard
            parentTaskSettingsCard
            parentWordSettingsCard
            parentRewardSettingsCard
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

            Text("Good job, \(childName). Finish learning tasks to earn game time.")
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
            Text(allTasksCompleted ? "Game Time Unlocked: \(maxGameTimeMinutes) min" : "Game Time Locked")
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

    private var encouragementView: some View {
        EncouragementCard(
            completedCount: completedCount,
            totalTaskCount: totalTaskCount,
            gameTimeMinutes: gameTimeMinutes,
            maxGameTimeMinutes: maxGameTimeMinutes
        )
    }

    private var taskListView: some View {
        VStack(spacing: 12) {
            LearningTaskRow(
                title: "Math",
                minutes: mathMinutes,
                note: mathNote,
                color: .blue,
                isCompleted: $mathCompleted
            )

            LearningTaskRow(
                title: "English",
                minutes: englishMinutes,
                note: englishNote,
                color: .purple,
                isCompleted: $englishCompleted
            )

            LearningTaskRow(
                title: "Reading",
                minutes: readingMinutes,
                note: readingNote,
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

            Text("Authorization: \(screenTimeManager.authorizationState.rawValue)")
                .font(.subheadline)
                .foregroundStyle(screenTimeManager.authorizationState.color)

            Text("Current earned limit: \(gameTimeMinutes) min")
                .font(.headline)

            Text(screenTimeManager.statusMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button {
                Task {
                    await screenTimeManager.requestAuthorization()
                }
            } label: {
                Label("Request Screen Time Permission", systemImage: "person.badge.key.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            #if canImport(FamilyControls)
            Button {
                screenTimeManager.statusMessage = "Opening app and category picker..."
                isActivityPickerPresented = true
            } label: {
                Label("Select Apps and Categories", systemImage: "app.badge")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            #else
            Text("FamilyActivityPicker is unavailable in this build.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            #endif

            Button {
                applyScreenTimeLimit()
            } label: {
                Label("Apply Earned Limit", systemImage: "checkmark.shield.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button(role: .destructive) {
                screenTimeManager.clearRestrictions()
            } label: {
                Label("Clear Screen Time Restrictions", systemImage: "xmark.shield.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var screenTimeSetupCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "iphone.and.arrow.forward")
                    .foregroundStyle(.blue)

                Text("Setup Screen Time")
                    .font(.headline)
            }

            Text("Preparation checklist for the future Apple Screen Time integration.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ScreenTimeSetupStep(
                number: 1,
                title: "Request Permission",
                description: "Ask the parent to approve FamilyControls access."
            )

            ScreenTimeSetupStep(
                number: 2,
                title: "Select Apps",
                description: "Choose which games or apps are managed by KidDaily."
            )

            ScreenTimeSetupStep(
                number: 3,
                title: "Apply Limit",
                description: "Use earned game time to apply a daily screen time limit."
            )

            ScreenTimeSetupStep(
                number: 4,
                title: "Monitor Usage",
                description: "Read activity reports and update the parent dashboard."
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var parentMovementCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.walk.motion")
                    .foregroundStyle(.green)

                Text("Movement Results")
                    .font(.headline)
            }

            Text("Today: \(healthSyncManager.steps) steps, \(healthSyncManager.exerciseMinutes) exercise minutes, \(healthSyncManager.activeEnergyKcal) kcal.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Latest workout: \(healthSyncManager.latestWorkoutName), \(healthSyncManager.latestWorkoutMinutes) min.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button {
                Task {
                    await healthSyncManager.syncTodayHealthData()
                }
            } label: {
                Label("Refresh Movement Data", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(healthSyncManager.isSyncing)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var cloudSyncCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "icloud.and.arrow.up.fill")
                    .foregroundStyle(.blue)

                Text("Web Parent Sync")
                    .font(.headline)
            }

            Text("Enter the pairing code generated in the parent web dashboard. Today's learning and game time will upload for remote monitoring.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("Pairing code", text: $webPairingCode)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            Button {
                syncSettingsFromWeb()
            } label: {
                Label("Sync Remote Settings", systemImage: "arrow.down.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(cloudSyncManager.isUploading)

            Button {
                uploadTodayRecordToWeb()
            } label: {
                Label(cloudSyncManager.isUploading ? "Uploading..." : "Upload Today's Record", systemImage: "arrow.up.doc.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(cloudSyncManager.isUploading)

            Text(cloudSyncManager.statusMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func uploadTodayRecordToWeb() {
        Task {
            await cloudSyncManager.uploadTodayRecord(
                pairingCode: webPairingCode,
                reportDate: todayKey,
                mathCompleted: mathCompleted,
                englishCompleted: englishCompleted,
                readingCompleted: readingCompleted,
                completedCount: completedCount,
                gameTimeMinutes: gameTimeMinutes,
                mathMinutes: mathMinutes,
                englishMinutes: englishMinutes,
                readingMinutes: readingMinutes
            )
        }
    }

    private func syncSettingsFromWeb() {
        Task {
            guard let settings = await cloudSyncManager.fetchRemoteSettings(pairingCode: webPairingCode) else {
                return
            }

            mathMinutes = settings.math_minutes
            englishMinutes = settings.english_minutes
            readingMinutes = settings.reading_minutes
            gameMinutesPerTask = settings.game_minutes_per_task
            mathNote = settings.math_note
            englishNote = settings.english_note
            readingNote = settings.reading_note
            wordLevel = settings.word_level ?? wordLevel
            dailyWordGoal = settings.daily_word_goal ?? dailyWordGoal
            customWordList = settings.custom_word_list ?? customWordList
            aiWordPrompt = settings.ai_word_prompt ?? aiWordPrompt
            resetWordChallenge()
            updateTodayProgress()
        }
    }

    private var childProfileCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundStyle(.green)

                Text("Child Profile")
                    .font(.headline)
            }

            Text("Set the child's name for the Today screen.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("Child name", text: $childName)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var parentTaskSettingsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(.purple)

                Text("Learning Tasks")
                    .font(.headline)
            }

            Text("Adjust the expected learning time for each daily task.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper("Math: \(mathMinutes) min", value: $mathMinutes, in: 5...120, step: 5)
            Stepper("English: \(englishMinutes) min", value: $englishMinutes, in: 5...120, step: 5)
            Stepper("Reading: \(readingMinutes) min", value: $readingMinutes, in: 5...120, step: 5)

            TextField("Math note", text: $mathNote)
                .textFieldStyle(.roundedBorder)

            TextField("English note", text: $englishNote)
                .textFieldStyle(.roundedBorder)

            TextField("Reading note", text: $readingNote)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var parentWordSettingsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "textformat.abc")
                    .foregroundStyle(.purple)

                Text("Word Challenge")
                    .font(.headline)
            }

            Text("Choose a level, set the daily word goal, or paste custom words from the parent web dashboard.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Picker("Word Level", selection: $wordLevel) {
                Text("Starter").tag("Starter")
                Text("Builder").tag("Builder")
                Text("Explorer").tag("Explorer")
            }
            .pickerStyle(.segmented)

            Stepper("Daily words: \(dailyWordGoal)", value: $dailyWordGoal, in: 5...10, step: 1)

            TextField("Custom words: apple=苹果, brave=勇敢", text: $customWordList, axis: .vertical)
                .lineLimit(2...4)
                .textFieldStyle(.roundedBorder)

            TextField("AI prompt for future generation", text: $aiWordPrompt, axis: .vertical)
                .lineLimit(2...4)
                .textFieldStyle(.roundedBorder)

            Text("Active word list: \(dailyWordQuestions.count) words. AI generation is prepared for a later backend connection.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var parentRewardSettingsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "gamecontroller.fill")
                    .foregroundStyle(.blue)

                Text("Reward Rule")
                    .font(.headline)
            }

            Text("Set how much game time one completed task earns.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper(
                "Reward: \(gameMinutesPerTask) min per task",
                value: $gameMinutesPerTask,
                in: 5...60,
                step: 5
            )

            Text("All three tasks can unlock up to \(maxGameTimeMinutes) minutes.")
                .font(.footnote)
                .foregroundStyle(.secondary)
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

    private func answerWord(_ option: String) {
        guard !wordChallengeFinished else { return }

        let question = currentWordQuestion
        if option == question.correctMeaning {
            wordCorrectCount += 1
            wordFeedback = "Correct. \(question.word) means \(question.correctMeaning)."
        } else {
            wordFeedback = "Good try. \(question.word) means \(question.correctMeaning)."
            saveWrongWord(question)
        }

        wordQuestionIndex += 1

        if wordChallengeFinished {
            englishCompleted = true
            updateTodayProgress()
        }
    }

    private func resetWordChallenge() {
        wordQuestionIndex = 0
        wordCorrectCount = 0
        wordFeedback = "Choose the correct meaning to pass each word gate."
    }

    private func saveWrongWord(_ question: WordQuestion) {
        let entry = "\(question.word): \(question.correctMeaning)"
        var words = wrongWords.filter { $0 != entry }
        words.insert(entry, at: 0)
        wrongWordsData = words.prefix(30).joined(separator: "|")
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
        resetWordChallenge()
        lastSavedDateKey = todayKey
    }

    private func updateTodayProgress() {
        saveTodayRecord()
        applyScreenTimeLimit()

        if !webPairingCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            uploadTodayRecordToWeb()
        }
    }

    private func applyScreenTimeLimit() {
        #if canImport(FamilyControls) && canImport(ManagedSettings)
        screenTimeManager.applyGameTimeLimit(minutes: gameTimeMinutes, selection: activitySelection)
        #else
        screenTimeManager.applyGameTimeLimit(minutes: gameTimeMinutes)
        #endif
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

    private func parseCustomWordList() -> [WordQuestion] {
        customWordList
            .split(whereSeparator: { $0 == "\n" || $0 == "," || $0 == ";" })
            .compactMap { rawItem in
                let parts = rawItem.split(separator: "=", maxSplits: 1).map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                guard parts.count == 2, !parts[0].isEmpty, !parts[1].isEmpty else {
                    return nil
                }

                return WordQuestion(
                    word: parts[0],
                    pronunciation: "custom",
                    correctMeaning: parts[1],
                    options: makeOptions(correct: parts[1]),
                    example: "Parent custom word: \(parts[0])"
                )
            }
    }

    private func makeOptions(correct: String) -> [String] {
        let distractors = ["a place", "a feeling", "an action", "a person", "a thing", "a time"]
            .filter { $0 != correct }
        return Array(([correct] + distractors).prefix(3))
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

    private static func words(for level: String) -> [WordQuestion] {
        switch level {
        case "Builder":
            return builderWords
        case "Explorer":
            return explorerWords
        default:
            return starterWords
        }
    }

    private static let starterWords: [WordQuestion] = [
        WordQuestion(word: "brave", pronunciation: "/breiv/", correctMeaning: "not afraid", options: ["not afraid", "very slow", "full of water"], example: "She was brave during the storm."),
        WordQuestion(word: "garden", pronunciation: "/gar-den/", correctMeaning: "a place to grow plants", options: ["a place to grow plants", "a small computer", "a loud sound"], example: "Dad grows tomatoes in the garden."),
        WordQuestion(word: "quick", pronunciation: "/kwik/", correctMeaning: "fast", options: ["cold", "fast", "quiet"], example: "The quick runner won the race."),
        WordQuestion(word: "share", pronunciation: "/shair/", correctMeaning: "to use with others", options: ["to sleep early", "to use with others", "to draw a line"], example: "Please share your crayons."),
        WordQuestion(word: "bright", pronunciation: "/brite/", correctMeaning: "full of light", options: ["full of light", "hard to carry", "very hungry"], example: "The room is bright in the morning."),
        WordQuestion(word: "kind", pronunciation: "/kynd/", correctMeaning: "nice to others", options: ["nice to others", "very heavy", "not clean"], example: "A kind friend helps others."),
        WordQuestion(word: "river", pronunciation: "/ri-ver/", correctMeaning: "moving water", options: ["moving water", "a school room", "a small bag"], example: "The river runs through town."),
        WordQuestion(word: "quiet", pronunciation: "/kwy-et/", correctMeaning: "not loud", options: ["not loud", "very tall", "made of wood"], example: "The library is quiet."),
        WordQuestion(word: "happy", pronunciation: "/hap-ee/", correctMeaning: "feeling good", options: ["feeling good", "moving fast", "hard to see"], example: "The child is happy."),
        WordQuestion(word: "clean", pronunciation: "/kleen/", correctMeaning: "not dirty", options: ["not dirty", "very old", "full of sound"], example: "Keep your desk clean.")
    ]

    private static let builderWords: [WordQuestion] = [
        WordQuestion(word: "curious", pronunciation: "/kyur-ee-us/", correctMeaning: "wanting to know", options: ["wanting to know", "easy to break", "full of rain"], example: "A curious child asks questions."),
        WordQuestion(word: "improve", pronunciation: "/im-proov/", correctMeaning: "to get better", options: ["to get better", "to hide away", "to fall asleep"], example: "Practice helps you improve."),
        WordQuestion(word: "habit", pronunciation: "/hab-it/", correctMeaning: "something done often", options: ["something done often", "a large animal", "a kind of music"], example: "Reading daily is a good habit."),
        WordQuestion(word: "protect", pronunciation: "/pro-tekt/", correctMeaning: "to keep safe", options: ["to keep safe", "to write quickly", "to make louder"], example: "A helmet can protect your head."),
        WordQuestion(word: "choice", pronunciation: "/choys/", correctMeaning: "something you pick", options: ["something you pick", "a cold drink", "a tiny seed"], example: "You made a smart choice."),
        WordQuestion(word: "focus", pronunciation: "/fo-kus/", correctMeaning: "to pay attention", options: ["to pay attention", "to jump high", "to open a door"], example: "Focus on one task first."),
        WordQuestion(word: "result", pronunciation: "/re-zult/", correctMeaning: "what happens after", options: ["what happens after", "a green plant", "a paper box"], example: "Hard work brings a good result."),
        WordQuestion(word: "patient", pronunciation: "/pay-shent/", correctMeaning: "able to wait", options: ["able to wait", "full of light", "very noisy"], example: "Be patient while learning."),
        WordQuestion(word: "effort", pronunciation: "/ef-ert/", correctMeaning: "hard work", options: ["hard work", "a blue color", "a short song"], example: "Your effort matters."),
        WordQuestion(word: "create", pronunciation: "/kree-ayt/", correctMeaning: "to make", options: ["to make", "to forget", "to sit"], example: "You can create a story.")
    ]

    private static let explorerWords: [WordQuestion] = [
        WordQuestion(word: "discover", pronunciation: "/dis-kuh-ver/", correctMeaning: "to find out", options: ["to find out", "to close tightly", "to walk slowly"], example: "Scientists discover new ideas."),
        WordQuestion(word: "confident", pronunciation: "/kon-fi-dent/", correctMeaning: "sure of yourself", options: ["sure of yourself", "afraid of water", "very messy"], example: "She felt confident after practice."),
        WordQuestion(word: "compare", pronunciation: "/kum-pair/", correctMeaning: "to look for differences", options: ["to look for differences", "to carry food", "to sleep late"], example: "Compare the two answers."),
        WordQuestion(word: "explain", pronunciation: "/eks-playn/", correctMeaning: "to make clear", options: ["to make clear", "to run outside", "to paint red"], example: "Can you explain your idea?"),
        WordQuestion(word: "balance", pronunciation: "/bal-ans/", correctMeaning: "to keep steady", options: ["to keep steady", "to become angry", "to count money"], example: "Balance study and play."),
        WordQuestion(word: "strategy", pronunciation: "/strat-uh-jee/", correctMeaning: "a plan", options: ["a plan", "a small chair", "a kind of fruit"], example: "Use a strategy to solve it."),
        WordQuestion(word: "responsible", pronunciation: "/ri-spon-suh-bul/", correctMeaning: "trusted to do things", options: ["trusted to do things", "easy to bend", "covered in snow"], example: "Be responsible with your time."),
        WordQuestion(word: "achieve", pronunciation: "/uh-cheev/", correctMeaning: "to reach a goal", options: ["to reach a goal", "to make a noise", "to turn around"], example: "You can achieve your goal."),
        WordQuestion(word: "decision", pronunciation: "/di-sizh-un/", correctMeaning: "a choice you make", options: ["a choice you make", "a round stone", "a warm coat"], example: "That was a wise decision."),
        WordQuestion(word: "practice", pronunciation: "/prak-tis/", correctMeaning: "to do again to improve", options: ["to do again to improve", "to eat quickly", "to close a book"], example: "Practice makes skills stronger.")
    ]

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

#Preview {
    ContentView()
}
