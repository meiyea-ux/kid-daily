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
        let preferred = Locale.preferredLanguages.first?.lowercased() ?? "zh-hans"
        if preferred.hasPrefix("zh-hans") || preferred.hasPrefix("zh-cn") || preferred.hasPrefix("zh-sg") { return "zh-Hans" }
        if preferred.hasPrefix("zh-hant") || preferred.hasPrefix("zh-tw") || preferred.hasPrefix("zh-hk") || preferred.hasPrefix("zh-mo") { return "zh-Hant" }
        if preferred.hasPrefix("ja") { return "ja" }
        if preferred.hasPrefix("ko") { return "ko" }
        if preferred.hasPrefix("es") { return "es" }
        return "zh-Hans"
    }

    private static let english: [String: String] = [
        "app_name": "BetterDay",
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
            "child_profile": "孩子资料", "child_name": "孩子姓名", "parent_notes": "家长备注", "incorrect_pin": "PIN 不正确，请重试。",
            "app_name": "BetterDay", "nav_records": "每日记录", "parent_subtitle": "设置学习应用目标、奖励分钟数、娱乐锁定和运动时段。",
            "screen_time_api": "屏幕使用时间 API", "authorization": "授权：%@", "current_earned_limit": "当前已获得上限：%d 分钟",
            "request_screen_time_permission": "请求屏幕使用时间权限", "select_apps_categories": "选择应用和类别", "apply_earned_limit": "应用已获得上限", "clear_screen_time_restrictions": "清除屏幕使用限制",
            "setup_screen_time": "设置屏幕使用时间", "setup_screen_time_subtitle": "Apple 屏幕使用时间集成准备清单。", "request_permission": "请求权限", "request_permission_desc": "在这台 iPhone 上请求屏幕使用时间权限。",
            "select_apps": "选择应用", "select_apps_desc": "选择由 BetterDay 管理的游戏或应用。", "apply_limit": "应用限制", "apply_limit_desc": "用已获得娱乐时间应用每日屏幕使用限制。", "monitor_usage": "监测使用",
            "monitor_usage_desc": "读取活动报告并更新家长控制台。", "continuous_learning": "连续学习", "day_streak": "%d 天连续", "game_time_unlocked": "娱乐已解锁：%d 分钟", "game_time_locked": "娱乐时间待解锁",
            "min_earned": "分钟已获得", "completed_count": "已完成：%d / %d", "progress_rule": "每完成一个学习应用目标，可获得 %d 分钟娱乐时间。", "date": "日期", "completed": "已完成",
            "record_detail": "记录详情", "done": "完成", "not_done": "未完成", "parent_pin_desc": "修改用于打开家长页的 PIN。", "history": "历史", "no_records": "还没有每日记录。",
            "no_records_desc": "完成或重置今天的任务后会生成记录。", "reset_today": "重置今天", "summary": "汇总", "tasks": "任务", "steps": "步数", "today": "今天",
            "exercise": "运动", "min_today": "今日分钟", "active_energy": "活动能量", "latest_workout": "最近运动", "health_sync_desc": "读取今天的步数、Apple 运动分钟、活动能量和最近运动。Apple Watch 运动同步到 iPhone 健康 App 后会显示在这里。",
            "current_streak": "当前连续", "last_7_days": "最近 7 天", "perfect_days": "完美天数", "movement_results": "运动结果", "movement_today": "今天：%d 步，%d 分钟运动，%d 千卡。",
            "latest_workout_line": "最近运动：%@，%d 分钟。", "refresh_movement_data": "刷新运动数据", "web_parent_sync": "家长网页同步", "web_parent_sync_desc": "输入家长网页控制台生成的配对码。今天的学习和娱乐时间会上传，方便远程查看。",
            "pairing_code": "配对码", "sync_remote_settings": "同步远程设置", "uploading": "上传中...", "upload_today_record": "上传今日记录", "auth_failed": "授权失败：%@", "opening_picker": "正在打开应用和类别选择器...",
            "picker_unavailable": "当前构建不可用 FamilyActivityPicker。", "status_not_requested": "尚未请求屏幕使用时间权限。", "status_denied": "屏幕使用时间权限已被拒绝。", "status_approved": "屏幕使用时间权限已通过。",
            "status_unknown": "未知的屏幕使用时间授权状态。", "requesting_screen_time": "正在请求屏幕使用时间权限...", "approve_before_limit": "应用限制前，请先批准屏幕使用时间权限。", "select_before_limit": "应用屏幕使用限制前，请先选择应用或类别。",
            "limit_applied": "已对所选应用应用屏幕使用限制。已获得上限：%d 分钟。", "limit_zero": "还没有获得娱乐时间。所选应用和类别已被限制。", "restrictions_cleared": "屏幕使用限制已清除。", "unavailable_build": "当前构建不可用 FamilyControls。",
            "entertainment_unlocked_status": "娱乐应用已按 %d 分钟奖励时间解锁。", "entertainment_locked_status": "娱乐应用会保持锁定，直到学习或运动目标完成。", "child_profile_desc": "设置今日页面显示的孩子姓名。",
            "learning_app_goals_desc": "调整每个每日学习应用的预期使用时长。", "required_study_apps": "必需学习应用：%d", "math_app_minutes": "数学应用：%d 分钟", "english_app_minutes": "英语应用：%d 分钟", "reading_app_minutes": "阅读应用：%d 分钟",
            "reward_rule_desc": "设置每完成一个学习应用可获得多少娱乐时间。", "max_reward_line": "完成所有学习目标后，运动奖励前最多可解锁 %d 分钟。", "reward_per_app": "奖励：每完成一个学习应用 %d 分钟",
            "start_hour": "开始：%d:00", "end_hour": "结束：%d:00", "goal_minutes": "目标：%d 分钟", "reward_minutes": "奖励：%d 分钟", "activity": "活动", "workout": "运动", "exercise_minutes": "运动分钟", "parent_notes_desc": "下一步构建：添加 DeviceActivityMonitor 扩展，让学习应用分钟数自动读取，而不是手动勾选。", "new_parent_pin": "新的 4 位 PIN", "save_new_pin": "保存新 PIN"
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
        case .approved, .approvedWithDataAccess:
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
    @Published var statusMessage = "健康同步已就绪，可读取 iPhone 和 Apple Watch 数据。"
    @Published var isSyncing = false
    @Published var steps = 0
    @Published var exerciseMinutes = 0
    @Published var activeEnergyKcal = 0
    @Published var latestWorkoutName = "暂无运动记录"
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
            statusMessage = "这台设备无法读取健康数据，请在真实 iPhone 上测试。"
            return
        }

        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime),
              let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            statusMessage = "当前系统无法读取 HealthKit 运动数据类型。"
            return
        }

        let readTypes: Set<HKObjectType> = [
            stepType,
            exerciseType,
            energyType,
            HKObjectType.workoutType()
        ]

        do {
            statusMessage = "正在请求健康数据权限..."
            try await requestHealthAuthorization(readTypes: readTypes)
            await syncTodayHealthData()
        } catch {
            statusMessage = "健康权限请求失败：\(error.localizedDescription)"
        }
        #else
        statusMessage = "当前构建不可用 HealthKit。"
        #endif
    }

    func syncTodayHealthData() async {
        #if canImport(HealthKit)
        guard isHealthDataAvailable else {
            statusMessage = "这台设备无法读取健康数据，请在真实 iPhone 上测试。"
            return
        }

        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime),
              let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            statusMessage = "当前系统无法读取 HealthKit 运动数据类型。"
            return
        }

        isSyncing = true
        statusMessage = "正在同步今天的健康数据..."

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
        statusMessage = "已同步 iPhone / Apple Watch 健康数据。"
        #else
        statusMessage = "当前构建不可用 HealthKit。"
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
                    continuation.resume(throwing: NSError(domain: "KidDailyHealth", code: 1, userInfo: [NSLocalizedDescriptionKey: "未获得健康数据权限。"]))
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
                    continuation.resume(returning: ("暂无运动记录", 0))
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
            return "跑步"
        case .walking:
            return "步行"
        case .cycling:
            return "骑行"
        case .swimming:
            return "游泳"
        case .traditionalStrengthTraining:
            return "力量训练"
        case .yoga:
            return "瑜伽"
        case .dance:
            return "跳舞"
        default:
            return "运动"
        }
    }
}
#endif

