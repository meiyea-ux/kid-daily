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


enum AppText {
    static func t(_ key: String, _ args: CVarArg...) -> String {
        let language = currentLanguageKey()
        let format = translations[language]?[key] ?? english[key] ?? key
        guard !args.isEmpty else { return format }
        return String(format: format, locale: Locale(identifier: language), arguments: args)
    }

    static func currentLanguageKey() -> String {
        let preferred = Locale.preferredLanguages.first?.lowercased() ?? "en"
        if preferred.hasPrefix("zh-hans") || preferred.hasPrefix("zh-cn") || preferred.hasPrefix("zh-sg") { return "zh-Hans" }
        if preferred.hasPrefix("zh-hant") || preferred.hasPrefix("zh-tw") || preferred.hasPrefix("zh-hk") || preferred.hasPrefix("zh-mo") { return "zh-Hant" }
        if preferred.hasPrefix("ja") { return "ja" }
        if preferred.hasPrefix("ko") { return "ko" }
        if preferred.hasPrefix("es") { return "es" }
        return "en"
    }

    private static let english: [String: String] = [
        "app_name": "KidDaily",
        "tab_today": "Today",
        "tab_apps": "Apps",
        "tab_move": "Move",
        "tab_records": "Records",
        "tab_parent": "Parent",
        "nav_records": "Daily Records",
        "parent_dashboard": "Parent Dashboard",
        "lock": "Lock",
        "parent_subtitle": "Set study-app goals, reward minutes, entertainment locks, and movement windows.",
        "streak": "Streak",
        "days": "days",
        "game_time": "Game Time",
        "min_in_7_days": "min in 7 days",
        "screen_time_api": "Screen Time API",
        "authorization": "Authorization: %@",
        "current_earned_limit": "Current earned limit: %d min",
        "request_screen_time_permission": "Request Screen Time Permission",
        "select_apps_categories": "Select Apps and Categories",
        "apply_earned_limit": "Apply Earned Limit",
        "clear_screen_time_restrictions": "Clear Screen Time Restrictions",
        "setup_screen_time": "Setup Screen Time",
        "setup_screen_time_subtitle": "Preparation checklist for Apple Screen Time integration.",
        "request_permission": "Request Permission",
        "request_permission_desc": "Request Screen Time access on this iPhone.",
        "select_apps": "Select Apps",
        "select_apps_desc": "Choose which games or apps are managed by KidDaily.",
        "apply_limit": "Apply Limit",
        "apply_limit_desc": "Use earned game time to apply a daily screen time limit.",
        "monitor_usage": "Monitor Usage",
        "monitor_usage_desc": "Read activity reports and update the parent dashboard.",
        "today_learning": "Today's Learning",
        "today_message": "Hi %@, finish learning app goals to earn entertainment time.",
        "continuous_learning": "Continuous Learning",
        "day_streak": "%d day streak",
        "game_time_unlocked": "Entertainment Unlocked: %d min",
        "game_time_locked": "Entertainment Locked",
        "min_earned": "min earned",
        "completed_count": "Completed: %d / %d",
        "daily_progress": "Daily Progress",
        "progress_rule": "Each completed learning app goal earns %d entertainment minutes.",
        "math": "Math",
        "english": "English",
        "reading": "Reading",
        "date": "Date",
        "completed": "Completed",
        "record_detail": "Record Detail",
        "done": "Done",
        "not_done": "Not Done",
        "parent_area_locked": "Parent Area Locked",
        "parent_pin_prompt": "Enter the parent PIN to view records and settings.",
        "parent_pin": "Parent PIN",
        "parent_pin_desc": "Change the PIN used to open the Parent tab.",
        "unlock_parent_area": "Unlock Parent Area",
        "movement_check": "Movement Check",
        "movement_subtitle": "Sync exercise results from iPhone Health and Apple Watch.",
        "history": "History",
        "no_records": "No daily records yet.",
        "no_records_desc": "Complete or reset today's tasks to create a record.",
        "reset_today": "Reset Today",
        "summary": "Summary",
        "tasks": "Tasks",
        "steps": "Steps",
        "today": "today",
        "exercise": "Exercise",
        "min_today": "min today",
        "active_energy": "Active Energy",
        "latest_workout": "Latest Workout",
        "health_data_sync": "Health Data Sync",
        "health_sync_desc": "Reads today's steps, Apple exercise minutes, active energy, and latest workout. Apple Watch workouts appear here after they sync to the iPhone Health app.",
        "request_health_permission": "Request Health Permission",
        "syncing": "Syncing...",
        "sync_health_data": "Sync Health Data",
        "current_streak": "Current Streak",
        "last_7_days": "Last 7 Days",
        "perfect_days": "perfect days",
        "movement_results": "Movement Results",
        "movement_today": "Today: %d steps, %d exercise minutes, %d kcal.",
        "latest_workout_line": "Latest workout: %@, %d min.",
        "refresh_movement_data": "Refresh Movement Data",
        "web_parent_sync": "Web Parent Sync",
        "web_parent_sync_desc": "Enter the pairing code generated in the parent web dashboard. Today's learning and game time will upload for remote monitoring.",
        "pairing_code": "Pairing code",
        "sync_remote_settings": "Sync Remote Settings",
        "uploading": "Uploading...",
        "upload_today_record": "Upload Today's Record",
        "auth_failed": "Authorization failed: %@",
        "opening_picker": "Opening app and category picker...",
        "picker_unavailable": "FamilyActivityPicker is unavailable in this build.",
        "status_not_requested": "Screen Time permission has not been requested yet.",
        "status_denied": "Screen Time permission was denied.",
        "status_approved": "Screen Time permission is approved.",
        "status_unknown": "Unknown Screen Time authorization status.",
        "requesting_screen_time": "Requesting Screen Time permission...",
        "approve_before_limit": "Approve Screen Time access before applying limits.",
        "select_before_limit": "Select apps or categories before applying Screen Time limits.",
        "limit_applied": "Screen Time restrictions applied to selected apps. Earned limit: %d min.",
        "limit_zero": "No earned game time. Selected apps and categories are now restricted.",
        "restrictions_cleared": "Screen Time restrictions cleared.",
        "unavailable_build": "FamilyControls is unavailable in this build.",
        "learning_unlock": "Learning Unlock",
        "learning_unlock_desc": "Entertainment apps stay locked first. Learning app usage earns entertainment minutes.",
        "required": "Required",
        "study_apps": "study apps",
        "earned": "Earned",
        "minutes": "minutes",
        "app_groups": "App Groups",
        "app_groups_desc": "Choose learning apps to monitor and entertainment apps to lock or unlock. Automatic usage reading needs the DeviceActivity extension in the next Xcode step.",
        "choose_learning_apps": "Choose Learning Apps",
        "choose_entertainment_apps": "Choose Entertainment Apps",
        "apply_earned_unlock": "Apply Earned Unlock",
        "lock_entertainment_apps": "Lock Entertainment Apps",
        "move_unlock_rule": "Move Unlock Rule",
        "movement_window_line": "Window: %d:00-%d:00. Goal: %d min %@.",
        "movement_progress_line": "Progress in window: %d / %d min. Reward: %d min.",
        "entertainment_unlocked_status": "Entertainment apps unlocked for %d earned minutes.",
        "entertainment_locked_status": "Entertainment apps are locked until learning or movement goals are completed.",
        "child_profile": "Child Profile",
        "child_profile_desc": "Set the child name for the Today screen.",
        "child_name": "Child name",
        "learning_app_goals": "Learning App Goals",
        "learning_app_goals_desc": "Adjust the expected usage time for each daily learning app.",
        "required_study_apps": "Required study apps: %d",
        "math_app_minutes": "Math app: %d min",
        "english_app_minutes": "English app: %d min",
        "reading_app_minutes": "Reading app: %d min",
        "reward_rule": "Reward Rule",
        "reward_rule_desc": "Set how much entertainment time one completed learning app earns.",
        "max_reward_line": "All learning goals can unlock up to %d minutes before movement rewards.",
        "reward_per_app": "Reward: %d min per completed learning app",
        "movement_window": "Movement Window",
        "movement_window_desc": "Set the daily activity window and the movement reward.",
        "start_hour": "Start: %d:00",
        "end_hour": "End: %d:00",
        "goal_minutes": "Goal: %d min",
        "reward_minutes": "Reward: %d min",
        "activity": "Activity",
        "workout": "Workout",
        "exercise_minutes": "Exercise Minutes",
        "parent_notes": "Parent Notes",
        "parent_notes_desc": "Next build step: add a DeviceActivityMonitor extension so learning app minutes are read automatically instead of checked manually.",
        "incorrect_pin": "Incorrect PIN. Try again.",
        "new_parent_pin": "New 4-digit PIN",
        "save_new_pin": "Save New PIN"
    ]

