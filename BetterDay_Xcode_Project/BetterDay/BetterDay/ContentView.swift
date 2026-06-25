import SwiftUI
import Foundation
import Combine
import PhotosUI

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
        "app_name": "Do Better Day",
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
        "screen_time_denied_help": "Screen Time permission was denied. Use a real iPhone, make sure Family Controls capability is enabled for this bundle ID in Apple Developer, then delete and reinstall the app before requesting again.",
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
            "app_name": "倍塔兔", "nav_records": "每日记录", "parent_subtitle": "设置学习应用目标、奖励分钟数、娱乐锁定和运动时段。",
            "screen_time_api": "屏幕使用时间 API", "authorization": "授权：%@", "current_earned_limit": "当前已获得上限：%d 分钟",
            "request_screen_time_permission": "请求屏幕使用时间权限", "select_apps_categories": "选择应用和类别", "apply_earned_limit": "应用已获得上限", "clear_screen_time_restrictions": "清除屏幕使用限制",
            "setup_screen_time": "设置屏幕使用时间", "setup_screen_time_subtitle": "Apple 屏幕使用时间集成准备清单。", "request_permission": "请求权限", "request_permission_desc": "在这台 iPhone 上请求屏幕使用时间权限。",
            "select_apps": "选择应用", "select_apps_desc": "选择由倍塔兔管理的游戏或应用。", "apply_limit": "应用限制", "apply_limit_desc": "用已获得娱乐时间应用每日屏幕使用限制。", "monitor_usage": "监测使用",
            "monitor_usage_desc": "读取活动报告并更新家长控制台。", "continuous_learning": "连续学习", "day_streak": "%d 天连续", "game_time_unlocked": "娱乐已解锁：%d 分钟", "game_time_locked": "娱乐时间待解锁",
            "min_earned": "分钟已获得", "completed_count": "已完成：%d / %d", "progress_rule": "每完成一个学习应用目标，可获得 %d 分钟娱乐时间。", "date": "日期", "completed": "已完成",
            "record_detail": "记录详情", "done": "完成", "not_done": "未完成", "parent_pin_desc": "修改用于打开家长页的 PIN。", "history": "历史", "no_records": "还没有每日记录。",
            "no_records_desc": "完成或重置今天的任务后会生成记录。", "reset_today": "重置今天", "summary": "汇总", "tasks": "任务", "steps": "步数", "today": "今天",
            "exercise": "运动", "min_today": "今日分钟", "active_energy": "活动能量", "latest_workout": "最近运动", "health_sync_desc": "读取今天的步数、Apple 运动分钟、活动能量和最近运动。Apple Watch 运动同步到 iPhone 健康 App 后会显示在这里。",
            "current_streak": "当前连续", "last_7_days": "最近 7 天", "perfect_days": "完美天数", "movement_results": "运动结果", "movement_today": "今天：%d 步，%d 分钟运动，%d 千卡。",
            "latest_workout_line": "最近运动：%@，%d 分钟。", "refresh_movement_data": "刷新运动数据", "web_parent_sync": "家长网页同步", "web_parent_sync_desc": "输入家长网页控制台生成的配对码。今天的学习和娱乐时间会上传，方便远程查看。",
            "pairing_code": "配对码", "sync_remote_settings": "同步远程设置", "uploading": "上传中...", "upload_today_record": "上传今日记录", "auth_failed": "授权失败：%@", "screen_time_denied_help": "屏幕使用时间权限被拒绝。请使用真机，确认 Apple Developer 里该 Bundle ID 已开启 Family Controls 能力，然后删除并重装 App 后重新请求。", "opening_picker": "正在打开应用和类别选择器...",
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
    var totalTaskCount: Int?
    var completionPercent: Int?
    var scoreOneToFive: Int?
    var dailySummary: String?
    var weeklyCompletionPercent: Int?
    var weeklyScoreOneToFive: Int?
    var weeklyComparePercent: Int?
    var weeklySummary: String?

    var isFullyCompleted: Bool {
        completedCount >= (totalTaskCount ?? 3)
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
            statusMessage = AppText.t("screen_time_denied_help")
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
            statusMessage = AppText.t("auth_failed", error.localizedDescription) + "\n" + AppText.t("screen_time_denied_help")
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
        let p_daily_completion_percent: Int
        let p_daily_score_1_to_5: Int
        let p_daily_summary: String
        let p_weekly_completion_percent: Int
        let p_weekly_score_1_to_5: Int
        let p_weekly_compare_percent: Int
        let p_weekly_summary: String
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
        readingMinutes: Int,
        dailyCompletionPercent: Int,
        dailyScoreOneToFive: Int,
        dailySummary: String,
        weeklyCompletionPercent: Int,
        weeklyScoreOneToFive: Int,
        weeklyComparePercent: Int,
        weeklySummary: String
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
            p_reading_minutes: readingCompleted ? readingMinutes : 0,
            p_daily_completion_percent: dailyCompletionPercent,
            p_daily_score_1_to_5: dailyScoreOneToFive,
            p_daily_summary: dailySummary,
            p_weekly_completion_percent: weeklyCompletionPercent,
            p_weekly_score_1_to_5: weeklyScoreOneToFive,
            p_weekly_compare_percent: weeklyComparePercent,
            p_weekly_summary: weeklySummary
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
    let scheduleText: String
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

                Text(scheduleText)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                ProgressMeter(value: isCompleted ? 1 : 0, tint: color)
                    .padding(.top, 4)
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

struct HourWheelRow: View {
    let title: String
    let subtitle: String
    @Binding var hour: Int
    var iconName: String = "clock.fill"
    var tint: Color = .blue
    @State private var isPresented = false
    @State private var draftHour = 0

    var body: some View {
        Button {
            draftHour = hour
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

                Text(Self.formatHour(hour))
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
                Picker(title, selection: $draftHour) {
                    ForEach(0...23, id: \.self) { value in
                        Text(Self.formatHour(value)).tag(value)
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
                            hour = draftHour
                            isPresented = false
                        }
                    }
                }
            }
            .presentationDetents([.height(320)])
        }
    }

    static func formatHour(_ hour: Int) -> String {
        String(format: "%02d:00", min(max(hour, 0), 23))
    }
}

struct ProgressMeter: View {
    let value: Double
    let tint: Color

    private var clampedValue: Double {
        min(max(value, 0), 1)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.16))

                Capsule()
                    .fill(tint)
                    .frame(width: max(8, geometry.size.width * clampedValue))
            }
        }
        .frame(height: 10)
        .animation(.spring(response: 0.28, dampingFraction: 0.85), value: clampedValue)
    }
}