@MainActor
final class CloudSyncManager: ObservableObject {
    @Published var statusMessage = "请输入家长网页端生成的配对码。"
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
            statusMessage = "同步设置前，请先输入配对码。"
            return nil
        }

        guard let url = URL(string: "\(supabaseUrl)/rest/v1/rpc/get_kiddaily_settings_by_pairing_code") else {
            statusMessage = "Supabase 地址无效。"
            return nil
        }

        do {
            isUploading = true
            statusMessage = "正在从家长网页端同步设置..."

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(supabasePublishableKey, forHTTPHeaderField: "apikey")
            request.setValue("Bearer \(supabasePublishableKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(["p_pairing_code": trimmedCode])

            let (data, response) = try await URLSession.shared.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            guard (200...299).contains(statusCode) else {
                statusMessage = "设置同步失败，HTTP \(statusCode)。"
                isUploading = false
                return nil
            }

            let settings = try JSONDecoder().decode([RemoteSettings].self, from: data)
            isUploading = false

            guard let firstSettings = settings.first else {
                statusMessage = "没有找到这个配对码对应的远程设置。"
                return nil
            }

            statusMessage = "远程设置已同步。"
            return firstSettings
        } catch {
            isUploading = false
            statusMessage = "设置同步失败：\(error.localizedDescription)"
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
            statusMessage = "上传前请先输入配对码。"
            return
        }

        guard let url = URL(string: "\(supabaseUrl)/rest/v1/rpc/upload_kiddaily_record_by_pairing_code") else {
            statusMessage = "Supabase 地址无效。"
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
            statusMessage = "正在上传今天的记录..."

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(supabasePublishableKey, forHTTPHeaderField: "apikey")
            request.setValue("Bearer \(supabasePublishableKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(payload)

            let (_, response) = try await URLSession.shared.data(for: request)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            if (200...299).contains(statusCode) {
                statusMessage = "已上传到家长网页端。"
            } else {
                statusMessage = "上传失败，HTTP \(statusCode)。请检查配对码和 Supabase SQL。"
            }
        } catch {
            statusMessage = "上传失败：\(error.localizedDescription)"
        }

        isUploading = false
    }
}

struct LearningTaskRow: View {
    let title: String
    let minutes: Int
    let note: String
    let rewardMinutes: Int
    let color: Color
    @Binding var isCompleted: Bool