    private static let translations: [String: [String: String]] = [
        "zh-Hans": [
            "tab_today": "今日", "tab_apps": "应用", "tab_move": "运动", "tab_records": "记录", "tab_parent": "家长",
            "parent_dashboard": "家长控制台", "lock": "锁定", "streak": "连续", "days": "天", "game_time": "娱乐时间",
            "learning_unlock": "学习解锁", "learning_unlock_desc": "先锁定娱乐应用。学习应用达到时长后奖励娱乐时间。",
            "required": "需要", "study_apps": "学习应用", "earned": "已获得", "minutes": "分钟", "app_groups": "应用分组",
            "app_groups_desc": "选择要监测的学习应用，以及要锁定或解锁的娱乐应用。自动读取使用时长需要下一步在 Xcode 添加 DeviceActivity 扩展。",
            "choose_learning_apps": "选择学习应用", "choose_entertainment_apps": "选择娱乐应用", "apply_earned_unlock": "应用已获得解锁", "lock_entertainment_apps": "锁定娱乐应用",
            "move_unlock_rule": "运动解锁规则", "movement_window_line": "时段：%d:00-%d:00。目标：%d 分钟 %@。", "movement_progress_line": "时段内进度：%d / %d 分钟。奖励：%d 分钟。",
            "today_learning": "今日学习", "today_message": "%@，完成学习应用目标即可获得娱乐时间。", "daily_progress": "今日进度",
            "math": "数学", "english": "英语", "reading": "阅读", "movement_check": "运动检测", "movement_subtitle": "同步 iPhone 健康和 Apple Watch 的运动数据。",
            "health_data_sync": "健康数据同步", "request_health_permission": "请求健康权限", "sync_health_data": "同步健康数据", "syncing": "同步中...",
            "parent_area_locked": "家长区已锁定", "parent_pin_prompt": "输入家长 PIN 查看记录和设置。", "parent_pin": "家长 PIN", "unlock_parent_area": "解锁家长区",
            "movement_window": "运动时段", "movement_window_desc": "设置每日活动时段和运动奖励。", "reward_rule": "奖励规则", "learning_app_goals": "学习应用目标",
            "child_profile": "孩子资料", "child_name": "孩子姓名", "parent_notes": "家长备注", "incorrect_pin": "PIN 不正确，请重试。"
        ],
        "zh-Hant": [
            "tab_today": "今日", "tab_apps": "應用", "tab_move": "運動", "tab_records": "記錄", "tab_parent": "家長",
            "parent_dashboard": "家長控制台", "learning_unlock": "學習解鎖", "learning_unlock_desc": "先鎖定娛樂 App。學習 App 達到時長後獎勵娛樂時間。",
            "required": "需要", "study_apps": "學習 App", "earned": "已獲得", "minutes": "分鐘", "app_groups": "App 分組",
            "choose_learning_apps": "選擇學習 App", "choose_entertainment_apps": "選擇娛樂 App", "move_unlock_rule": "運動解鎖規則",
            "today_learning": "今日學習", "math": "數學", "english": "英文", "reading": "閱讀", "movement_check": "運動檢測", "movement_window": "運動時段"
        ],
        "ja": [
            "tab_today": "今日", "tab_apps": "アプリ", "tab_move": "運動", "tab_records": "記録", "tab_parent": "保護者",
            "learning_unlock": "学習でロック解除", "learning_unlock_desc": "娯楽アプリを先にロックし、学習アプリの利用時間に応じて娯楽時間を付与します。",
            "required": "必要", "study_apps": "学習アプリ", "earned": "獲得", "minutes": "分", "app_groups": "アプリグループ",
            "choose_learning_apps": "学習アプリを選択", "choose_entertainment_apps": "娯楽アプリを選択", "move_unlock_rule": "運動ロック解除ルール",
            "today_learning": "今日の学習", "math": "数学", "english": "英語", "reading": "読書", "movement_check": "運動チェック", "movement_window": "運動時間帯"
        ],
        "ko": [
            "tab_today": "오늘", "tab_apps": "앱", "tab_move": "운동", "tab_records": "기록", "tab_parent": "부모",
            "learning_unlock": "학습 잠금 해제", "learning_unlock_desc": "엔터테인먼트 앱을 먼저 잠그고, 학습 앱 사용 시간에 따라 보상 시간을 제공합니다.",
            "required": "필요", "study_apps": "학습 앱", "earned": "획득", "minutes": "분", "app_groups": "앱 그룹",
            "choose_learning_apps": "학습 앱 선택", "choose_entertainment_apps": "엔터테인먼트 앱 선택", "move_unlock_rule": "운동 잠금 해제 규칙",
            "today_learning": "오늘의 학습", "math": "수학", "english": "영어", "reading": "읽기", "movement_check": "운동 확인", "movement_window": "운동 시간대"
        ],
        "es": [
            "tab_today": "Hoy", "tab_apps": "Apps", "tab_move": "Movimiento", "tab_records": "Registros", "tab_parent": "Padres",
            "learning_unlock": "Desbloqueo por estudio", "learning_unlock_desc": "Las apps de entretenimiento se bloquean primero. El uso de apps de aprendizaje gana minutos de entretenimiento.",
            "required": "Necesarias", "study_apps": "apps de estudio", "earned": "Ganado", "minutes": "minutos", "app_groups": "Grupos de apps",
            "choose_learning_apps": "Elegir apps de aprendizaje", "choose_entertainment_apps": "Elegir apps de entretenimiento", "move_unlock_rule": "Regla de movimiento",
            "today_learning": "Aprendizaje de hoy", "math": "Matemáticas", "english": "Inglés", "reading": "Lectura", "movement_check": "Movimiento", "movement_window": "Franja de actividad"
        ]
    ]
}
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