struct MinuteSliderRow: View {
    let title: String
    let subtitle: String
    @Binding var minutes: Int
    var range: ClosedRange<Double>
    var step: Double = 5
    var iconName: String
    var tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .foregroundStyle(tint)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
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
                    .monospacedDigit()
            }

            Slider(
                value: Binding(
                    get: { Double(minutes) },
                    set: { minutes = Int(($0 / step).rounded() * step) }
                ),
                in: range,
                step: step
            )
            .tint(tint)
        }
        .padding()
        .background(tint.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
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

struct SummaryScoreTile: View {
    let title: String
    let value: String
    let score: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2.bold())
                .monospacedDigit()

            HStack(spacing: 3) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= score ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundStyle(index <= score ? color : Color.gray.opacity(0.35))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.08))
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

                Text("完成率 \(record.completionPercent ?? 0)% · 评分 \(record.scoreOneToFive ?? 1)/5")
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
                    Text("\(record.completedCount) / \(record.totalTaskCount ?? 3)")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("完成率")
                    Spacer()
                    Text("\(record.completionPercent ?? 0)%")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("评分")
                    Spacer()
                    Text("\(record.scoreOneToFive ?? 1) / 5")
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

struct TaskRuleEditor<SelectedAppContent: View>: View {
    let taskLetter: String
    @Binding var note: String
    @Binding var weekdays: String
    @Binding var minutes: Int
    @Binding var rewardMinutes: Int
    let color: Color
    @ViewBuilder let selectedAppContent: () -> SelectedAppContent
    let selectAppAction: () -> Void

    private let weekdayItems: [(Int, String)] = [
        (2, "一"), (3, "二"), (4, "三"), (5, "四"), (6, "五"), (7, "六"), (1, "日")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "\(taskLetter.lowercased()).circle.fill")
                    .foregroundStyle(color)