    var body: some View {
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

                Text("\(minutes) 分钟目标 · 完成奖励 \(rewardMinutes) 分钟")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 8)

            Button {
                isCompleted.toggle()
            } label: {
                Label(isCompleted ? "撤销" : "完成", systemImage: isCompleted ? "arrow.uturn.backward.circle.fill" : "checkmark.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
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
            return "准备开始了吗？"
        case 1:
            return "开头很棒！"
        case 2:
            return "马上完成了！"
        default:
            return "做得真好！"
        }
    }

    private var message: String {
        switch completedCount {
        case 0:
            return "先完成第一个学习任务，就能获得娱乐时间。"
        case 1:
            return "你已经获得 \(gameTimeMinutes) 分钟，继续加油。"
        case 2:
            return "再完成一个任务，就能解锁完整奖励。"
        default:
            return "今天的任务都完成了，已解锁 \(maxGameTimeMinutes) 分钟。"
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

struct MinuteWheelRow: View {
    let title: String
    let subtitle: String
    @Binding var minutes: Int
    var range: ClosedRange<Int> = 0...240
    var step: Int = 5
    var iconName: String = "timer"
    var tint: Color = .blue
    @State private var isPresented = false
    @State private var draftMinutes = 0

    private var values: [Int] {
        Array(stride(from: range.lowerBound, through: range.upperBound, by: step))
    }

    var body: some View {
        Button {
            draftMinutes = minutes
            isPresented = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundStyle(tint)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Text("\(minutes) 分钟")
                    .font(.headline)
                    .foregroundStyle(tint)

                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                Picker(title, selection: $draftMinutes) {
                    ForEach(values, id: \.self) { value in
                        Text("\(value) 分钟").tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("取消") {
                            isPresented = false
                        }
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button("完成") {
                            minutes = draftMinutes
                            isPresented = false
                        }
                    }
                }
            }
            .presentationDetents([.height(320)])
        }
    }
}

struct TimeWindowSummaryRow: View {
    let appName: String
    let category: String
    let weekdayWindow: String
    let weekendWindow: String
    let limitText: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(appName)
                        .font(.headline)

                    Text(category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "lock.clock.fill")
                    .foregroundStyle(color)
            }

            Text("工作日 \(weekdayWindow)")
                .font(.subheadline)

            Text("周末 \(weekendWindow)")
                .font(.subheadline)

            Text(limitText)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct RuleSummaryPill: View {
    let title: String
    let value: String
    let iconName: String
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 14))
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

            Text("\(record.gameTimeMinutes) 分钟")
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
                    Text("\(record.gameTimeMinutes) 分钟")
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
    @AppStorage("taskDCompleted") private var taskDCompleted = false
    @AppStorage("taskECompleted") private var taskECompleted = false
    @AppStorage("taskFCompleted") private var taskFCompleted = false
    @AppStorage("taskGCompleted") private var taskGCompleted = false
    @AppStorage("taskHCompleted") private var taskHCompleted = false
    @AppStorage("lastSavedDateKey") private var lastSavedDateKey = ""
    @AppStorage("dailyRecordsData") private var dailyRecordsData = ""
    @AppStorage("parentPIN") private var parentPIN = "1234"
    @AppStorage("mathMinutes") private var mathMinutes = 20
    @AppStorage("englishMinutes") private var englishMinutes = 20
    @AppStorage("readingMinutes") private var readingMinutes = 15
    @AppStorage("taskDMinutes") private var taskDMinutes = 20
    @AppStorage("taskEMinutes") private var taskEMinutes = 20
    @AppStorage("taskFMinutes") private var taskFMinutes = 20
    @AppStorage("taskGMinutes") private var taskGMinutes = 20
    @AppStorage("taskHMinutes") private var taskHMinutes = 20
    @AppStorage("gameMinutesPerTask") private var gameMinutesPerTask = 10
    @AppStorage("childName") private var childName = "孩子"
    @AppStorage("mathNote") private var mathNote = "练习数字和计算能力"
    @AppStorage("englishNote") private var englishNote = "使用英语学习应用完成练习"
    @AppStorage("readingNote") private var readingNote = "阅读一个故事或一本书"
    @AppStorage("taskDNote") private var taskDNote = "使用应用 D 完成家长设定任务"
    @AppStorage("taskENote") private var taskENote = "使用应用 E 完成家长设定任务"
    @AppStorage("taskFNote") private var taskFNote = "使用应用 F 完成家长设定任务"
    @AppStorage("taskGNote") private var taskGNote = "使用应用 G 完成家长设定任务"
    @AppStorage("taskHNote") private var taskHNote = "使用应用 H 完成家长设定任务"
    @AppStorage("webPairingCode") private var webPairingCode = ""
    @AppStorage("requiredLearningAppCount") private var requiredLearningAppCount = 2
    @AppStorage("movementStartHour") private var movementStartHour = 17
    @AppStorage("movementEndHour") private var movementEndHour = 19
    @AppStorage("movementTargetMinutes") private var movementTargetMinutes = 30
    @AppStorage("movementRewardMinutes") private var movementRewardMinutes = 15
    @AppStorage("movementActivityType") private var movementActivityType = "Workout"
    @AppStorage("entertainmentCarryoverMinutes") private var entertainmentCarryoverMinutes = 0
    @AppStorage("entertainmentBalanceCap") private var entertainmentBalanceCap = 120
    @AppStorage("dailyEarnCapMinutes") private var dailyEarnCapMinutes = 60
    @AppStorage("dailyUseCapMinutes") private var dailyUseCapMinutes = 45
    @AppStorage("allowEntertainmentCarryover") private var allowEntertainmentCarryover = true
    @AppStorage("weekdayVideoLimitMinutes") private var weekdayVideoLimitMinutes = 30
    @AppStorage("weekendVideoLimitMinutes") private var weekendVideoLimitMinutes = 60
    @AppStorage("weekdayGameLimitMinutes") private var weekdayGameLimitMinutes = 20
    @AppStorage("weekendGameCombinedLimitMinutes") private var weekendGameCombinedLimitMinutes = 90
    @AppStorage("coreLearningAppSlots") private var coreLearningAppSlots = 8
    @AppStorage("coreEntertainmentAppSlots") private var coreEntertainmentAppSlots = 8
    @AppStorage("movementExemptionRequested") private var movementExemptionRequested = false
    @AppStorage("movementExemptionApproved") private var movementExemptionApproved = false
    @AppStorage("movementExemptionReason") private var movementExemptionReason = "天气"
    @AppStorage("movementMakeupMinutes") private var movementMakeupMinutes = 0
    @AppStorage("parentBindingCode") private var parentBindingCode = "BD-482913"