extension ScreenTimeAuthorizationState {
    var localizedName: String {
        rawValue
    }
}

@MainActor
final class ScreenTimeManager: ObservableObject {
    @Published var authorizationState: ScreenTimeAuthorizationState = .unavailable
    @Published var statusMessage = AppText.t("unavailable_build")

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
            statusMessage = AppText.t("status_not_requested")
        case .denied:
            authorizationState = .denied
            statusMessage = AppText.t("status_denied")
        case .approved:
            authorizationState = .approved
            statusMessage = AppText.t("status_approved")
        @unknown default:
            authorizationState = .unavailable
            statusMessage = AppText.t("status_unknown")
        }
        #else
        authorizationState = .unavailable
        statusMessage = AppText.t("unavailable_build")
        #endif
    }

    func requestAuthorization() async {
        #if canImport(FamilyControls)
        statusMessage = AppText.t("requesting_screen_time")
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            refreshAuthorizationState()
        } catch {
            authorizationState = .denied
            statusMessage = AppText.t("auth_failed", error.localizedDescription)
        }
        #else
        authorizationState = .unavailable
        statusMessage = AppText.t("unavailable_build")
        #endif
    }

    #if canImport(FamilyControls) && canImport(ManagedSettings)
    func applyGameTimeLimit(minutes: Int, selection: FamilyActivitySelection) {
        guard authorizationState == .approved else {
            statusMessage = AppText.t("approve_before_limit")
            return
        }

        let hasSelection = !selection.applicationTokens.isEmpty ||
            !selection.categoryTokens.isEmpty ||
            !selection.webDomainTokens.isEmpty

        guard hasSelection else {
            statusMessage = AppText.t("select_before_limit")
            return
        }

        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens

        if minutes > 0 {
            store.clearAllSettings()
            statusMessage = AppText.t("entertainment_unlocked_status", minutes)
        } else {
            statusMessage = AppText.t("entertainment_locked_status")
        }
    }
    #else
    func applyGameTimeLimit(minutes: Int) {
        statusMessage = AppText.t("unavailable_build")
    }
    #endif

    func clearRestrictions() {
        #if canImport(ManagedSettings)
        store.clearAllSettings()
        statusMessage = AppText.t("restrictions_cleared")
        #else
        statusMessage = AppText.t("unavailable_build")
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
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
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
        await withCheckedContinuation { (continuation: CheckedContinuation<Double, Never>) in
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
        await withCheckedContinuation { (continuation: CheckedContinuation<(name: String, minutes: Int), Never>) in
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
    private let textColor = Color(red: 0.10, green: 0.14, blue: 0.22)

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
                .foregroundStyle(textColor)

            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
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

                Text(AppText.t("completed_count", record.completedCount, 3))
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
            Section(AppText.t("summary")) {
                HStack {
                    Text(AppText.t("date"))
                    Spacer()
                    Text(record.dateKey)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text(AppText.t("completed"))
                    Spacer()
                    Text("\(record.completedCount) / 3")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text(AppText.t("game_time"))
                    Spacer()
                    Text("\(record.gameTimeMinutes) min")
                        .foregroundStyle(.secondary)
                }
            }

            Section(AppText.t("tasks")) {
                detailTaskRow(title: AppText.t("math"), isCompleted: record.mathCompleted)
                detailTaskRow(title: AppText.t("english"), isCompleted: record.englishCompleted)
                detailTaskRow(title: AppText.t("reading"), isCompleted: record.readingCompleted)
            }
        }
        .navigationTitle(AppText.t("record_detail"))
    }

    private func detailTaskRow(title: String, isCompleted: Bool) -> some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isCompleted ? .green : .secondary)

            Text(title)

            Spacer()

            Text(isCompleted ? AppText.t("done") : AppText.t("not_done"))
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
    @AppStorage("englishNote") private var englishNote = "Use a learning app for English practice"
    @AppStorage("readingNote") private var readingNote = "Read a story or book"
    @AppStorage("webPairingCode") private var webPairingCode = ""
    @AppStorage("requiredLearningAppCount") private var requiredLearningAppCount = 2
    @AppStorage("movementStartHour") private var movementStartHour = 17
    @AppStorage("movementEndHour") private var movementEndHour = 19
    @AppStorage("movementTargetMinutes") private var movementTargetMinutes = 30
    @AppStorage("movementRewardMinutes") private var movementRewardMinutes = 15
    @AppStorage("movementActivityType") private var movementActivityType = "Workout"

    @State private var parentPINInput = ""
    @State private var newParentPIN = ""
    @State private var isParentUnlocked = false
    @State private var parentPINError = ""
    @State private var selectedTab = 0

    private let totalTaskCount = 3

    #if canImport(FamilyControls)
    @State private var learningActivitySelection = FamilyActivitySelection()
    @State private var entertainmentActivitySelection = FamilyActivitySelection()
    @State private var isLearningPickerPresented = false
    @State private var isEntertainmentPickerPresented = false
    #endif

    private var completedCount: Int {
        [mathCompleted, englishCompleted, readingCompleted].filter { $0 }.count
    }

    private var gameTimeMinutes: Int {
        (completedCount * gameMinutesPerTask) + movementRewardMinutesEarned
    }

    private var maxGameTimeMinutes: Int {
        (totalTaskCount * gameMinutesPerTask) + movementRewardMinutes
    }

    private var allTasksCompleted: Bool {
        completedCount >= requiredLearningAppCount
    }

    private var isInsideMovementWindow: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= movementStartHour && hour < movementEndHour
    }

    private var movementProgressMinutes: Int {
        guard isInsideMovementWindow else { return 0 }
        if movementActivityType == "Exercise Minutes" {
            return healthSyncManager.exerciseMinutes
        }
        return max(healthSyncManager.exerciseMinutes, healthSyncManager.latestWorkoutMinutes)
    }

    private var movementGoalCompleted: Bool {
        movementProgressMinutes >= movementTargetMinutes
    }

    private var movementRewardMinutesEarned: Int {
        movementGoalCompleted ? movementRewardMinutes : 0
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
        TabView(selection: $selectedTab) {
            NavigationStack {
                appBackground {
                    todayView
                }
                .navigationTitle(AppText.t("app_name"))
            }
            .tabItem {
                Label(AppText.t("tab_today"), systemImage: "house.fill")
            }
            .tag(0)

            NavigationStack {
                appBackground {
                    appRulesView
                }
                .navigationTitle("Apps")
            }
            .tabItem {
                Label(AppText.t("tab_apps"), systemImage: "app.badge.checkmark")
            }
            .tag(1)

            NavigationStack {
                appBackground {
                    movementView
                }
                .navigationTitle(AppText.t("tab_move"))
            }
            .tabItem {
                Label(AppText.t("tab_move"), systemImage: "figure.walk")
            }
            .tag(2)

            NavigationStack {
                appBackground {
                    recordsView
                }
                .navigationTitle(AppText.t("nav_records"))
            }
            .tabItem {
                Label(AppText.t("tab_records"), systemImage: "calendar")
            }
            .tag(3)

            NavigationStack {
                appBackground {
                    if isParentUnlocked {
                        parentView
                    } else {
                        parentLockView
                    }
                }
                .navigationTitle(AppText.t("tab_parent"))
            }
            .tabItem {
                Label(AppText.t("tab_parent"), systemImage: "person.2.fill")
            }
            .tag(4)
        }
        .onAppear {
            prepareToday()
            saveTodayRecord()
            screenTimeManager.refreshAuthorizationState()
        }
        .onChange(of: mathCompleted) { _, _ in updateTodayProgress() }
        .onChange(of: englishCompleted) { _, _ in updateTodayProgress() }
        .onChange(of: readingCompleted) { _, _ in updateTodayProgress() }
        .onChange(of: gameMinutesPerTask) { _, _ in updateTodayProgress() }
        #if canImport(FamilyControls)
        .familyActivityPicker(isPresented: $isLearningPickerPresented, selection: $learningActivitySelection)
        .familyActivityPicker(isPresented: $isEntertainmentPickerPresented, selection: $entertainmentActivitySelection)
        #endif
    }

    private var todayView: some View {
        VStack(alignment: .leading, spacing: 22) {
            headerView
            streakCard
            encouragementView
            gameSummaryView
            taskListView
            movementWindowSummaryCard
            progressView
            resetButton
        }
        .padding()
    }

    private var appRulesView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(AppText.t("learning_unlock"))
                    .font(.largeTitle)
                    .bold()

                Text(AppText.t("learning_unlock_desc"))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                StatCard(
                    title: AppText.t("required"),
                    value: "\(requiredLearningAppCount)",
                    subtitle: AppText.t("study_apps"),
                    color: .purple,
                    iconName: "checklist"
                )

                StatCard(
                    title: AppText.t("earned"),
                    value: "\(gameTimeMinutes)",
                    subtitle: AppText.t("minutes"),
                    color: .blue,
                    iconName: "gamecontroller.fill"
                )
            }

            appSelectionCard
            taskListView
            screenTimeControlCard
        }
        .padding()
    }

    private var appSelectionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "app.connected.to.app.below.fill")
                    .foregroundStyle(.purple)

                Text(AppText.t("app_groups"))
                    .font(.headline)
            }

            Text(AppText.t("app_groups_desc"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            #if canImport(FamilyControls)
            Button {
                isLearningPickerPresented = true
            } label: {
                Label(AppText.t("choose_learning_apps"), systemImage: "book.closed.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                isEntertainmentPickerPresented = true
            } label: {
                Label(AppText.t("choose_entertainment_apps"), systemImage: "gamecontroller.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            #else
            Text(AppText.t("picker_unavailable"))
                .font(.footnote)
                .foregroundStyle(.secondary)
            #endif
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var screenTimeControlCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lock.shield.fill")
                    .foregroundStyle(.blue)

                Text(AppText.t("screen_time_api"))
                    .font(.headline)
            }

            Text(AppText.t("authorization", screenTimeManager.authorizationState.localizedName))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                Task {
                    await screenTimeManager.requestAuthorization()
                    applyScreenTimeLimit()
                }
            } label: {
                Label(AppText.t("request_screen_time_permission"), systemImage: "hand.raised.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                applyScreenTimeLimit()
            } label: {
                Label(gameTimeMinutes > 0 ? AppText.t("apply_earned_unlock") : AppText.t("lock_entertainment_apps"), systemImage: gameTimeMinutes > 0 ? "lock.open.fill" : "lock.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                screenTimeManager.clearRestrictions()
            } label: {
                Label(AppText.t("clear_screen_time_restrictions"), systemImage: "xmark.shield")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Text(screenTimeManager.statusMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var movementView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(AppText.t("movement_check"))
                    .font(.largeTitle)
                    .bold()

                Text(AppText.t("movement_subtitle"))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                StatCard(
                    title: AppText.t("steps"),
                    value: "\(healthSyncManager.steps)",
                    subtitle: AppText.t("today"),
                    color: .green,
                    iconName: "figure.walk"
                )

                StatCard(
                    title: AppText.t("exercise"),
                    value: "\(healthSyncManager.exerciseMinutes)",
                    subtitle: AppText.t("min_today"),
                    color: .orange,
                    iconName: "figure.run"
                )
            }

            HStack(spacing: 12) {
                StatCard(
                    title: AppText.t("active_energy"),
                    value: "\(healthSyncManager.activeEnergyKcal)",
                    subtitle: "kcal",
                    color: .red,
                    iconName: "flame.fill"
                )

                StatCard(
                    title: AppText.t("latest_workout"),
                    value: "\(healthSyncManager.latestWorkoutMinutes)",
                    subtitle: healthSyncManager.latestWorkoutName,
                    color: .blue,
                    iconName: "figure.cooldown"
                )
            }

            movementWindowSummaryCard
            movementSyncCard
        }
        .padding()
    }

    private var movementWindowSummaryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: movementGoalCompleted ? "checkmark.seal.fill" : "clock.badge.exclamationmark")
                    .foregroundStyle(movementGoalCompleted ? .green : .orange)

                Text(AppText.t("move_unlock_rule"))
                    .font(.headline)
            }

            Text(AppText.t("movement_window_line", movementStartHour, movementEndHour, movementTargetMinutes, movementActivityType))
                .font(.subheadline)

            Text(AppText.t("movement_progress_line", movementProgressMinutes, movementTargetMinutes, movementRewardMinutesEarned))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var movementSyncCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .foregroundStyle(.red)

                Text(AppText.t("health_data_sync"))
                    .font(.headline)
            }

            Text(AppText.t("health_sync_desc"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                Task {
                    await healthSyncManager.requestAuthorizationAndSync()
                }
            } label: {
                Label(AppText.t("request_health_permission"), systemImage: "heart.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(healthSyncManager.isSyncing)

            Button {
                Task {
                    await healthSyncManager.syncTodayHealthData()
                }
            } label: {
                Label(healthSyncManager.isSyncing ? AppText.t("syncing") : AppText.t("sync_health_data"), systemImage: "arrow.clockwise")
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
                    title: AppText.t("current_streak"),
                    value: "\(currentStreak)",
                    subtitle: AppText.t("days"),
                    color: .orange,
                    iconName: "flame.fill"
                )

                StatCard(
                    title: AppText.t("last_7_days"),
                    value: "\(lastSevenCompletedDays)",
                    subtitle: AppText.t("perfect_days"),
                    color: .green,
                    iconName: "checkmark.circle.fill"
                )
            }

            Text(AppText.t("history"))
                .font(.headline)

            if dailyRecords.isEmpty {
                emptyRecordsView
            } else {
                VStack(spacing: 10) {
                    ForEach(dailyRecords, id: \.dateKey) { record in
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
                Text(AppText.t("parent_dashboard"))
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Color(red: 0.10, green: 0.14, blue: 0.22))

                Spacer()

                Button(AppText.t("lock")) {
                    isParentUnlocked = false
                    parentPINInput = ""
                    parentPINError = ""
                }
                .buttonStyle(.bordered)
            }

            Text(AppText.t("parent_subtitle"))
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                StatCard(
                    title: AppText.t("streak"),
                    value: "\(currentStreak)",
                    subtitle: AppText.t("days"),
                    color: .orange,
                    iconName: "flame.fill"
                )

                StatCard(
                    title: AppText.t("game_time"),
                    value: "\(lastSevenGameMinutes)",
                    subtitle: AppText.t("min_in_7_days"),
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
            parentRewardSettingsCard
            parentMovementSettingsCard
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

            Text(AppText.t("parent_area_locked"))
                .font(.largeTitle)
                .bold()

            Text(AppText.t("parent_pin_prompt"))
                .foregroundStyle(.secondary)

            SecureField(AppText.t("parent_pin"), text: $parentPINInput)
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
                Label(AppText.t("unlock_parent_area"), systemImage: "lock.open.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Spacer(minLength: 20)
        }
        .padding()
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(AppText.t("today_learning"))
                .font(.largeTitle)
                .bold()

            Text(AppText.t("today_message", childName))
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
                Text(AppText.t("continuous_learning"))
                    .font(.headline)

                Text(AppText.t("day_streak", currentStreak))
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
            Text(allTasksCompleted ? AppText.t("game_time_unlocked", maxGameTimeMinutes) : AppText.t("game_time_locked"))
                .font(.title2)
                .bold()
                .foregroundStyle(allTasksCompleted ? .green : .red)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(gameTimeMinutes)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))

                Text(AppText.t("min_earned"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            Text(AppText.t("completed_count", completedCount, totalTaskCount))
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
                title: AppText.t("math"),
                minutes: mathMinutes,
                note: mathNote,
                color: .blue,
                isCompleted: $mathCompleted
            )

            LearningTaskRow(
                title: AppText.t("english"),
                minutes: englishMinutes,
                note: englishNote,
                color: .purple,
                isCompleted: $englishCompleted
            )

            LearningTaskRow(
                title: AppText.t("reading"),
                minutes: readingMinutes,
                note: readingNote,
                color: .orange,
                isCompleted: $readingCompleted
            )
        }
    }

    private var progressView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppText.t("daily_progress"))
                .font(.headline)

            ProgressView(value: Double(completedCount), total: Double(requiredLearningAppCount))
                .tint(allTasksCompleted ? .green : .blue)

            Text(AppText.t("progress_rule", gameMinutesPerTask))
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

                Text(AppText.t("screen_time_api"))
                    .font(.headline)
            }

            Text(AppText.t("authorization", screenTimeManager.authorizationState.localizedName))
                .font(.subheadline)
                .foregroundStyle(screenTimeManager.authorizationState.color)

            Text(AppText.t("current_earned_limit", gameTimeMinutes))
                .font(.headline)

            Text(screenTimeManager.statusMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button {
                Task {
                    await screenTimeManager.requestAuthorization()
                }
            } label: {
                Label(AppText.t("request_screen_time_permission"), systemImage: "person.badge.key.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            #if canImport(FamilyControls)
            Button {
                screenTimeManager.statusMessage = AppText.t("opening_picker")
                isEntertainmentPickerPresented = true
            } label: {
                Label(AppText.t("choose_entertainment_apps"), systemImage: "gamecontroller.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            #else
            Text(AppText.t("picker_unavailable"))
                .font(.footnote)
                .foregroundStyle(.secondary)
            #endif

            Button {
                applyScreenTimeLimit()
            } label: {
                Label(AppText.t("apply_earned_limit"), systemImage: "checkmark.shield.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button(role: .destructive) {
                screenTimeManager.clearRestrictions()
            } label: {
                Label(AppText.t("clear_screen_time_restrictions"), systemImage: "xmark.shield.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(Color(red: 0.10, green: 0.14, blue: 0.22))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08), radius: 14, y: 7)
    }

    private var screenTimeSetupCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "iphone.and.arrow.forward")
                    .foregroundStyle(.blue)

                Text(AppText.t("setup_screen_time"))
                    .font(.headline)
            }

            Text(AppText.t("setup_screen_time_subtitle"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ScreenTimeSetupStep(
                number: 1,
                title: AppText.t("request_permission"),
                description: AppText.t("request_permission_desc")
            )

            ScreenTimeSetupStep(
                number: 2,
                title: AppText.t("select_apps"),
                description: AppText.t("select_apps_desc")
            )

            ScreenTimeSetupStep(
                number: 3,
                title: AppText.t("apply_limit"),
                description: AppText.t("apply_limit_desc")
            )

            ScreenTimeSetupStep(
                number: 4,
                title: AppText.t("monitor_usage"),
                description: AppText.t("monitor_usage_desc")
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

                Text(AppText.t("movement_results"))
                    .font(.headline)
            }

            Text(AppText.t("movement_today", healthSyncManager.steps, healthSyncManager.exerciseMinutes, healthSyncManager.activeEnergyKcal))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(AppText.t("latest_workout_line", healthSyncManager.latestWorkoutName, healthSyncManager.latestWorkoutMinutes))
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button {
                Task {
                    await healthSyncManager.syncTodayHealthData()
                }
            } label: {
                Label(AppText.t("refresh_movement_data"), systemImage: "arrow.clockwise")
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

                Text(AppText.t("web_parent_sync"))
                    .font(.headline)
            }

            Text(AppText.t("web_parent_sync_desc"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField(AppText.t("pairing_code"), text: $webPairingCode)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            Button {
                syncSettingsFromWeb()
            } label: {
                Label(AppText.t("sync_remote_settings"), systemImage: "arrow.down.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(cloudSyncManager.isUploading)

            Button {
                uploadTodayRecordToWeb()
            } label: {
                Label(cloudSyncManager.isUploading ? AppText.t("uploading") : AppText.t("upload_today_record"), systemImage: "arrow.up.doc.fill")
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
        let snapshot = (
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

        Task {
            await cloudSyncManager.uploadTodayRecord(
                pairingCode: snapshot.pairingCode,
                reportDate: snapshot.reportDate,
                mathCompleted: snapshot.mathCompleted,
                englishCompleted: snapshot.englishCompleted,
                readingCompleted: snapshot.readingCompleted,
                completedCount: snapshot.completedCount,
                gameTimeMinutes: snapshot.gameTimeMinutes,
                mathMinutes: snapshot.mathMinutes,
                englishMinutes: snapshot.englishMinutes,
                readingMinutes: snapshot.readingMinutes
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
            updateTodayProgress()
        }
    }

    private var childProfileCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundStyle(.green)

                Text(AppText.t("child_profile"))
                    .font(.headline)
            }

            Text(AppText.t("child_profile_desc"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField(AppText.t("child_name"), text: $childName)
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

                Text(AppText.t("learning_app_goals"))
                    .font(.headline)
            }

            Text(AppText.t("learning_app_goals_desc"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper(AppText.t("required_study_apps", requiredLearningAppCount), value: $requiredLearningAppCount, in: 1...3, step: 1)
            Stepper(AppText.t("math_app_minutes", mathMinutes), value: $mathMinutes, in: 5...180, step: 5)
            Stepper(AppText.t("english_app_minutes", englishMinutes), value: $englishMinutes, in: 5...180, step: 5)
            Stepper(AppText.t("reading_app_minutes", readingMinutes), value: $readingMinutes, in: 5...180, step: 5)

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

    private var parentRewardSettingsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "gamecontroller.fill")
                    .foregroundStyle(.blue)

                Text(AppText.t("reward_rule"))
                    .font(.headline)
            }

            Text(AppText.t("reward_rule_desc"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper(
                AppText.t("reward_per_app", gameMinutesPerTask),
                value: $gameMinutesPerTask,
                in: 5...60,
                step: 5
            )

            Text(AppText.t("max_reward_line", maxGameTimeMinutes))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var parentMovementSettingsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "figure.run.circle.fill")
                    .foregroundStyle(.orange)

                Text(AppText.t("movement_window"))
                    .font(.headline)
            }

            Text(AppText.t("movement_window_desc"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper(AppText.t("start_hour", movementStartHour), value: $movementStartHour, in: 0...23, step: 1)
            Stepper(AppText.t("end_hour", movementEndHour), value: $movementEndHour, in: 1...24, step: 1)
            Stepper(AppText.t("goal_minutes", movementTargetMinutes), value: $movementTargetMinutes, in: 5...180, step: 5)
            Stepper(AppText.t("reward_minutes", movementRewardMinutes), value: $movementRewardMinutes, in: 0...60, step: 5)

            Picker(AppText.t("activity"), selection: $movementActivityType) {
                Text(AppText.t("workout")).tag("Workout")
                Text(AppText.t("exercise_minutes")).tag("Exercise Minutes")
            }
            .pickerStyle(.segmented)
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

                Text(AppText.t("parent_pin"))
                    .font(.headline)
            }

            Text(AppText.t("parent_pin_desc"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            SecureField(AppText.t("new_parent_pin"), text: $newParentPIN)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Button(AppText.t("save_new_pin")) {
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
            Text(AppText.t("parent_notes"))
                .font(.headline)

            Text(AppText.t("parent_notes_desc"))
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

            Text(AppText.t("no_records"))
                .font(.headline)

            Text(AppText.t("no_records_desc"))
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
            Label(AppText.t("reset_today"), systemImage: "arrow.counterclockwise")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.blue)
    }

    private func appBackground<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.88, green: 0.95, blue: 1.0),
                    Color(red: 0.91, green: 0.98, blue: 0.93),
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
        .preferredColorScheme(.light)
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
        applyScreenTimeLimit()

        if !webPairingCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            uploadTodayRecordToWeb()
        }
    }

    private func applyScreenTimeLimit() {
        #if canImport(FamilyControls) && canImport(ManagedSettings)
        screenTimeManager.applyGameTimeLimit(minutes: gameTimeMinutes, selection: entertainmentActivitySelection)
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
            parentPINError = AppText.t("incorrect_pin")
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
        guard let data = dailyRecordsData.data(using: .utf8) else {
            return []
        }

        do {
            let records: [DailyRecord] = try JSONDecoder().decode([DailyRecord].self, from: data)
            return records.sorted { leftRecord, rightRecord in
                leftRecord.dateKey > rightRecord.dateKey
            }
        } catch {
            return []
        }
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