                Text("任务 \(taskLetter) · 系统选择的学习 APP")
                    .font(.headline)
            }

            Button {
                selectAppAction()
            } label: {
                Label("选择任务 \(taskLetter) 对应 APP", systemImage: "app.badge.checkmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            HStack {
                selectedAppContent()
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            TextField("任务 \(taskLetter) 学习说明", text: $note)
                .textFieldStyle(.roundedBorder)

            HStack(spacing: 6) {
                ForEach(weekdayItems, id: \.0) { day, label in
                    Button(label) {
                        toggleWeekday(day)
                    }
                    .font(.caption.weight(.semibold))
                    .frame(width: 34, height: 30)
                    .background(selectedWeekdays.contains(day) ? color.opacity(0.22) : Color.gray.opacity(0.12))
                    .foregroundStyle(selectedWeekdays.contains(day) ? color : .secondary)
                    .clipShape(Capsule())
                }
            }

            MinuteWheelRow(title: "每日学习时长", subtitle: "今天是学习日时显示到今日任务", minutes: $minutes, range: 5...180, step: 5, iconName: "clock.fill", tint: color)
            MinuteWheelRow(title: "完成奖励娱乐时间", subtitle: "完成该任务后进入娱乐余额", minutes: $rewardMinutes, range: 0...60, step: 5, iconName: "gift.fill", tint: color)
        }
        .padding()
        .background(Color.white.opacity(0.82))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var selectedWeekdays: Set<Int> {
        Set(weekdays.split(separator: ",").compactMap { Int($0) })
    }

    private func toggleWeekday(_ day: Int) {
        var selected = selectedWeekdays
        if selected.contains(day) {
            selected.remove(day)
        } else {
            selected.insert(day)
        }
        weekdays = selected.sorted().map(String.init).joined(separator: ",")
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
    @AppStorage("taskARewardMinutes") private var taskARewardMinutes = 10
    @AppStorage("taskBRewardMinutes") private var taskBRewardMinutes = 10
    @AppStorage("taskCRewardMinutes") private var taskCRewardMinutes = 10
    @AppStorage("taskDRewardMinutes") private var taskDRewardMinutes = 10
    @AppStorage("taskERewardMinutes") private var taskERewardMinutes = 10
    @AppStorage("taskFRewardMinutes") private var taskFRewardMinutes = 10
    @AppStorage("taskGRewardMinutes") private var taskGRewardMinutes = 10
    @AppStorage("taskHRewardMinutes") private var taskHRewardMinutes = 10
    @AppStorage("childName") private var childName = "孩子"
    @AppStorage("mathNote") private var mathNote = "练习数字和计算能力"
    @AppStorage("englishNote") private var englishNote = "使用英语学习应用完成练习"
    @AppStorage("readingNote") private var readingNote = "阅读一个故事或一本书"
    @AppStorage("taskDNote") private var taskDNote = "使用应用 D 完成家长设定任务"
    @AppStorage("taskENote") private var taskENote = "使用应用 E 完成家长设定任务"
    @AppStorage("taskFNote") private var taskFNote = "使用应用 F 完成家长设定任务"
    @AppStorage("taskGNote") private var taskGNote = "使用应用 G 完成家长设定任务"
    @AppStorage("taskHNote") private var taskHNote = "使用应用 H 完成家长设定任务"
    @AppStorage("taskAWeekdays") private var taskAWeekdays = "2,3,4,5,6"
    @AppStorage("taskBWeekdays") private var taskBWeekdays = "2,3,4,5,6"
    @AppStorage("taskCWeekdays") private var taskCWeekdays = "7,1"
    @AppStorage("taskDWeekdays") private var taskDWeekdays = "2,3,4,5,6"
    @AppStorage("taskEWeekdays") private var taskEWeekdays = "2,3,4,5,6"
    @AppStorage("taskFWeekdays") private var taskFWeekdays = "2,3,4,5,6"
    @AppStorage("taskGWeekdays") private var taskGWeekdays = "2,3,4,5,6"
    @AppStorage("taskHWeekdays") private var taskHWeekdays = "2,3,4,5,6"
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
    @AppStorage("weekdayEntertainmentLimitMinutes") private var weekdayEntertainmentLimitMinutes = 45
    @AppStorage("weekendEntertainmentLimitMinutes") private var weekendEntertainmentLimitMinutes = 120
    @AppStorage("allowEntertainmentCarryover") private var allowEntertainmentCarryover = true
    @AppStorage("weekdayVideoLimitMinutes") private var weekdayVideoLimitMinutes = 30
    @AppStorage("weekendVideoLimitMinutes") private var weekendVideoLimitMinutes = 60
    @AppStorage("weekdayGameLimitMinutes") private var weekdayGameLimitMinutes = 20
    @AppStorage("weekendGameCombinedLimitMinutes") private var weekendGameCombinedLimitMinutes = 90
    @AppStorage("entertainmentWeekdayStartHour") private var entertainmentWeekdayStartHour = 18
    @AppStorage("entertainmentWeekdayEndHour") private var entertainmentWeekdayEndHour = 21
    @AppStorage("entertainmentWeekendStartHour") private var entertainmentWeekendStartHour = 8
    @AppStorage("entertainmentWeekendEndHour") private var entertainmentWeekendEndHour = 22
    @AppStorage("movementExemptionRequested") private var movementExemptionRequested = false
    @AppStorage("movementExemptionApproved") private var movementExemptionApproved = false
    @AppStorage("movementExemptionReason") private var movementExemptionReason = "天气"
    @AppStorage("parentBindingCode") private var parentBindingCode = "BD-482913"

    @State private var parentPINInput = ""
    @State private var newParentPIN = ""
    @State private var isParentUnlocked = false
    @State private var parentPINError = ""
    @State private var selectedTab = 0
    @State private var taskSelectionLimitMessage = ""
    @State private var parentLastActivityDate = Date()
    @State private var feedbackType = "功能建议"
    @State private var feedbackMessage = ""
    @State private var feedbackContact = ""
    @State private var feedbackScreenshotItem: PhotosPickerItem?
    @State private var feedbackScreenshotAttached = false
    @State private var feedbackStatusMessage = ""

    private let parentAutoLockSeconds: TimeInterval = 60
    private let parentAutoLockTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    private let maximumTaskCount = 8

    #if canImport(FamilyControls)
    @State private var taskAActivitySelection = FamilyActivitySelection()
    @State private var taskBActivitySelection = FamilyActivitySelection()
    @State private var taskCActivitySelection = FamilyActivitySelection()
    @State private var taskDActivitySelection = FamilyActivitySelection()
    @State private var taskEActivitySelection = FamilyActivitySelection()
    @State private var taskFActivitySelection = FamilyActivitySelection()
    @State private var taskGActivitySelection = FamilyActivitySelection()
    @State private var taskHActivitySelection = FamilyActivitySelection()
    @State private var entertainmentActivitySelection = FamilyActivitySelection()
    @State private var isTaskAPickerPresented = false
    @State private var isTaskBPickerPresented = false
    @State private var isTaskCPickerPresented = false
    @State private var isTaskDPickerPresented = false
    @State private var isTaskEPickerPresented = false
    @State private var isTaskFPickerPresented = false
    @State private var isTaskGPickerPresented = false
    @State private var isTaskHPickerPresented = false
    @State private var isEntertainmentPickerPresented = false
    #endif

    private var todayWeekday: Int {
        Calendar.current.component(.weekday, from: Date())
    }

    private var activeTodayTaskCount: Int {
        (0..<enabledTaskCount).filter { taskIsScheduledToday($0) }.count
    }

    private var totalTodayTaskCount: Int {
        activeTodayTaskCount + 1
    }

    private var completedCount: Int {
        (0..<enabledTaskCount).filter { taskIsScheduledToday($0) && taskCompleted($0) }.count
    }

    private var completedTodayTaskCount: Int {
        completedCount + (movementTaskCompletedToday ? 1 : 0)
    }

    private var todayCompletionPercent: Int {
        percent(completedTodayTaskCount, of: max(totalTodayTaskCount, 1))
    }

    private var todayScoreOneToFive: Int {
        scoreOneToFive(for: todayCompletionPercent)
    }

    private var isWeekendToday: Bool {
        todayWeekday == 1 || todayWeekday == 7
    }

    private var todayEntertainmentLimitMinutes: Int {
        isWeekendToday ? weekendEntertainmentLimitMinutes : weekdayEntertainmentLimitMinutes
    }

    private var todayAvailableEntertainmentMinutes: Int {
        min(entertainmentBalanceMinutes, todayEntertainmentLimitMinutes)
    }

    private var enabledTaskCount: Int {
        min(max(requiredLearningAppCount, 1), maximumTaskCount)
    }

    private var parentRuleActivityKey: String {
        var values: [String] = []

        values.append(childName)
        values.append(mathNote)
        values.append(englishNote)
        values.append(readingNote)
        values.append(taskDNote)
        values.append(taskENote)
        values.append(taskFNote)
        values.append(taskGNote)
        values.append(taskHNote)
        values.append(taskAWeekdays)
        values.append(taskBWeekdays)
        values.append(taskCWeekdays)
        values.append(taskDWeekdays)
        values.append(taskEWeekdays)
        values.append(taskFWeekdays)
        values.append(taskGWeekdays)
        values.append(taskHWeekdays)
        values.append(movementActivityType)
        values.append(movementExemptionReason)
        values.append(parentPIN)

        values.append(String(requiredLearningAppCount))
        values.append(String(mathMinutes))
        values.append(String(englishMinutes))
        values.append(String(readingMinutes))
        values.append(String(taskDMinutes))
        values.append(String(taskEMinutes))
        values.append(String(taskFMinutes))
        values.append(String(taskGMinutes))
        values.append(String(taskHMinutes))
        values.append(String(taskARewardMinutes))
        values.append(String(taskBRewardMinutes))
        values.append(String(taskCRewardMinutes))
        values.append(String(taskDRewardMinutes))
        values.append(String(taskERewardMinutes))
        values.append(String(taskFRewardMinutes))
        values.append(String(taskGRewardMinutes))
        values.append(String(taskHRewardMinutes))
        values.append(String(movementStartHour))
        values.append(String(movementEndHour))
        values.append(String(movementTargetMinutes))
        values.append(String(movementRewardMinutes))
        values.append(String(entertainmentCarryoverMinutes))
        values.append(String(entertainmentBalanceCap))
        values.append(String(dailyEarnCapMinutes))
        values.append(String(allowEntertainmentCarryover))
        values.append(String(weekdayEntertainmentLimitMinutes))
        values.append(String(weekendEntertainmentLimitMinutes))
        values.append(String(weekdayVideoLimitMinutes))
        values.append(String(weekendVideoLimitMinutes))
        values.append(String(weekdayGameLimitMinutes))
        values.append(String(weekendGameCombinedLimitMinutes))
        values.append(String(entertainmentWeekdayStartHour))
        values.append(String(entertainmentWeekdayEndHour))
        values.append(String(entertainmentWeekendStartHour))
        values.append(String(entertainmentWeekendEndHour))
        values.append(String(movementExemptionApproved))

        return values.joined(separator: "|")
    }

    #if canImport(FamilyControls)
    private func taskActivitySelection(_ index: Int) -> FamilyActivitySelection {
        switch index {
        case 0: return taskAActivitySelection
        case 1: return taskBActivitySelection
        case 2: return taskCActivitySelection
        case 3: return taskDActivitySelection
        case 4: return taskEActivitySelection
        case 5: return taskFActivitySelection
        case 6: return taskGActivitySelection
        default: return taskHActivitySelection
        }
    }

    private func setTaskActivitySelection(_ selection: FamilyActivitySelection, for index: Int) {
        switch index {
        case 0: taskAActivitySelection = selection
        case 1: taskBActivitySelection = selection
        case 2: taskCActivitySelection = selection
        case 3: taskDActivitySelection = selection
        case 4: taskEActivitySelection = selection
        case 5: taskFActivitySelection = selection
        case 6: taskGActivitySelection = selection
        default: taskHActivitySelection = selection
        }
    }

    private func limitTaskActivitySelection(_ index: Int) {
        let selection = taskActivitySelection(index)
        let isValidSingleApp = selection.applicationTokens.count == 1 &&
            selection.categoryTokens.isEmpty &&
            selection.webDomainTokens.isEmpty
        let shouldReject = selection.applicationTokens.count > 1 ||
            !selection.categoryTokens.isEmpty ||
            !selection.webDomainTokens.isEmpty
        guard !isValidSingleApp && shouldReject else { return }

        setTaskActivitySelection(FamilyActivitySelection(), for: index)
        taskSelectionLimitMessage = "任务 \(taskLetter(index)) 只能选择一个具体 APP。请重新进入选择器，只点选一个 APP，不要选择分类或网页。"
    }

    private func taskSelectionValidationKey(_ index: Int) -> String {
        let selection = taskActivitySelection(index)
        return "\(selection.applicationTokens.count)-\(selection.categoryTokens.count)-\(selection.webDomainTokens.count)"
    }

    #endif

    private var gameTimeMinutes: Int {
        let taskRewards = (0..<enabledTaskCount).reduce(0) { total, index in
            taskIsScheduledToday(index) && taskCompleted(index) ? total + taskRewardMinutes(index) : total
        }
        return min(taskRewards + movementRewardMinutesEarned, dailyEarnCapMinutes)
    }

    private var maxGameTimeMinutes: Int {
        let taskRewards = (0..<enabledTaskCount).reduce(0) { total, index in
            taskIsScheduledToday(index) ? total + taskRewardMinutes(index) : total
        }
        return min(taskRewards + movementRewardMinutes, dailyEarnCapMinutes)
    }

    private var entertainmentBalanceMinutes: Int {
        min((allowEntertainmentCarryover ? entertainmentCarryoverMinutes : 0) + gameTimeMinutes, entertainmentBalanceCap)
    }

    private var movementIsExcusedToday: Bool {
        movementExemptionRequested && movementExemptionApproved
    }

    private var allTasksCompleted: Bool {
        activeTodayTaskCount > 0 && completedCount >= activeTodayTaskCount
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

    private func taskCompleted(_ index: Int) -> Bool {
        switch index {
        case 0: return mathCompleted
        case 1: return englishCompleted
        case 2: return readingCompleted
        case 3: return taskDCompleted
        case 4: return taskECompleted
        case 5: return taskFCompleted
        case 6: return taskGCompleted
        default: return taskHCompleted
        }
    }

    private func taskRewardMinutes(_ index: Int) -> Int {
        switch index {
        case 0: return taskARewardMinutes
        case 1: return taskBRewardMinutes
        case 2: return taskCRewardMinutes
        case 3: return taskDRewardMinutes
        case 4: return taskERewardMinutes
        case 5: return taskFRewardMinutes
        case 6: return taskGRewardMinutes
        default: return taskHRewardMinutes
        }
    }

    private func taskMinutes(_ index: Int) -> Int {
        switch index {
        case 0: return mathMinutes
        case 1: return englishMinutes
        case 2: return readingMinutes
        case 3: return taskDMinutes
        case 4: return taskEMinutes
        case 5: return taskFMinutes
        case 6: return taskGMinutes
        default: return taskHMinutes
        }
    }

    private func taskLetter(_ index: Int) -> String {
        ["A", "B", "C", "D", "E", "F", "G", "H"][min(max(index, 0), 7)]
    }

    private func entertainmentWindowText(start: Int, end: Int) -> String {
        let startText = HourWheelRow.formatHour(start)
        let endText = HourWheelRow.formatHour(end)
        return end <= start ? "\(startText)-次日 \(endText)" : "\(startText)-\(endText)"
    }

    private func percent(_ completed: Int, of total: Int) -> Int {
        guard total > 0 else { return 0 }
        return Int((Double(completed) / Double(total) * 100).rounded())
    }

    private func scoreOneToFive(for percent: Int) -> Int {
        switch percent {
        case 0...20: return 1
        case 21...40: return 2
        case 41...60: return 3
        case 61...80: return 4
        default: return 5
        }
    }

    private func recordsCompletionPercent(_ records: [DailyRecord]) -> Int {
        guard !records.isEmpty else { return 0 }
        let completed = records.reduce(0) { $0 + $1.completedCount }
        let total = records.reduce(0) { $0 + ($1.totalTaskCount ?? 3) }
        return percent(completed, of: max(total, 1))
    }

    @ViewBuilder
    private func taskSelectedAppLabel(_ index: Int) -> some View {
        #if canImport(FamilyControls)
        if let token = taskActivitySelection(index).applicationTokens.first {
            Label(token)
                .font(.subheadline.weight(.semibold))
        } else {
            Label("未选择 APP", systemImage: "app.dashed")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        #else
        Label("未选择 APP", systemImage: "app.dashed")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        #endif
    }

    private func taskWeekdays(_ index: Int) -> String {
        switch index {
        case 0: return taskAWeekdays
        case 1: return taskBWeekdays
        case 2: return taskCWeekdays
        case 3: return taskDWeekdays
        case 4: return taskEWeekdays
        case 5: return taskFWeekdays
        case 6: return taskGWeekdays
        default: return taskHWeekdays
        }
    }

    private func taskIsScheduledToday(_ index: Int) -> Bool {
        taskWeekdays(index).split(separator: ",").contains { Int($0) == todayWeekday }
    }

    private func taskScheduleText(_ index: Int) -> String {
        let names = [2: "周一", 3: "周二", 4: "周三", 5: "周四", 6: "周五", 7: "周六", 1: "周日"]
        let days = taskWeekdays(index)
            .split(separator: ",")
            .compactMap { Int($0) }
            .sorted { left, right in
                let order = [2, 3, 4, 5, 6, 7, 1]
                return (order.firstIndex(of: left) ?? 0) < (order.firstIndex(of: right) ?? 0)
            }
            .compactMap { names[$0] }
            .joined(separator: "、")
        return days.isEmpty ? "未设置学习日" : "学习日：\(days)"
    }

    private var movementGoalCompleted: Bool {
        movementProgressMinutes >= movementTargetMinutes
    }

    private var movementTaskCompletedToday: Bool {
        movementGoalCompleted || movementIsExcusedToday
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

    private var previousSevenRecords: [DailyRecord] {
        Array(dailyRecords.dropFirst(7).prefix(7))
    }

    private var weeklyCompletionPercent: Int {
        recordsCompletionPercent(lastSevenRecords)
    }

    private var previousWeeklyCompletionPercent: Int {
        recordsCompletionPercent(previousSevenRecords)
    }

    private var weeklyScoreOneToFive: Int {
        scoreOneToFive(for: weeklyCompletionPercent)
    }

    private var weeklyComparePercent: Int {
        weeklyCompletionPercent - previousWeeklyCompletionPercent
    }

    private var dailySummaryText: String {
        "今日完成率 \(todayCompletionPercent)%，评分 \(todayScoreOneToFive)/5。已解锁 \(gameTimeMinutes) 分钟娱乐时间，今日最多可用 \(todayAvailableEntertainmentMinutes) 分钟。"
    }

    private var weeklySummaryText: String {
        let compareText: String
        if previousSevenRecords.isEmpty {
            compareText = "暂无上周数据可比较。"
        } else if weeklyComparePercent > 0 {
            compareText = "比上周提高 \(weeklyComparePercent)%。"
        } else if weeklyComparePercent < 0 {
            compareText = "比上周下降 \(abs(weeklyComparePercent))%。"
        } else {
            compareText = "与上周持平。"
        }
        return "本周完成率 \(weeklyCompletionPercent)%，评分 \(weeklyScoreOneToFive)/5。\(compareText)"
    }

    private var screenTimePermissionStatusText: String {
        switch screenTimeManager.authorizationState {
        case .approved:
            return "已开启"
        case .notDetermined:
            return "未开启"
        case .denied:
            return "开启失败"
        case .unavailable:
            return "当前构建不可用"
        }
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
                    accountView
                }
                .navigationTitle("我的")
            }
            .tabItem {
                Label("我的", systemImage: "person.crop.circle")
            }
            .tag(2)
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
        .onChange(of: selectedTab) { _ in
            if selectedTab == 1 {
                resetParentAutoLockTimer()
            } else {
                lockParentArea()
            }
        }
        .onChange(of: isParentUnlocked) { _ in
            if isParentUnlocked {
                resetParentAutoLockTimer()
            }
        }
        .onChange(of: parentRuleActivityKey) { _ in
            resetParentAutoLockTimer()
        }
        .onReceive(parentAutoLockTimer) { _ in
            autoLockParentAreaIfNeeded()
        }
        #if canImport(FamilyControls)
        .familyActivityPicker(isPresented: $isTaskAPickerPresented, selection: $taskAActivitySelection)
        .familyActivityPicker(isPresented: $isTaskBPickerPresented, selection: $taskBActivitySelection)
        .familyActivityPicker(isPresented: $isTaskCPickerPresented, selection: $taskCActivitySelection)
        .familyActivityPicker(isPresented: $isTaskDPickerPresented, selection: $taskDActivitySelection)
        .familyActivityPicker(isPresented: $isTaskEPickerPresented, selection: $taskEActivitySelection)
        .familyActivityPicker(isPresented: $isTaskFPickerPresented, selection: $taskFActivitySelection)
        .familyActivityPicker(isPresented: $isTaskGPickerPresented, selection: $taskGActivitySelection)
        .familyActivityPicker(isPresented: $isTaskHPickerPresented, selection: $taskHActivitySelection)
        .familyActivityPicker(isPresented: $isEntertainmentPickerPresented, selection: $entertainmentActivitySelection)
        .onChange(of: taskSelectionValidationKey(0)) { _ in limitTaskActivitySelection(0) }
        .onChange(of: taskSelectionValidationKey(1)) { _ in limitTaskActivitySelection(1) }
        .onChange(of: taskSelectionValidationKey(2)) { _ in limitTaskActivitySelection(2) }
        .onChange(of: taskSelectionValidationKey(3)) { _ in limitTaskActivitySelection(3) }
        .onChange(of: taskSelectionValidationKey(4)) { _ in limitTaskActivitySelection(4) }
        .onChange(of: taskSelectionValidationKey(5)) { _ in limitTaskActivitySelection(5) }
        .onChange(of: taskSelectionValidationKey(6)) { _ in limitTaskActivitySelection(6) }
        .onChange(of: taskSelectionValidationKey(7)) { _ in limitTaskActivitySelection(7) }
        #endif
        .alert("选择过多", isPresented: Binding(
            get: { !taskSelectionLimitMessage.isEmpty },
            set: { isPresented in
                if !isPresented {
                    taskSelectionLimitMessage = ""
                }
            }
        )) {
            Button("知道了", role: .cancel) {
                taskSelectionLimitMessage = ""
            }
        } message: {
            Text(taskSelectionLimitMessage)
        }
    }

    private var todayView: some View {
        VStack(alignment: .leading, spacing: 22) {
            headerView
            taskListView
            movementWindowSummaryCard
            todayEntertainmentStatusCard
            completionSummaryCard
            movementExemptionCard
            resetButton
        }
        .padding()
    }

    private var appSelectionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "app.connected.to.app.below.fill")
                    .foregroundStyle(.purple)

                Text("娱乐和游戏 App")
                    .font(.headline)
            }

            Text("选择需要管控的娱乐、视频和游戏 App。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("建议先只选择最容易沉迷的 APP，例如短视频、游戏、直播。选择过多时，系统会提示精简。")
                .font(.footnote)
                .foregroundStyle(.secondary)

            #if canImport(FamilyControls)
            Label("学习 APP 请在规则设定里按任务 A-H 分别选择", systemImage: "book.closed.fill")
                .font(.footnote)
                .foregroundStyle(.secondary)

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

                Text("App 管控权限")
                    .font(.headline)
            }

            Text("开启后，倍塔兔才能选择和限制娱乐、游戏 APP。通常只需要首次授权。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Label(screenTimePermissionStatusText, systemImage: screenTimeManager.authorizationState == .approved ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(screenTimeManager.authorizationState.color)

            Button {
                Task {
                    await screenTimeManager.requestAuthorization()
                    applyScreenTimeLimit()
                }
            } label: {
                Label("开启 App 管控权限", systemImage: "person.badge.key.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                applyScreenTimeLimit()
            } label: {
                Label("应用当前规则", systemImage: "slider.horizontal.3")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            if screenTimeManager.authorizationState == .denied || screenTimeManager.authorizationState == .unavailable {
                Text("开启失败时，请确认在 iPhone 真机上允许屏幕使用时间权限。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
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

            Text(movementIsExcusedToday ? "今日已延期运动：不奖励娱乐时间，但不破坏连续记录。" : AppText.t("movement_progress_line", movementProgressMinutes, movementTargetMinutes, movementRewardMinutesEarned))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ProgressMeter(value: Double(min(movementProgressMinutes, movementTargetMinutes)) / Double(max(movementTargetMinutes, 1)), tint: .green)

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

                Text("运动延期与周末补回")
                    .font(.headline)
            }

            Text(movementExemptionRequested ? "今日已延期运动：今天不发运动奖励，但不打断连续记录。周末补回时按折扣补发娱乐时间。" : "今天确实不适合运动时，可以选择延期到周末补回。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Button {
                    movementExemptionRequested = true
                    movementExemptionApproved = true
                    movementExemptionReason = "延期"
                } label: {
                    Label("今日延期运动", systemImage: "calendar.badge.clock")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    movementExemptionRequested = false
                    movementExemptionApproved = false
                } label: {
                    Label("取消延期", systemImage: "arrow.uturn.backward")
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

    private var accountView: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("查看历史记录、提交反馈，并管理家长端和孩子端绑定。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            accountRecordsCard
            childProfileCard
            bindingCard
            feedbackCard
            accountModeCard
            cloudSyncCard
        }
        .padding()
    }

    private var accountRecordsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "calendar.badge.checkmark")
                    .foregroundStyle(.indigo)

                Text("历史记录")
                    .font(.headline)
            }

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
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var feedbackCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bubble.left.and.text.bubble.right.fill")
                    .foregroundStyle(.blue)

                Text("我要反馈")
                    .font(.headline)
            }

            Text("告诉我们哪里不好用，或者你希望倍塔兔增加什么。截图可能包含个人信息，请确认后再上传。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Picker("反馈类型", selection: $feedbackType) {
                Text("功能建议").tag("功能建议")
                Text("使用问题").tag("使用问题")
                Text("Bug 反馈").tag("Bug 反馈")
                Text("同步问题").tag("同步问题")
                Text("其他").tag("其他")
            }
            .pickerStyle(.menu)

            TextField("反馈内容", text: $feedbackMessage, axis: .vertical)
                .lineLimit(3...6)
                .textFieldStyle(.roundedBorder)

            TextField("联系方式，可选", text: $feedbackContact)
                .textFieldStyle(.roundedBorder)

            PhotosPicker(selection: $feedbackScreenshotItem, matching: .images) {
                Label(feedbackScreenshotAttached ? "已添加截图" : "添加截图", systemImage: "photo")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .onChange(of: feedbackScreenshotItem) { _ in
                feedbackScreenshotAttached = feedbackScreenshotItem != nil
            }

            Button {
                submitFeedback()
            } label: {
                Label("提交反馈", systemImage: "paperplane.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(feedbackMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            if !feedbackStatusMessage.isEmpty {
                Text(feedbackStatusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
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
            Text("选择 App、学习任务、娱乐时段和运动规则。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            appSelectionCard
            screenTimeControlCard
            entertainmentWindowCard
            entertainmentTotalLimitCard

            parentTaskSettingsCard
            weeklyPlanPreviewCard
            parentRewardSettingsCard
            completionSummaryCard
            parentMovementSettingsCard
            movementExemptionApprovalCard
            entertainmentBalanceRuleCard
            entertainmentCategoryLimitCard
            cloudSyncCard
            parentPINCard
            securityRecoveryCard
        }
        .padding()
        .padding(.bottom, 120)
        .simultaneousGesture(
            TapGesture().onEnded {
                resetParentAutoLockTimer()
            }
        )
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

    private var todayEntertainmentStatusCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "lock.open.fill")
                    .foregroundStyle(.orange)

                Text("今日可解锁娱乐时间")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("已解锁 \(gameTimeMinutes) / \(maxGameTimeMinutes) 分钟")
                        .font(.headline)
                    Spacer()
                    Text("\(todayCompletionPercent)%")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                ProgressMeter(value: maxGameTimeMinutes == 0 ? 0 : Double(gameTimeMinutes) / Double(maxGameTimeMinutes), tint: .orange)
            }

            HStack(spacing: 12) {
                RuleSummaryPill(
                    title: "娱乐余额",
                    value: "\(entertainmentBalanceMinutes) 分钟",
                    iconName: "banknote.fill",
                    color: .blue
                )

                RuleSummaryPill(
                    title: isWeekendToday ? "周末上限" : "工作日上限",
                    value: "\(todayEntertainmentLimitMinutes) 分钟",
                    iconName: "hourglass",
                    color: .purple
                )
            }

            Text("今日最多可用 \(todayAvailableEntertainmentMinutes) 分钟。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var completionSummaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "chart.bar.doc.horizontal.fill")
                    .foregroundStyle(.indigo)

                Text("完成情况总结")
                    .font(.headline)
            }

            HStack(spacing: 12) {
                SummaryScoreTile(title: "今日完成率", value: "\(todayCompletionPercent)%", score: todayScoreOneToFive, color: .blue)
                SummaryScoreTile(title: "本周完成率", value: "\(weeklyCompletionPercent)%", score: weeklyScoreOneToFive, color: .green)
            }

            Text(dailySummaryText)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(weeklySummaryText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var taskListView: some View {
        VStack(spacing: 12) {
            if activeTodayTaskCount == 0 {
                Text("今天没有安排学习任务。")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.88))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }

            if taskIsScheduledToday(0) {
                LearningTaskRow(
                    title: "任务 A · 系统选择的学习 APP",
                    minutes: mathMinutes,
                    note: mathNote,
                    rewardMinutes: taskARewardMinutes,
                    scheduleText: taskScheduleText(0),
                    color: .blue,
                    isCompleted: $mathCompleted
                )
            }

            if enabledTaskCount >= 2 && taskIsScheduledToday(1) {
                LearningTaskRow(
                    title: "任务 B · 系统选择的学习 APP",
                    minutes: englishMinutes,
                    note: englishNote,
                    rewardMinutes: taskBRewardMinutes,
                    scheduleText: taskScheduleText(1),
                    color: .purple,
                    isCompleted: $englishCompleted
                )
            }

            if enabledTaskCount >= 3 && taskIsScheduledToday(2) {
                LearningTaskRow(
                    title: "任务 C · 系统选择的学习 APP",
                    minutes: readingMinutes,
                    note: readingNote,
                    rewardMinutes: taskCRewardMinutes,
                    scheduleText: taskScheduleText(2),
                    color: .orange,
                    isCompleted: $readingCompleted
                )
            }

            if enabledTaskCount >= 4 && taskIsScheduledToday(3) {
                LearningTaskRow(
                    title: "任务 D · 系统选择的学习 APP",
                    minutes: taskDMinutes,
                    note: taskDNote,
                    rewardMinutes: taskDRewardMinutes,
                    scheduleText: taskScheduleText(3),
                    color: .teal,
                    isCompleted: $taskDCompleted
                )
            }

            if enabledTaskCount >= 5 && taskIsScheduledToday(4) {
                LearningTaskRow(
                    title: "任务 E · 系统选择的学习 APP",
                    minutes: taskEMinutes,
                    note: taskENote,
                    rewardMinutes: taskERewardMinutes,
                    scheduleText: taskScheduleText(4),
                    color: .cyan,
                    isCompleted: $taskECompleted
                )
            }

            if enabledTaskCount >= 6 && taskIsScheduledToday(5) {
                LearningTaskRow(
                    title: "任务 F · 系统选择的学习 APP",
                    minutes: taskFMinutes,
                    note: taskFNote,
                    rewardMinutes: taskFRewardMinutes,
                    scheduleText: taskScheduleText(5),
                    color: .indigo,
                    isCompleted: $taskFCompleted
                )
            }

            if enabledTaskCount >= 7 && taskIsScheduledToday(6) {
                LearningTaskRow(
                    title: "任务 G · 系统选择的学习 APP",
                    minutes: taskGMinutes,
                    note: taskGNote,
                    rewardMinutes: taskGRewardMinutes,
                    scheduleText: taskScheduleText(6),
                    color: .pink,
                    isCompleted: $taskGCompleted
                )
            }

            if enabledTaskCount >= 8 && taskIsScheduledToday(7) {
                LearningTaskRow(
                    title: "任务 H · 系统选择的学习 APP",
                    minutes: taskHMinutes,
                    note: taskHNote,
                    rewardMinutes: taskHRewardMinutes,
                    scheduleText: taskScheduleText(7),
                    color: .brown,
                    isCompleted: $taskHCompleted
                )
            }
        }
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
            readingMinutes: readingMinutes,
            dailyCompletionPercent: todayCompletionPercent,
            dailyScoreOneToFive: todayScoreOneToFive,
            dailySummary: dailySummaryText,
            weeklyCompletionPercent: weeklyCompletionPercent,
            weeklyScoreOneToFive: weeklyScoreOneToFive,
            weeklyComparePercent: weeklyComparePercent,
            weeklySummary: weeklySummaryText
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
                readingMinutes: snapshot.readingMinutes,
                dailyCompletionPercent: snapshot.dailyCompletionPercent,
                dailyScoreOneToFive: snapshot.dailyScoreOneToFive,
                dailySummary: snapshot.dailySummary,
                weeklyCompletionPercent: snapshot.weeklyCompletionPercent,
                weeklyScoreOneToFive: snapshot.weeklyScoreOneToFive,
                weeklyComparePercent: snapshot.weeklyComparePercent,
                weeklySummary: snapshot.weeklySummary
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

    private var weeklyPlanPreviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(.indigo)

                Text("每周计划预览")
                    .font(.headline)
            }

            ForEach(0..<enabledTaskCount, id: \.self) { index in
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("任务 \(taskLetter(index))")
                            .font(.subheadline.weight(.semibold))
                        taskSelectedAppLabel(index)
                    }
                    Text("\(taskScheduleText(index))，每日 \(taskMinutes(index)) 分钟，完成奖励 \(taskRewardMinutes(index)) 分钟")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Text("运动：每日 \(movementTargetMinutes) 分钟，完成奖励 \(movementRewardMinutes) 分钟")
                .foregroundStyle(.secondary)

            Text("这里会随任务学习日、学习时长和奖励设置实时更新。")
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
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(.orange)

                Text("运动延期与周末补回")
                    .font(.headline)
            }

            Text("孩子可以自己选择今日延期运动。延期当天不发运动奖励、不打断连续记录；周末补回时按折扣补发娱乐时间。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(movementExemptionRequested ? "今日状态：已延期运动。" : "今日状态：未延期。")
                .font(.headline)
                .foregroundStyle(movementExemptionRequested ? .orange : .secondary)
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

            Text("孩子完成任务赚到的娱乐时间会进入余额。实际可用时间还会受到工作日/周末总上限和可用时段限制。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            #if canImport(FamilyControls)
            Button {
                isEntertainmentPickerPresented = true
            } label: {
                Label("选择娱乐 APP", systemImage: "gamecontroller.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            #else
            Text(AppText.t("picker_unavailable"))
                .font(.footnote)
                .foregroundStyle(.secondary)
            #endif

            Toggle("允许未用完时间累积", isOn: $allowEntertainmentCarryover)
            MinuteWheelRow(title: "当前结余", subtitle: "模拟余额，后续接入真实使用扣减", minutes: $entertainmentCarryoverMinutes, range: 0...300, step: 5, iconName: "tray.full.fill", tint: .blue)
            MinuteWheelRow(title: "总余额上限", subtitle: "避免无限攒时间", minutes: $entertainmentBalanceCap, range: 30...600, step: 10, iconName: "lock.fill", tint: .purple)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var entertainmentTotalLimitCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "speedometer")
                    .foregroundStyle(.orange)

                Text("娱乐总上限")
                    .font(.headline)
            }

            Text("总上限是所有娱乐和游戏 APP 的合计可用时间，优先级高于视频/游戏分类上限。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            MinuteSliderRow(
                title: "工作日娱乐上限",
                subtitle: "周一到周五，所有娱乐和游戏 APP 合计最多可用时间",
                minutes: $weekdayEntertainmentLimitMinutes,
                range: 0...180,
                step: 5,
                iconName: "calendar",
                tint: .orange
            )

            MinuteSliderRow(
                title: "周末娱乐上限",
                subtitle: "周六、周日，所有娱乐和游戏 APP 合计最多可用时间",
                minutes: $weekendEntertainmentLimitMinutes,
                range: 0...360,
                step: 5,
                iconName: "calendar.badge.clock",
                tint: .purple
            )
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

    private var entertainmentWindowCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock.badge.checkmark.fill")
                    .foregroundStyle(.teal)

                Text("娱乐 APP 可用时段")
                    .font(.headline)
            }

            Text("点击时间可用轮盘调整。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HourWheelRow(title: "工作日开始", subtitle: "周一到周五", hour: $entertainmentWeekdayStartHour, iconName: "sun.max.fill", tint: .teal)
            HourWheelRow(title: "工作日结束", subtitle: "到点自动锁定", hour: $entertainmentWeekdayEndHour, iconName: "moon.fill", tint: .teal)
            HourWheelRow(title: "周末开始", subtitle: "周六、周日", hour: $entertainmentWeekendStartHour, iconName: "sun.max.fill", tint: .cyan)
            HourWheelRow(title: "周末结束", subtitle: "到点自动锁定", hour: $entertainmentWeekendEndHour, iconName: "moon.fill", tint: .cyan)

            TimeWindowSummaryRow(
                appName: "系统选择的娱乐 APP",
                category: "由家长在系统选择器中指定",
                weekdayWindow: entertainmentWindowText(start: entertainmentWeekdayStartHour, end: entertainmentWeekdayEndHour),
                weekendWindow: entertainmentWindowText(start: entertainmentWeekendStartHour, end: entertainmentWeekendEndHour),
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
            TaskRuleEditor(taskLetter: "A", note: $mathNote, weekdays: $taskAWeekdays, minutes: $mathMinutes, rewardMinutes: $taskARewardMinutes, color: .blue) {
                taskSelectedAppLabel(0)
            } selectAppAction: {
                #if canImport(FamilyControls)
                isTaskAPickerPresented = true
                #endif
            }
            if enabledTaskCount >= 2 {
                TaskRuleEditor(taskLetter: "B", note: $englishNote, weekdays: $taskBWeekdays, minutes: $englishMinutes, rewardMinutes: $taskBRewardMinutes, color: .purple) {
                    taskSelectedAppLabel(1)
                } selectAppAction: {
                    #if canImport(FamilyControls)
                    isTaskBPickerPresented = true
                    #endif
                }
            }
            if enabledTaskCount >= 3 {
                TaskRuleEditor(taskLetter: "C", note: $readingNote, weekdays: $taskCWeekdays, minutes: $readingMinutes, rewardMinutes: $taskCRewardMinutes, color: .orange) {
                    taskSelectedAppLabel(2)
                } selectAppAction: {
                    #if canImport(FamilyControls)
                    isTaskCPickerPresented = true
                    #endif
                }
            }
            if enabledTaskCount >= 4 {
                TaskRuleEditor(taskLetter: "D", note: $taskDNote, weekdays: $taskDWeekdays, minutes: $taskDMinutes, rewardMinutes: $taskDRewardMinutes, color: .teal) {
                    taskSelectedAppLabel(3)
                } selectAppAction: {
                    #if canImport(FamilyControls)
                    isTaskDPickerPresented = true
                    #endif
                }
            }
            if enabledTaskCount >= 5 {
                TaskRuleEditor(taskLetter: "E", note: $taskENote, weekdays: $taskEWeekdays, minutes: $taskEMinutes, rewardMinutes: $taskERewardMinutes, color: .cyan) {
                    taskSelectedAppLabel(4)
                } selectAppAction: {
                    #if canImport(FamilyControls)
                    isTaskEPickerPresented = true
                    #endif
                }
            }
            if enabledTaskCount >= 6 {
                TaskRuleEditor(taskLetter: "F", note: $taskFNote, weekdays: $taskFWeekdays, minutes: $taskFMinutes, rewardMinutes: $taskFRewardMinutes, color: .indigo) {
                    taskSelectedAppLabel(5)
                } selectAppAction: {
                    #if canImport(FamilyControls)
                    isTaskFPickerPresented = true
                    #endif
                }
            }
            if enabledTaskCount >= 7 {
                TaskRuleEditor(taskLetter: "G", note: $taskGNote, weekdays: $taskGWeekdays, minutes: $taskGMinutes, rewardMinutes: $taskGRewardMinutes, color: .pink) {
                    taskSelectedAppLabel(6)
                } selectAppAction: {
                    #if canImport(FamilyControls)
                    isTaskGPickerPresented = true
                    #endif
                }
            }
            if enabledTaskCount >= 8 {
                TaskRuleEditor(taskLetter: "H", note: $taskHNote, weekdays: $taskHWeekdays, minutes: $taskHMinutes, rewardMinutes: $taskHRewardMinutes, color: .brown) {
                    taskSelectedAppLabel(7)
                } selectAppAction: {
                    #if canImport(FamilyControls)
                    isTaskHPickerPresented = true
                    #endif
                }
            }
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

                Text("每日可获得娱乐时间上限")
                    .font(.headline)
            }

            Text("完成学习或运动任务后会获得娱乐时间，但每天最多只能获得这么多分钟。单个任务奖励仍在每个任务下方设置。")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            MinuteWheelRow(title: "每日最多可获得", subtitle: "今天最多能赚多少娱乐时间", minutes: $dailyEarnCapMinutes, range: 10...180, step: 5, iconName: "speedometer", tint: .orange)

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
        let effectiveLimit = todayAvailableEntertainmentMinutes
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
            resetParentAutoLockTimer()
        } else {
            parentPINError = AppText.t("incorrect_pin")
        }
    }

    private func lockParentArea() {
        guard isParentUnlocked else { return }
        isParentUnlocked = false
        parentPINInput = ""
        parentPINError = ""
    }

    private func resetParentAutoLockTimer() {
        guard isParentUnlocked && selectedTab == 1 else { return }
        parentLastActivityDate = Date()
    }

    private func autoLockParentAreaIfNeeded() {
        guard isParentUnlocked && selectedTab == 1 else { return }
        if Date().timeIntervalSince(parentLastActivityDate) >= parentAutoLockSeconds {
            lockParentArea()
        }
    }

    private func saveNewParentPIN() {
        let trimmedPIN = newParentPIN.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedPIN.count >= 4 else { return }

        parentPIN = trimmedPIN
        newParentPIN = ""
    }

    private func submitFeedback() {
        let trimmedMessage = feedbackMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }

        feedbackStatusMessage = feedbackScreenshotAttached ? "已收到反馈和截图，感谢。" : "已收到反馈，感谢。"
        feedbackMessage = ""
        feedbackContact = ""
        feedbackScreenshotItem = nil
        feedbackScreenshotAttached = false
    }

    private func saveTodayRecord() {
        var records = decodeRecords()
        let todayRecord = DailyRecord(
            dateKey: todayKey,
            mathCompleted: mathCompleted,
            englishCompleted: englishCompleted,
            readingCompleted: readingCompleted,
            completedCount: completedTodayTaskCount,
            gameTimeMinutes: gameTimeMinutes,
            totalTaskCount: totalTodayTaskCount,
            completionPercent: todayCompletionPercent,
            scoreOneToFive: todayScoreOneToFive,
            dailySummary: dailySummaryText,
            weeklyCompletionPercent: weeklyCompletionPercent,
            weeklyScoreOneToFive: weeklyScoreOneToFive,
            weeklyComparePercent: weeklyComparePercent,
            weeklySummary: weeklySummaryText
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