    @State private var parentPINInput = ""
    @State private var newParentPIN = ""
    @State private var isParentUnlocked = false
    @State private var parentPINError = ""
    @State private var selectedTab = 0

    private let maximumTaskCount = 8

    #if canImport(FamilyControls)
    @State private var learningActivitySelection = FamilyActivitySelection()
    @State private var entertainmentActivitySelection = FamilyActivitySelection()
    @State private var isLearningPickerPresented = false
    @State private var isEntertainmentPickerPresented = false
    #endif

    private var completedCount: Int {
        Array([
            mathCompleted,
            englishCompleted,
            readingCompleted,
            taskDCompleted,
            taskECompleted,
            taskFCompleted,
            taskGCompleted,
            taskHCompleted
        ].prefix(enabledTaskCount)).filter { $0 }.count
    }

    private var enabledTaskCount: Int {
        min(max(requiredLearningAppCount, 1), maximumTaskCount)
    }

    private var gameTimeMinutes: Int {
        min((completedCount * gameMinutesPerTask) + movementRewardMinutesEarned, dailyEarnCapMinutes)
    }

    private var maxGameTimeMinutes: Int {
        min((enabledTaskCount * gameMinutesPerTask) + movementRewardMinutes, dailyEarnCapMinutes)
    }

    private var entertainmentBalanceMinutes: Int {
        min((allowEntertainmentCarryover ? entertainmentCarryoverMinutes : 0) + gameTimeMinutes, entertainmentBalanceCap)
    }

    private var movementIsExcusedToday: Bool {
        movementExemptionRequested && movementExemptionApproved
    }

    private var allTasksCompleted: Bool {
        completedCount >= enabledTaskCount
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

    private var localizedMovementActivityType: String {
        movementActivityType == "Exercise Minutes" ? AppText.t("exercise_minutes") : AppText.t("workout")
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
                    if isParentUnlocked {
                        parentView
                    } else {
                        parentLockView
                    }
                }
                .navigationTitle("规则设定")
            }
            .tabItem {
                Label("规则设定", systemImage: "slider.horizontal.3")
            }
            .tag(1)

            NavigationStack {
                appBackground {
                    appRulesView
                }
                .navigationTitle("应用管理")
            }
            .tabItem {
                Label("应用管理", systemImage: "app.badge.checkmark")
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
                    accountView
                }
                .navigationTitle("我的")
            }
            .tabItem {
                Label("我的", systemImage: "person.crop.circle")
            }
            .tag(4)
        }
        .onAppear {
            normalizeStoredChineseText()
            prepareToday()
            saveTodayRecord()
            screenTimeManager.refreshAuthorizationState()
        }
        .onChange(of: mathCompleted) { _ in updateTodayProgress() }
        .onChange(of: englishCompleted) { _ in updateTodayProgress() }
        .onChange(of: readingCompleted) { _ in updateTodayProgress() }
        .onChange(of: taskDCompleted) { _ in updateTodayProgress() }
        .onChange(of: taskECompleted) { _ in updateTodayProgress() }
        .onChange(of: taskFCompleted) { _ in updateTodayProgress() }
        .onChange(of: taskGCompleted) { _ in updateTodayProgress() }
        .onChange(of: taskHCompleted) { _ in updateTodayProgress() }
        .onChange(of: gameMinutesPerTask) { _ in updateTodayProgress() }
        #if canImport(FamilyControls)
        .familyActivityPicker(isPresented: $isLearningPickerPresented, selection: $learningActivitySelection)
        .familyActivityPicker(isPresented: $isEntertainmentPickerPresented, selection: $entertainmentActivitySelection)
        #endif
    }

    private var todayView: some View {
        VStack(alignment: .leading, spacing: 22) {
            headerView
            todayRulesShortcutCard
            streakCard
            encouragementView
            gameSummaryView
            taskListView
            movementWindowSummaryCard
            movementExemptionCard
            progressView
            resetButton
        }
        .padding()
    }

    private var appRulesView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("应用管理")
                    .font(.largeTitle)
                    .bold()

                Text("选择核心管控 APP。学习和娱乐的详细规则放在“规则设定”里统一管理。")
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                StatCard(
                    title: "学习核心",
                    value: "\(coreLearningAppSlots)",
                    subtitle: "个 APP",
                    color: .purple,
                    iconName: "checklist"
                )

                StatCard(
                    title: "娱乐核心",
                    value: "\(coreEntertainmentAppSlots)",
                    subtitle: "个 APP",
                    color: .blue,
                    iconName: "gamecontroller.fill"
                )
            }

            appSelectionCard
            coreAppPolicyCard
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

            Text("建议先只选择最需要管控的核心 APP，例如短视频、游戏、直播。其他 APP 后续进入全局统计，不一定强制锁定。")
                .font(.footnote)
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
                Image(systemName: movementGoalCompleted || movementIsExcusedToday ? "checkmark.seal.fill" : "clock.badge.exclamationmark")
                    .foregroundStyle(movementGoalCompleted || movementIsExcusedToday ? .green : .orange)

                Text("每日运动任务")
                    .font(.headline)
            }

            Text(AppText.t("movement_window_line", movementStartHour, movementEndHour, movementTargetMinutes, localizedMovementActivityType))
                .font(.subheadline)

            Text(movementIsExcusedToday ? "今日已豁免：\(movementExemptionReason)。不奖励娱乐时间，但不破坏连续记录。" : AppText.t("movement_progress_line", movementProgressMinutes, movementTargetMinutes, movementRewardMinutesEarned))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                Task {
                    await healthSyncManager.requestAuthorizationAndSync()
                }
            } label: {
                Label(healthSyncManager.isSyncing ? AppText.t("syncing") : AppText.t("sync_health_data"), systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(healthSyncManager.isSyncing)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var movementExemptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.run.square.stack.fill")
                    .foregroundStyle(.green)

                Text("运动豁免与补做")
                    .font(.headline)
            }

            Text(movementExemptionRequested ? (movementExemptionApproved ? "家长已批准今日运动豁免。" : "豁免申请已提交，等待家长批准。") : "遇到天气、疾病、旅行等特殊情况，可以申请豁免。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if movementMakeupMinutes > 0 {
                Text("待补做运动：\(movementMakeupMinutes) 分钟")
                    .font(.headline)
                    .foregroundStyle(.orange)
            }

            HStack {
                Button {
                    movementExemptionRequested = true
                    movementExemptionApproved = false
                    movementExemptionReason = "天气"
                } label: {
                    Label("申请豁免", systemImage: "paperplane.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    movementExemptionRequested = false
                    movementExemptionApproved = false
                } label: {
                    Label("撤回", systemImage: "arrow.uturn.backward")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
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

    private var accountView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("我的")
                    .font(.largeTitle)
                    .bold()

                Text("管理身份、绑定家长端和孩子端。")
                    .foregroundStyle(.secondary)
            }

            childProfileCard
            bindingCard
            accountModeCard
            cloudSyncCard
        }
        .padding()
    }

    private var bindingCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "qrcode.viewfinder")
                    .foregroundStyle(.blue)

                Text("家长端 / 孩子端绑定")
                    .font(.headline)
            }

            Text("家长可以扫码或输入绑定码，远程制定规则、查看今日状态并审批豁免。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("绑定码")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(parentBindingCode)
                        .font(.title2)
                        .bold()
                }

                Spacer()

                Image(systemName: "qrcode")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.white.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: 14))

            Button("刷新绑定码") {
                parentBindingCode = "BD-\(Int.random(in: 100000...999999))"
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var accountModeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.2.badge.gearshape.fill")
                    .foregroundStyle(.purple)

                Text("使用模式")
                    .font(.headline)
            }

            Text("当前原型同时支持家庭儿童、学生自律和成人自律的产品逻辑。儿童模式需要家长审批；成人模式可自我豁免并保留记录。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var parentView: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("规则设定")
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

            Text("制定每周学习、运动和娱乐使用规则。规则先在本机生效，后续可同步到家长端与孩子端。")
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                StatCard(
                    title: "娱乐余额",
                    value: "\(entertainmentBalanceMinutes)",
                    subtitle: "分钟可用",
                    color: .orange,
                    iconName: "banknote.fill"
                )

                StatCard(
                    title: "每日上限",
                    value: "\(dailyUseCapMinutes)",
                    subtitle: "分钟",
                    color: .blue,
                    iconName: "hourglass"
                )
            }

            ruleOverviewCard
            parentTaskSettingsCard
            weeklyPlanPreviewCard
            parentRewardSettingsCard
            parentMovementSettingsCard
            movementExemptionApprovalCard
            entertainmentBalanceRuleCard
            entertainmentCategoryLimitCard
            coreAppPolicyCard
            entertainmentWindowCard
            parentControlCard
            cloudSyncCard
            parentPINCard
            securityRecoveryCard

            Spacer(minLength: 20)
        }
        .padding()
    }

    private var parentLockView: some View {
        VStack(alignment: .leading, spacing: 18) {
            Image(systemName: "lock.fill")
                .font(.system(size: 44))
                .foregroundStyle(.blue)

            Text("规则设定已锁定")
                .font(.largeTitle)
                .bold()

            Text("请输入管理密码。这里可以修改学习、运动、娱乐和余额规则。")
                .foregroundStyle(.secondary)

            SecureField("管理密码", text: $parentPINInput)
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
                Label("进入规则设定", systemImage: "lock.open.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                parentPINError = "请使用恢复码 \(parentBindingCode) 或家长端确认来重置密码。"
            } label: {
                Label("忘记密码？", systemImage: "questionmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Spacer(minLength: 20)
        }
        .padding()
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("今日任务")
                .font(.largeTitle)
                .bold()

            Text("\(childName)，先完成重要任务，再使用可控娱乐时间。")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var todayRulesShortcutCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                RuleSummaryPill(
                    title: "娱乐余额",
                    value: "\(entertainmentBalanceMinutes) 分钟",
                    iconName: "banknote.fill",
                    color: .blue
                )

                RuleSummaryPill(
                    title: "今日上限",
                    value: "\(dailyUseCapMinutes) 分钟",
                    iconName: "hourglass",
                    color: .purple
                )
            }

            Button {
                selectedTab = 1
            } label: {
                Label("查看或调整规则设定", systemImage: "slider.horizontal.3")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
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
            Text(allTasksCompleted ? "娱乐时间已解锁" : "娱乐时间待解锁")
                .font(.title2)
                .bold()
                .foregroundStyle(allTasksCompleted ? .green : .red)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(entertainmentBalanceMinutes)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))

                Text("分钟可用")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            Text("今日已获得 \(gameTimeMinutes) 分钟，余额上限 \(entertainmentBalanceCap) 分钟。")
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
            totalTaskCount: enabledTaskCount,
            gameTimeMinutes: gameTimeMinutes,
            maxGameTimeMinutes: maxGameTimeMinutes
        )
    }

    private var taskListView: some View {
        VStack(spacing: 12) {
            LearningTaskRow(
                title: "任务 A · 应用 A",
                minutes: mathMinutes,
                note: mathNote,
                rewardMinutes: gameMinutesPerTask,
                color: .blue,
                isCompleted: $mathCompleted
            )

            if enabledTaskCount >= 2 {
                LearningTaskRow(
                    title: "任务 B · 应用 B",
                    minutes: englishMinutes,
                    note: englishNote,
                    rewardMinutes: gameMinutesPerTask,
                    color: .purple,
                    isCompleted: $englishCompleted
                )
            }

            if enabledTaskCount >= 3 {
                LearningTaskRow(
                    title: "任务 C · 应用 C",
                    minutes: readingMinutes,
                    note: readingNote,
                    rewardMinutes: gameMinutesPerTask,
                    color: .orange,
                    isCompleted: $readingCompleted
                )
            }

            if enabledTaskCount >= 4 {
                LearningTaskRow(
                    title: "任务 D · 应用 D",
                    minutes: taskDMinutes,
                    note: taskDNote,
                    rewardMinutes: gameMinutesPerTask,
                    color: .teal,
                    isCompleted: $taskDCompleted
                )
            }

            if enabledTaskCount >= 5 {
                LearningTaskRow(
                    title: "任务 E · 应用 E",
                    minutes: taskEMinutes,
                    note: taskENote,
                    rewardMinutes: gameMinutesPerTask,
                    color: .cyan,
                    isCompleted: $taskECompleted
                )
            }

            if enabledTaskCount >= 6 {
                LearningTaskRow(
                    title: "任务 F · 应用 F",
                    minutes: taskFMinutes,
                    note: taskFNote,
                    rewardMinutes: gameMinutesPerTask,
                    color: .indigo,
                    isCompleted: $taskFCompleted
                )
            }

            if enabledTaskCount >= 7 {
                LearningTaskRow(
                    title: "任务 G · 应用 G",
                    minutes: taskGMinutes,
                    note: taskGNote,
                    rewardMinutes: gameMinutesPerTask,
                    color: .pink,
                    isCompleted: $taskGCompleted
                )
            }

            if enabledTaskCount >= 8 {
                LearningTaskRow(
                    title: "任务 H · 应用 H",
                    minutes: taskHMinutes,
                    note: taskHNote,
                    rewardMinutes: gameMinutesPerTask,
                    color: .brown,
                    isCompleted: $taskHCompleted
                )
            }
        }
    }

    private var progressView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppText.t("daily_progress"))
                .font(.headline)

            ProgressView(value: Double(completedCount), total: Double(enabledTaskCount))
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

    private var ruleOverviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "list.bullet.rectangle.portrait.fill")
                    .foregroundStyle(.blue)

                Text("规则总览")
                    .font(.headline)
            }

            Text("当前采用“核心管控 APP + 全局统计”策略：重点限制最容易沉迷的 APP，其他 APP 先做统计和分类分析，降低设置门槛。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                RuleSummaryPill(title: "学习 APP", value: "\(coreLearningAppSlots) 个核心", iconName: "book.closed.fill", color: .purple)
                RuleSummaryPill(title: "娱乐 APP", value: "\(coreEntertainmentAppSlots) 个核心", iconName: "gamecontroller.fill", color: .blue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var weeklyPlanPreviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(.indigo)

                Text("每周计划预览")
                    .font(.headline)
            }

            Text("A 应用：周一、周三、周五各 \(mathMinutes) 分钟")
            Text("B 应用：周一到周五各 \(englishMinutes) 分钟")
            Text("C 应用：周六、周日各 \(readingMinutes) 分钟")
            Text("运动：每日 \(movementTargetMinutes) 分钟，完成奖励 \(movementRewardMinutes) 分钟")
                .foregroundStyle(.secondary)

            Text("下一步会把这里升级成周一到周日的可编辑表格，每个格子点开都是滚轮。")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var movementExemptionApprovalCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)

                Text("运动豁免审批")
                    .font(.headline)
            }

            Text(movementExemptionRequested ? "收到豁免申请：\(movementExemptionReason)。批准后今日不奖励娱乐时间，但不破坏连续记录。" : "暂无运动豁免申请。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Picker("豁免原因", selection: $movementExemptionReason) {
                Text("天气").tag("天气")
                Text("疾病").tag("疾病")
                Text("旅行").tag("旅行")
                Text("受伤").tag("受伤")
                Text("考试").tag("考试")
            }
            .pickerStyle(.segmented)

            Toggle("批准今日豁免", isOn: $movementExemptionApproved)
                .disabled(!movementExemptionRequested)

            MinuteWheelRow(title: "待补做运动", subtitle: "用于防作弊和补回规则严肃性", minutes: $movementMakeupMinutes, range: 0...180, step: 5, iconName: "arrow.triangle.2.circlepath", tint: .orange)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var entertainmentBalanceRuleCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "banknote.fill")
                    .foregroundStyle(.blue)

                Text("娱乐时间余额")
                    .font(.headline)
            }

            Text("娱乐时间像余额一样管理。未用完的时间可以按规则清零或累积，但必须设置上限。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Toggle("允许未用完时间累积", isOn: $allowEntertainmentCarryover)
            MinuteWheelRow(title: "当前结余", subtitle: "模拟余额，后续接入真实使用扣减", minutes: $entertainmentCarryoverMinutes, range: 0...300, step: 5, iconName: "tray.full.fill", tint: .blue)
            MinuteWheelRow(title: "总余额上限", subtitle: "避免无限攒时间", minutes: $entertainmentBalanceCap, range: 30...600, step: 10, iconName: "lock.fill", tint: .purple)
            MinuteWheelRow(title: "每日最多可使用", subtitle: "即使有余额，也不能无限使用", minutes: $dailyUseCapMinutes, range: 10...240, step: 5, iconName: "hourglass", tint: .orange)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var entertainmentCategoryLimitCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "square.grid.2x2.fill")
                    .foregroundStyle(.red)

                Text("娱乐分类总量")
                    .font(.headline)
            }

            Text("除了单个 APP，还要限制视频类、游戏类等分类总量。实际执行时采用最严格规则。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            MinuteWheelRow(title: "视频类工作日每日上限", subtitle: "例如短视频、动画、播放类 APP", minutes: $weekdayVideoLimitMinutes, range: 0...240, step: 5, iconName: "play.rectangle.fill", tint: .red)
            MinuteWheelRow(title: "视频类周末每日上限", subtitle: "周六、周日单日限制", minutes: $weekendVideoLimitMinutes, range: 0...360, step: 5, iconName: "play.tv.fill", tint: .red)
            MinuteWheelRow(title: "游戏类工作日每日上限", subtitle: "工作日游戏合计限制", minutes: $weekdayGameLimitMinutes, range: 0...180, step: 5, iconName: "gamecontroller.fill", tint: .blue)
            MinuteWheelRow(title: "游戏类周末合计上限", subtitle: "周六周日两天加起来", minutes: $weekendGameCombinedLimitMinutes, range: 0...480, step: 10, iconName: "calendar.badge.clock", tint: .blue)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var coreAppPolicyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "app.badge.checkmark.fill")
                    .foregroundStyle(.purple)

                Text("核心管控 APP")
                    .font(.headline)
            }

            Text("不用强迫家长配置所有 APP。重点管控最容易沉迷的核心 APP，其他应用进入全局统计。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper("核心学习 APP：\(coreLearningAppSlots) 个", value: $coreLearningAppSlots, in: 1...12, step: 1)
            Stepper("核心娱乐 APP：\(coreEntertainmentAppSlots) 个", value: $coreEntertainmentAppSlots, in: 1...12, step: 1)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var entertainmentWindowCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock.badge.checkmark.fill")
                    .foregroundStyle(.teal)

                Text("娱乐 APP 可用时段")
                    .font(.headline)
            }

            Text("示例规则先落地为摘要，后续可进入每个 APP 的详情页编辑多个时段。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TimeWindowSummaryRow(
                appName: "喜马拉雅儿童",
                category: "音频故事类",
                weekdayWindow: "18:00-21:30",
                weekendWindow: "08:00-22:00",
                limitText: "完成任务后解锁，到时自动锁定",
                color: .teal
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var securityRecoveryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "key.fill")
                    .foregroundStyle(.orange)

                Text("忘记密码与恢复")
                    .font(.headline)
            }

            Text("恢复码：\(parentBindingCode)")
                .font(.headline)

            Text("重置密码不会删除规则和记录。正式版可加入 Face ID、邮箱验证码或家长端确认。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button("生成新的恢复码") {
                parentBindingCode = "BD-\(Int.random(in: 100000...999999))"
            }
            .buttonStyle(.bordered)
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

                Text("学习应用计划")
                    .font(.headline)
            }

            Text("第一版保留 3 个默认学习任务，后续可扩展为最多 8 个核心学习 APP。点击分钟数可用滚轮调整。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper("启用任务数：\(enabledTaskCount) / \(maximumTaskCount)", value: $requiredLearningAppCount, in: 1...8, step: 1)
            MinuteWheelRow(title: "任务 A · 应用 A", subtitle: "家长设定应用 A 的使用目标", minutes: $mathMinutes, range: 5...180, step: 5, iconName: "a.circle.fill", tint: .blue)
            MinuteWheelRow(title: "任务 B · 应用 B", subtitle: "家长设定应用 B 的使用目标", minutes: $englishMinutes, range: 5...180, step: 5, iconName: "b.circle.fill", tint: .purple)
            MinuteWheelRow(title: "任务 C · 应用 C", subtitle: "家长设定应用 C 的使用目标", minutes: $readingMinutes, range: 5...180, step: 5, iconName: "c.circle.fill", tint: .orange)
            MinuteWheelRow(title: "任务 D · 应用 D", subtitle: "启用 4 个任务时，今日页会同步显示", minutes: $taskDMinutes, range: 5...180, step: 5, iconName: "d.circle.fill", tint: .teal)
            MinuteWheelRow(title: "任务 E · 应用 E", subtitle: "启用 5 个任务时，今日页会同步显示", minutes: $taskEMinutes, range: 5...180, step: 5, iconName: "e.circle.fill", tint: .cyan)
            MinuteWheelRow(title: "任务 F · 应用 F", subtitle: "启用 6 个任务时，今日页会同步显示", minutes: $taskFMinutes, range: 5...180, step: 5, iconName: "f.circle.fill", tint: .indigo)
            MinuteWheelRow(title: "任务 G · 应用 G", subtitle: "启用 7 个任务时，今日页会同步显示", minutes: $taskGMinutes, range: 5...180, step: 5, iconName: "g.circle.fill", tint: .pink)
            MinuteWheelRow(title: "任务 H · 应用 H", subtitle: "启用 8 个任务时，今日页会同步显示", minutes: $taskHMinutes, range: 5...180, step: 5, iconName: "h.circle.fill", tint: .brown)

            TextField("任务 A 说明", text: $mathNote)
                .textFieldStyle(.roundedBorder)

            TextField("任务 B 说明", text: $englishNote)
                .textFieldStyle(.roundedBorder)

            TextField("任务 C 说明", text: $readingNote)
                .textFieldStyle(.roundedBorder)

            TextField("任务 D 说明", text: $taskDNote)
                .textFieldStyle(.roundedBorder)

            TextField("任务 E 说明", text: $taskENote)
                .textFieldStyle(.roundedBorder)

            TextField("任务 F 说明", text: $taskFNote)
                .textFieldStyle(.roundedBorder)

            TextField("任务 G 说明", text: $taskGNote)
                .textFieldStyle(.roundedBorder)

            TextField("任务 H 说明", text: $taskHNote)
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

                Text("奖励规则")
                    .font(.headline)
            }

            Text("完成学习或运动任务后，奖励会进入娱乐时间余额。可设置每日可获得上限，防止过度刷任务。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            MinuteWheelRow(title: "每完成一个学习任务奖励", subtitle: "进入娱乐时间余额", minutes: $gameMinutesPerTask, range: 5...60, step: 5, iconName: "gift.fill", tint: .blue)
            MinuteWheelRow(title: "每日最多可获得", subtitle: "防止为了攒时间而过度刷任务", minutes: $dailyEarnCapMinutes, range: 10...180, step: 5, iconName: "speedometer", tint: .orange)

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

            Text("运动默认每日必须完成；特殊情况可以申请豁免，家长可选择补做机制。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper(AppText.t("start_hour", movementStartHour), value: $movementStartHour, in: 0...23, step: 1)
            Stepper(AppText.t("end_hour", movementEndHour), value: $movementEndHour, in: 1...24, step: 1)
            MinuteWheelRow(title: "每日运动目标", subtitle: "工作日默认目标", minutes: $movementTargetMinutes, range: 5...180, step: 5, iconName: "figure.run", tint: .green)
            MinuteWheelRow(title: "完成运动奖励", subtitle: "豁免不奖励，但可保留连续记录", minutes: $movementRewardMinutes, range: 0...60, step: 5, iconName: "medal.fill", tint: .orange)

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
            taskDCompleted = false
            taskECompleted = false
            taskFCompleted = false
            taskGCompleted = false
            taskHCompleted = false
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
        taskDCompleted = false
        taskECompleted = false
        taskFCompleted = false
        taskGCompleted = false
        taskHCompleted = false
        lastSavedDateKey = todayKey
    }

    private func normalizeStoredChineseText() {
        if childName == "Kid" {
            childName = "孩子"
        }

        if mathNote == "Practice number skills" {
            mathNote = "练习数字和计算能力"
        }

        if englishNote == "Use a learning app for English practice" {
            englishNote = "使用英语学习应用完成练习"
        }

        if readingNote == "Read a story or book" {
            readingNote = "阅读一个故事或一本书"
        }
    }

    private func updateTodayProgress() {
        saveTodayRecord()
        applyScreenTimeLimit()

        if !webPairingCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            uploadTodayRecordToWeb()
        }
    }

    private func applyScreenTimeLimit() {
        let effectiveLimit = min(entertainmentBalanceMinutes, dailyUseCapMinutes)
        #if canImport(FamilyControls) && canImport(ManagedSettings)
        screenTimeManager.applyGameTimeLimit(minutes: effectiveLimit, selection: entertainmentActivitySelection)
        #else
        screenTimeManager.applyGameTimeLimit(minutes: effectiveLimit)
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
