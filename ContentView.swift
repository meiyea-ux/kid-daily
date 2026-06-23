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

#if canImport(Speech) && canImport(AVFoundation)
import Speech
import AVFoundation
#endif

enum AppText {
    static func t(_ key: String, _ args: CVarArg...) -> String {
        let language = currentLanguageKey()
        let format = translations[language]?[key] ?? translations["en"]?[key] ?? key
        guard !args.isEmpty else { return format }
        return String(format: format, locale: Locale(identifier: language), arguments: args)
    }

    static func currentLanguageKey() -> String {
        let preferred = Locale.preferredLanguages.first?.lowercased() ?? "en"

        if preferred.hasPrefix("zh-hans") || preferred.hasPrefix("zh-cn") || preferred.hasPrefix("zh-sg") {
            return "zh-Hans"
        }

        if preferred.hasPrefix("zh-hant") || preferred.hasPrefix("zh-tw") || preferred.hasPrefix("zh-hk") || preferred.hasPrefix("zh-mo") {
            return "zh-Hant"
        }

        if preferred.hasPrefix("ja") { return "ja" }
        if preferred.hasPrefix("ko") { return "ko" }
        if preferred.hasPrefix("es") { return "es" }
        return "en"
    }

    private static let translations: [String: [String: String]] = [
        "en": [
            "app_name": "KidDaily",
            "tab_today": "Today",
            "tab_words": "Words",
            "tab_move": "Move",
            "tab_records": "Records",
            "tab_parent": "Parent",
            "nav_records": "Daily Records",
            "parent_dashboard": "Parent Dashboard",
            "lock": "Lock",
            "parent_subtitle": "Review learning consistency and prepare future screen time controls.",
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
            "today_message": "Good job, %@. Finish learning tasks to earn game time.",
            "continuous_learning": "Continuous Learning",
            "day_streak": "%d day streak",
            "game_time_unlocked": "Game Time Unlocked: %d min",
            "game_time_locked": "Game Time Locked",
            "min_earned": "min earned",
            "completed_count": "Completed: %d / %d",
            "daily_progress": "Daily Progress",
            "progress_rule": "Game time is earned automatically: %d minutes per completed task.",
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
            "unavailable_build": "FamilyControls is unavailable in this build."
        ],
        "zh-Hans": [
            "app_name": "KidDaily",
            "tab_today": "今日",
            "tab_words": "单词",
            "tab_move": "运动",
            "tab_records": "记录",
            "tab_parent": "家长",
            "nav_records": "每日记录",
            "parent_dashboard": "家长控制台",
            "lock": "锁定",
            "parent_subtitle": "查看学习连续性，并准备屏幕使用时间控制。",
            "streak": "连续学习",
            "days": "天",
            "game_time": "娱乐时间",
            "min_in_7_days": "近7天分钟",
            "screen_time_api": "屏幕使用时间",
            "authorization": "授权状态：%@",
            "current_earned_limit": "当前可用时间：%d 分钟",
            "request_screen_time_permission": "申请屏幕使用时间权限",
            "select_apps_categories": "选择应用和类别",
            "apply_earned_limit": "应用已获得时间限制",
            "clear_screen_time_restrictions": "清除屏幕使用限制",
            "setup_screen_time": "设置屏幕使用时间",
            "setup_screen_time_subtitle": "Apple 屏幕使用时间集成准备清单。",
            "request_permission": "申请权限",
            "request_permission_desc": "在这台 iPhone 上申请屏幕使用时间权限。",
            "select_apps": "选择应用",
            "select_apps_desc": "选择由 KidDaily 管理的游戏或应用。",
            "apply_limit": "应用限制",
            "apply_limit_desc": "根据已获得的娱乐时间应用每日限制。",
            "monitor_usage": "查看使用",
            "monitor_usage_desc": "读取活动报告并更新家长控制台。",
            "today_learning": "今日学习",
            "today_message": "%@ 做得很好。完成学习任务即可获得娱乐时间。",
            "continuous_learning": "连续学习",
            "day_streak": "已连续 %d 天",
            "game_time_unlocked": "已解锁娱乐时间：%d 分钟",
            "game_time_locked": "娱乐时间未解锁",
            "min_earned": "分钟已获得",
            "completed_count": "已完成：%d / %d",
            "daily_progress": "每日进度",
            "progress_rule": "娱乐时间自动获得：每完成一个任务奖励 %d 分钟。",
            "math": "数学",
            "english": "英语",
            "reading": "阅读",
            "date": "日期",
            "completed": "完成",
            "record_detail": "记录详情",
            "done": "已完成",
            "not_done": "未完成",
            "parent_area_locked": "家长区已锁定",
            "parent_pin_prompt": "请输入家长 PIN 查看记录和设置。",
            "parent_pin": "家长 PIN",
            "unlock_parent_area": "解锁家长区",
            "movement_check": "运动检查",
            "movement_subtitle": "同步 iPhone 健康和 Apple Watch 的运动结果。",
            "history": "历史",
            "no_records": "暂无每日记录",
            "no_records_desc": "完成或重置今日任务后会生成记录。",
            "reset_today": "重置今日",
            "summary": "摘要",
            "tasks": "任务",
            "steps": "步数",
            "today": "今日",
            "exercise": "运动",
            "min_today": "今日分钟",
            "active_energy": "活动能量",
            "latest_workout": "最近训练",
            "health_data_sync": "健康数据同步",
            "health_sync_desc": "读取今日步数、Apple 运动分钟、活动能量和最近一次训练。Apple Watch 训练同步到 iPhone 健康后会显示在这里。",
            "request_health_permission": "申请健康权限",
            "syncing": "同步中...",
            "sync_health_data": "同步健康数据",
            "current_streak": "当前连续",
            "last_7_days": "最近 7 天",
            "perfect_days": "满分天数",
            "movement_results": "运动结果",
            "movement_today": "今日：%d 步，运动 %d 分钟，%d 千卡。",
            "latest_workout_line": "最近训练：%@，%d 分钟。",
            "refresh_movement_data": "刷新运动数据",
            "web_parent_sync": "网页家长端同步",
            "web_parent_sync_desc": "输入家长网页控制台生成的绑定码。今日学习和娱乐时间会上传，方便远程查看。",
            "pairing_code": "绑定码",
            "sync_remote_settings": "同步远程设置",
            "uploading": "上传中...",
            "upload_today_record": "上传今日记录",
            "auth_failed": "授权失败：%@",
            "opening_picker": "正在打开应用和类别选择器...",
            "picker_unavailable": "此版本无法使用应用选择器。",
            "status_not_requested": "尚未申请屏幕使用时间权限。",
            "status_denied": "屏幕使用时间权限已被拒绝。",
            "status_approved": "屏幕使用时间权限已批准。",
            "status_unknown": "未知屏幕使用时间授权状态。",
            "requesting_screen_time": "正在申请屏幕使用时间权限...",
            "approve_before_limit": "请先批准屏幕使用时间权限再应用限制。",
            "select_before_limit": "请先选择应用或类别再应用限制。",
            "limit_applied": "已对所选应用应用屏幕使用限制。可用时间：%d 分钟。",
            "limit_zero": "当前未获得娱乐时间，已限制所选应用和类别。",
            "restrictions_cleared": "屏幕使用限制已清除。",
            "unavailable_build": "此版本无法使用 FamilyControls。"
        ],
        "zh-Hant": [
            "app_name": "KidDaily",
            "tab_today": "今日",
            "tab_words": "單字",
            "tab_move": "運動",
            "tab_records": "記錄",
            "tab_parent": "家長",
            "nav_records": "每日記錄",
            "parent_dashboard": "家長控制台",
            "lock": "鎖定",
            "parent_subtitle": "查看學習連續性，並準備螢幕使用時間控制。",
            "streak": "連續學習",
            "days": "天",
            "game_time": "娛樂時間",
            "min_in_7_days": "近7天分鐘",
            "screen_time_api": "螢幕使用時間",
            "authorization": "授權狀態：%@",
            "current_earned_limit": "目前可用時間：%d 分鐘",
            "request_screen_time_permission": "申請螢幕使用時間權限",
            "select_apps_categories": "選擇 App 和類別",
            "apply_earned_limit": "套用已獲得時間限制",
            "clear_screen_time_restrictions": "清除螢幕使用限制",
            "setup_screen_time": "設定螢幕使用時間",
            "setup_screen_time_subtitle": "Apple 螢幕使用時間整合準備清單。",
            "request_permission": "申請權限",
            "request_permission_desc": "在這台 iPhone 上申請螢幕使用時間權限。",
            "select_apps": "選擇 App",
            "select_apps_desc": "選擇由 KidDaily 管理的遊戲或 App。",
            "apply_limit": "套用限制",
            "apply_limit_desc": "根據已獲得的娛樂時間套用每日限制。",
            "monitor_usage": "查看使用",
            "monitor_usage_desc": "讀取活動報告並更新家長控制台。",
            "today_learning": "今日學習",
            "today_message": "%@ 做得很好。完成學習任務即可獲得娛樂時間。",
            "continuous_learning": "連續學習",
            "day_streak": "已連續 %d 天",
            "game_time_unlocked": "已解鎖娛樂時間：%d 分鐘",
            "game_time_locked": "娛樂時間未解鎖",
            "min_earned": "分鐘已獲得",
            "completed_count": "已完成：%d / %d",
            "daily_progress": "每日進度",
            "progress_rule": "娛樂時間自動獲得：每完成一個任務獎勵 %d 分鐘。",
            "math": "數學",
            "english": "英文",
            "reading": "閱讀",
            "date": "日期",
            "completed": "完成",
            "record_detail": "記錄詳情",
            "done": "已完成",
            "not_done": "未完成",
            "parent_area_locked": "家長區已鎖定",
            "parent_pin_prompt": "請輸入家長 PIN 查看記錄和設定。",
            "parent_pin": "家長 PIN",
            "unlock_parent_area": "解鎖家長區",
            "movement_check": "運動檢查",
            "movement_subtitle": "同步 iPhone 健康和 Apple Watch 的運動結果。",
            "history": "歷史",
            "no_records": "暫無每日記錄",
            "no_records_desc": "完成或重置今日任務後會生成記錄。",
            "reset_today": "重置今日",
            "summary": "摘要",
            "tasks": "任務",
            "steps": "步數",
            "today": "今日",
            "exercise": "運動",
            "min_today": "今日分鐘",
            "active_energy": "活動能量",
            "latest_workout": "最近訓練",
            "health_data_sync": "健康資料同步",
            "health_sync_desc": "讀取今日步數、Apple 運動分鐘、活動能量和最近一次訓練。Apple Watch 訓練同步到 iPhone 健康後會顯示在這裡。",
            "request_health_permission": "申請健康權限",
            "syncing": "同步中...",
            "sync_health_data": "同步健康資料",
            "current_streak": "目前連續",
            "last_7_days": "最近 7 天",
            "perfect_days": "滿分天數",
            "movement_results": "運動結果",
            "movement_today": "今日：%d 步，運動 %d 分鐘，%d 千卡。",
            "latest_workout_line": "最近訓練：%@，%d 分鐘。",
            "refresh_movement_data": "重新整理運動資料",
            "web_parent_sync": "網頁家長端同步",
            "web_parent_sync_desc": "輸入家長網頁控制台生成的綁定碼。今日學習和娛樂時間會上傳，方便遠端查看。",
            "pairing_code": "綁定碼",
            "sync_remote_settings": "同步遠端設定",
            "uploading": "上傳中...",
            "upload_today_record": "上傳今日記錄",
            "auth_failed": "授權失敗：%@",
            "opening_picker": "正在開啟 App 和類別選擇器...",
            "picker_unavailable": "此版本無法使用 App 選擇器。",
            "status_not_requested": "尚未申請螢幕使用時間權限。",
            "status_denied": "螢幕使用時間權限已被拒絕。",
            "status_approved": "螢幕使用時間權限已批准。",
            "status_unknown": "未知螢幕使用時間授權狀態。",
            "requesting_screen_time": "正在申請螢幕使用時間權限...",
            "approve_before_limit": "請先批准螢幕使用時間權限再套用限制。",
            "select_before_limit": "請先選擇 App 或類別再套用限制。",
            "limit_applied": "已對所選 App 套用螢幕使用限制。可用時間：%d 分鐘。",
            "limit_zero": "目前未獲得娛樂時間，已限制所選 App 和類別。",
            "restrictions_cleared": "螢幕使用限制已清除。",
            "unavailable_build": "此版本無法使用 FamilyControls。"
        ],
        "ja": [
            "app_name": "KidDaily",
            "tab_today": "今日",
            "tab_words": "単語",
            "tab_move": "運動",
            "tab_records": "記録",
            "tab_parent": "保護者",
            "nav_records": "日次記録",
            "parent_dashboard": "保護者ダッシュボード",
            "lock": "ロック",
            "parent_subtitle": "学習の継続状況を確認し、スクリーンタイム管理を準備します。",
            "streak": "連続学習",
            "days": "日",
            "game_time": "娯楽時間",
            "min_in_7_days": "7日間の分数",
            "screen_time_api": "スクリーンタイム",
            "authorization": "許可状態：%@",
            "current_earned_limit": "現在の利用可能時間：%d分",
            "request_screen_time_permission": "スクリーンタイム権限を要求",
            "select_apps_categories": "Appとカテゴリを選択",
            "apply_earned_limit": "獲得時間の制限を適用",
            "clear_screen_time_restrictions": "スクリーンタイム制限を解除",
            "setup_screen_time": "スクリーンタイム設定",
            "setup_screen_time_subtitle": "Apple スクリーンタイム連携の準備リスト。",
            "request_permission": "権限を要求",
            "request_permission_desc": "この iPhone でスクリーンタイム権限を要求します。",
            "select_apps": "Appを選択",
            "select_apps_desc": "KidDaily が管理するゲームや App を選びます。",
            "apply_limit": "制限を適用",
            "apply_limit_desc": "獲得した娯楽時間に基づき毎日の制限を適用します。",
            "monitor_usage": "利用を確認",
            "monitor_usage_desc": "アクティビティレポートを読み取り保護者画面を更新します。",
            "today_learning": "今日の学習",
            "today_message": "%@、よくできました。学習タスクを終えると娯楽時間を獲得できます。",
            "continuous_learning": "連続学習",
            "day_streak": "%d日連続",
            "game_time_unlocked": "娯楽時間を解除：%d分",
            "game_time_locked": "娯楽時間はロック中",
            "min_earned": "分獲得",
            "completed_count": "完了：%d / %d",
            "daily_progress": "今日の進捗",
            "progress_rule": "娯楽時間は自動付与：タスク1つにつき%d分。",
            "math": "算数",
            "english": "英語",
            "reading": "読書",
            "date": "日付",
            "completed": "完了",
            "record_detail": "記録詳細",
            "done": "完了",
            "not_done": "未完了",
            "parent_area_locked": "保護者エリアはロック中",
            "parent_pin_prompt": "記録と設定を見るには保護者PINを入力してください。",
            "parent_pin": "保護者PIN",
            "unlock_parent_area": "保護者エリアを解除",
            "movement_check": "運動チェック",
            "movement_subtitle": "iPhoneヘルスケアとApple Watchの運動結果を同期します。",
            "history": "履歴",
            "no_records": "記録はまだありません",
            "no_records_desc": "今日のタスクを完了またはリセットすると記録が作成されます。",
            "reset_today": "今日をリセット",
            "summary": "概要",
            "tasks": "タスク",
            "steps": "歩数",
            "today": "今日",
            "exercise": "運動",
            "min_today": "今日の分",
            "active_energy": "活動エネルギー",
            "latest_workout": "最新ワークアウト",
            "health_data_sync": "ヘルスケア同期",
            "health_sync_desc": "今日の歩数、Appleの運動時間、活動エネルギー、最新ワークアウトを読み取ります。Apple WatchのワークアウトはiPhoneヘルスケアに同期後ここに表示されます。",
            "request_health_permission": "ヘルスケア権限を要求",
            "syncing": "同期中...",
            "sync_health_data": "ヘルスケアを同期",
            "current_streak": "現在の連続",
            "last_7_days": "過去7日",
            "perfect_days": "達成日",
            "movement_results": "運動結果",
            "movement_today": "今日：%d歩、運動%d分、%d kcal。",
            "latest_workout_line": "最新ワークアウト：%@、%d分。",
            "refresh_movement_data": "運動データを更新",
            "web_parent_sync": "Web保護者同期",
            "web_parent_sync_desc": "保護者Webダッシュボードで生成されたペアリングコードを入力します。今日の学習と娯楽時間をアップロードしてリモート確認できます。",
            "pairing_code": "ペアリングコード",
            "sync_remote_settings": "リモート設定を同期",
            "uploading": "アップロード中...",
            "upload_today_record": "今日の記録をアップロード",
            "auth_failed": "認証失敗：%@",
            "opening_picker": "Appとカテゴリ選択画面を開いています...",
            "picker_unavailable": "このビルドではApp選択画面を利用できません。",
            "status_not_requested": "スクリーンタイム権限はまだ要求されていません。",
            "status_denied": "スクリーンタイム権限が拒否されました。",
            "status_approved": "スクリーンタイム権限が承認されました。",
            "status_unknown": "不明なスクリーンタイム権限状態です。",
            "requesting_screen_time": "スクリーンタイム権限を要求しています...",
            "approve_before_limit": "制限を適用する前にスクリーンタイム権限を承認してください。",
            "select_before_limit": "制限を適用する前にAppまたはカテゴリを選択してください。",
            "limit_applied": "選択したAppに制限を適用しました。利用可能時間：%d分。",
            "limit_zero": "獲得時間がありません。選択したAppとカテゴリを制限しました。",
            "restrictions_cleared": "スクリーンタイム制限を解除しました。",
            "unavailable_build": "このビルドではFamilyControlsを利用できません。"
        ],
        "ko": [
            "app_name": "KidDaily",
            "tab_today": "오늘",
            "tab_words": "단어",
            "tab_move": "운동",
            "tab_records": "기록",
            "tab_parent": "부모",
            "nav_records": "일일 기록",
            "parent_dashboard": "부모 대시보드",
            "lock": "잠금",
            "parent_subtitle": "학습 지속성을 확인하고 스크린 타임 제어를 준비합니다.",
            "streak": "연속 학습",
            "days": "일",
            "game_time": "오락 시간",
            "min_in_7_days": "최근 7일 분",
            "screen_time_api": "스크린 타임",
            "authorization": "권한 상태: %@",
            "current_earned_limit": "현재 획득 시간: %d분",
            "request_screen_time_permission": "스크린 타임 권한 요청",
            "select_apps_categories": "앱 및 카테고리 선택",
            "apply_earned_limit": "획득 시간 제한 적용",
            "clear_screen_time_restrictions": "스크린 타임 제한 해제",
            "setup_screen_time": "스크린 타임 설정",
            "setup_screen_time_subtitle": "Apple 스크린 타임 연동 준비 목록.",
            "request_permission": "권한 요청",
            "request_permission_desc": "이 iPhone에서 스크린 타임 접근을 요청합니다.",
            "select_apps": "앱 선택",
            "select_apps_desc": "KidDaily가 관리할 게임이나 앱을 선택합니다.",
            "apply_limit": "제한 적용",
            "apply_limit_desc": "획득한 오락 시간에 따라 일일 제한을 적용합니다.",
            "monitor_usage": "사용량 확인",
            "monitor_usage_desc": "활동 보고서를 읽고 부모 대시보드를 업데이트합니다.",
            "today_learning": "오늘의 학습",
            "today_message": "%@, 잘했어요. 학습 과제를 끝내면 오락 시간을 얻을 수 있어요.",
            "continuous_learning": "연속 학습",
            "day_streak": "%d일 연속",
            "game_time_unlocked": "오락 시간 잠금 해제: %d분",
            "game_time_locked": "오락 시간 잠김",
            "min_earned": "분 획득",
            "completed_count": "완료: %d / %d",
            "daily_progress": "일일 진행",
            "progress_rule": "오락 시간은 자동 적립됩니다: 과제당 %d분.",
            "math": "수학",
            "english": "영어",
            "reading": "읽기",
            "date": "날짜",
            "completed": "완료",
            "record_detail": "기록 상세",
            "done": "완료",
            "not_done": "미완료",
            "parent_area_locked": "부모 영역 잠김",
            "parent_pin_prompt": "기록과 설정을 보려면 부모 PIN을 입력하세요.",
            "parent_pin": "부모 PIN",
            "unlock_parent_area": "부모 영역 잠금 해제",
            "movement_check": "운동 확인",
            "movement_subtitle": "iPhone 건강 및 Apple Watch 운동 결과를 동기화합니다.",
            "history": "기록",
            "no_records": "아직 일일 기록이 없습니다",
            "no_records_desc": "오늘 과제를 완료하거나 초기화하면 기록이 생성됩니다.",
            "reset_today": "오늘 초기화",
            "summary": "요약",
            "tasks": "과제",
            "steps": "걸음",
            "today": "오늘",
            "exercise": "운동",
            "min_today": "오늘 분",
            "active_energy": "활동 에너지",
            "latest_workout": "최근 운동",
            "health_data_sync": "건강 데이터 동기화",
            "health_sync_desc": "오늘의 걸음 수, Apple 운동 시간, 활동 에너지, 최근 운동을 읽습니다. Apple Watch 운동은 iPhone 건강 앱에 동기화된 후 여기에 표시됩니다.",
            "request_health_permission": "건강 권한 요청",
            "syncing": "동기화 중...",
            "sync_health_data": "건강 데이터 동기화",
            "current_streak": "현재 연속",
            "last_7_days": "최근 7일",
            "perfect_days": "완료일",
            "movement_results": "운동 결과",
            "movement_today": "오늘: %d걸음, 운동 %d분, %d kcal.",
            "latest_workout_line": "최근 운동: %@, %d분.",
            "refresh_movement_data": "운동 데이터 새로고침",
            "web_parent_sync": "웹 부모 동기화",
            "web_parent_sync_desc": "부모 웹 대시보드에서 생성한 페어링 코드를 입력하세요. 오늘의 학습 및 오락 시간이 업로드되어 원격으로 확인할 수 있습니다.",
            "pairing_code": "페어링 코드",
            "sync_remote_settings": "원격 설정 동기화",
            "uploading": "업로드 중...",
            "upload_today_record": "오늘 기록 업로드",
            "auth_failed": "권한 실패: %@",
            "opening_picker": "앱 및 카테고리 선택기를 여는 중...",
            "picker_unavailable": "이 빌드에서는 앱 선택기를 사용할 수 없습니다.",
            "status_not_requested": "스크린 타임 권한을 아직 요청하지 않았습니다.",
            "status_denied": "스크린 타임 권한이 거부되었습니다.",
            "status_approved": "스크린 타임 권한이 승인되었습니다.",
            "status_unknown": "알 수 없는 스크린 타임 권한 상태입니다.",
            "requesting_screen_time": "스크린 타임 권한 요청 중...",
            "approve_before_limit": "제한을 적용하기 전에 스크린 타임 권한을 승인하세요.",
            "select_before_limit": "제한을 적용하기 전에 앱 또는 카테고리를 선택하세요.",
            "limit_applied": "선택한 앱에 제한을 적용했습니다. 획득 시간: %d분.",
            "limit_zero": "획득한 오락 시간이 없습니다. 선택한 앱과 카테고리가 제한되었습니다.",
            "restrictions_cleared": "스크린 타임 제한이 해제되었습니다.",
            "unavailable_build": "이 빌드에서는 FamilyControls를 사용할 수 없습니다."
        ],
        "es": [
            "app_name": "KidDaily",
            "tab_today": "Hoy",
            "tab_words": "Palabras",
            "tab_move": "Movimiento",
            "tab_records": "Registros",
            "tab_parent": "Padres",
            "nav_records": "Registros diarios",
            "parent_dashboard": "Panel para padres",
            "lock": "Bloquear",
            "parent_subtitle": "Revisa la constancia de aprendizaje y prepara controles de tiempo de pantalla.",
            "streak": "Racha",
            "days": "días",
            "game_time": "Tiempo de juego",
            "min_in_7_days": "min en 7 días",
            "screen_time_api": "Tiempo de pantalla",
            "authorization": "Autorización: %@",
            "current_earned_limit": "Límite ganado actual: %d min",
            "request_screen_time_permission": "Solicitar permiso de Tiempo en pantalla",
            "select_apps_categories": "Seleccionar apps y categorías",
            "apply_earned_limit": "Aplicar límite ganado",
            "clear_screen_time_restrictions": "Borrar restricciones",
            "setup_screen_time": "Configurar Tiempo en pantalla",
            "setup_screen_time_subtitle": "Lista de preparación para la integración con Apple Screen Time.",
            "request_permission": "Solicitar permiso",
            "request_permission_desc": "Solicitar acceso a Tiempo en pantalla en este iPhone.",
            "select_apps": "Seleccionar apps",
            "select_apps_desc": "Elige qué juegos o apps administra KidDaily.",
            "apply_limit": "Aplicar límite",
            "apply_limit_desc": "Usa el tiempo ganado para aplicar un límite diario.",
            "monitor_usage": "Monitorear uso",
            "monitor_usage_desc": "Lee reportes de actividad y actualiza el panel de padres.",
            "today_learning": "Aprendizaje de hoy",
            "today_message": "Buen trabajo, %@. Termina las tareas para ganar tiempo de juego.",
            "continuous_learning": "Aprendizaje continuo",
            "day_streak": "racha de %d días",
            "game_time_unlocked": "Tiempo desbloqueado: %d min",
            "game_time_locked": "Tiempo de juego bloqueado",
            "min_earned": "min ganados",
            "completed_count": "Completado: %d / %d",
            "daily_progress": "Progreso diario",
            "progress_rule": "El tiempo se gana automáticamente: %d minutos por tarea completada.",
            "math": "Matemáticas",
            "english": "Inglés",
            "reading": "Lectura",
            "date": "Fecha",
            "completed": "Completado",
            "record_detail": "Detalle del registro",
            "done": "Hecho",
            "not_done": "Pendiente",
            "parent_area_locked": "Área de padres bloqueada",
            "parent_pin_prompt": "Ingresa el PIN de padres para ver registros y ajustes.",
            "parent_pin": "PIN de padres",
            "unlock_parent_area": "Desbloquear área de padres",
            "movement_check": "Revisión de movimiento",
            "movement_subtitle": "Sincroniza ejercicio desde Salud de iPhone y Apple Watch.",
            "history": "Historial",
            "no_records": "Aún no hay registros diarios",
            "no_records_desc": "Completa o reinicia las tareas de hoy para crear un registro.",
            "reset_today": "Reiniciar hoy",
            "summary": "Resumen",
            "tasks": "Tareas",
            "steps": "Pasos",
            "today": "hoy",
            "exercise": "Ejercicio",
            "min_today": "min hoy",
            "active_energy": "Energía activa",
            "latest_workout": "Último entrenamiento",
            "health_data_sync": "Sincronización de salud",
            "health_sync_desc": "Lee los pasos de hoy, minutos de ejercicio de Apple, energía activa y último entrenamiento. Los entrenamientos del Apple Watch aparecerán aquí después de sincronizarse con Salud en el iPhone.",
            "request_health_permission": "Solicitar permiso de Salud",
            "syncing": "Sincronizando...",
            "sync_health_data": "Sincronizar datos de Salud",
            "current_streak": "Racha actual",
            "last_7_days": "Últimos 7 días",
            "perfect_days": "días completos",
            "movement_results": "Resultados de movimiento",
            "movement_today": "Hoy: %d pasos, %d min de ejercicio, %d kcal.",
            "latest_workout_line": "Último entrenamiento: %@, %d min.",
            "refresh_movement_data": "Actualizar movimiento",
            "web_parent_sync": "Sincronización web para padres",
            "web_parent_sync_desc": "Ingresa el código generado en el panel web para padres. El aprendizaje y el tiempo de juego de hoy se subirán para monitoreo remoto.",
            "pairing_code": "Código de enlace",
            "sync_remote_settings": "Sincronizar ajustes remotos",
            "uploading": "Subiendo...",
            "upload_today_record": "Subir registro de hoy",
            "auth_failed": "Autorización fallida: %@",
            "opening_picker": "Abriendo selector de apps y categorías...",
            "picker_unavailable": "FamilyActivityPicker no está disponible en esta compilación.",
            "status_not_requested": "El permiso de Tiempo en pantalla aún no se solicitó.",
            "status_denied": "El permiso de Tiempo en pantalla fue denegado.",
            "status_approved": "El permiso de Tiempo en pantalla está aprobado.",
            "status_unknown": "Estado de autorización desconocido.",
            "requesting_screen_time": "Solicitando permiso de Tiempo en pantalla...",
            "approve_before_limit": "Aprueba Tiempo en pantalla antes de aplicar límites.",
            "select_before_limit": "Selecciona apps o categorías antes de aplicar límites.",
            "limit_applied": "Restricciones aplicadas a las apps seleccionadas. Límite ganado: %d min.",
            "limit_zero": "No hay tiempo ganado. Las apps y categorías seleccionadas ahora están restringidas.",
            "restrictions_cleared": "Restricciones de Tiempo en pantalla borradas.",
            "unavailable_build": "FamilyControls no está disponible en esta compilación."
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
        let names: [String: [ScreenTimeAuthorizationState: String]] = [
            "en": [.unavailable: "Unavailable", .notDetermined: "Not Determined", .denied: "Denied", .approved: "Approved"],
            "zh-Hans": [.unavailable: "不可用", .notDetermined: "未决定", .denied: "已拒绝", .approved: "已批准"],
            "zh-Hant": [.unavailable: "不可用", .notDetermined: "尚未決定", .denied: "已拒絕", .approved: "已批准"],
            "ja": [.unavailable: "利用不可", .notDetermined: "未確認", .denied: "拒否", .approved: "承認済み"],
            "ko": [.unavailable: "사용 불가", .notDetermined: "미결정", .denied: "거부됨", .approved: "승인됨"],
            "es": [.unavailable: "No disponible", .notDetermined: "Sin determinar", .denied: "Denegado", .approved: "Aprobado"]
        ]

        return names[AppText.currentLanguageKey()]?[self] ?? names["en"]?[self] ?? rawValue
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
            statusMessage = "Entertainment apps unlocked for \(minutes) earned minutes."
        } else {
            statusMessage = "Entertainment apps are locked until learning or movement goals are completed."
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
final class SpeechRecitationManager: NSObject, ObservableObject {
    @Published var transcript = ""
    @Published var statusMessage = "Tap record and recite the sentence aloud."
    @Published var isRecording = false

    #if canImport(Speech) && canImport(AVFoundation)
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var autoStopTask: Task<Void, Never>?
    #endif

    func startRecording() async {
        #if canImport(Speech) && canImport(AVFoundation)
        guard !isRecording else { return }

        do {
            try await requestPermissions()
            try beginRecognition()
        } catch {
            statusMessage = "Speech recitation failed: \(error.localizedDescription)"
            stopRecording()
        }
        #else
        statusMessage = "Speech recognition is unavailable in this build."
        #endif
    }

    func stopRecording() {
        #if canImport(Speech) && canImport(AVFoundation)
        autoStopTask?.cancel()
        autoStopTask = nil

        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
        statusMessage = transcript.isEmpty ? "Recording stopped. Try reciting again." : "Recording stopped. Compare your sentence below."
        #else
        statusMessage = "Speech recognition is unavailable in this build."
        #endif
    }

    func reset() {
        stopRecording()
        transcript = ""
        statusMessage = "Tap record and recite the sentence aloud."
    }

    #if canImport(Speech) && canImport(AVFoundation)
    private func requestPermissions() async throws {
        let speechStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }

        guard speechStatus == .authorized else {
            throw NSError(domain: "KidDailySpeech", code: 1, userInfo: [NSLocalizedDescriptionKey: "Speech recognition permission was not granted."])
        }

        let microphoneAllowed = await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                continuation.resume(returning: allowed)
            }
        }

        guard microphoneAllowed else {
            throw NSError(domain: "KidDailySpeech", code: 2, userInfo: [NSLocalizedDescriptionKey: "Microphone permission was not granted."])
        }
    }

    private func beginRecognition() throws {
        recognitionTask?.cancel()
        recognitionTask = nil
        transcript = ""

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        recognitionRequest = request

        guard let speechRecognizer, speechRecognizer.isAvailable else {
            throw NSError(domain: "KidDailySpeech", code: 3, userInfo: [NSLocalizedDescriptionKey: "English speech recognizer is not available now."])
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        isRecording = true
        statusMessage = "Listening. Recite the sentence clearly."
        autoStopTask?.cancel()
        autoStopTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 60_000_000_000)
            await MainActor.run {
                guard let self, self.isRecording else { return }
                self.statusMessage = "Recording reached 60 seconds and stopped automatically."
                self.stopRecording()
            }
        }

        recognitionTask = speechRecognizer.recognitionTask(with: request) { [weak self] result, error in
            Task { @MainActor in
                guard let self else { return }

                if let result {
                    self.transcript = result.bestTranscription.formattedString
                }

                if error != nil || result?.isFinal == true {
                    self.stopRecording()
                }
            }
        }
    }
    #endif
}

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
    @StateObject private var speechRecitationManager = SpeechRecitationManager()

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
    @AppStorage("wordLevel") private var wordLevel = "Gaokao Core"
    @AppStorage("dailyWordGoal") private var dailyWordGoal = 10
    @AppStorage("customWordList") private var customWordList = ""
    @AppStorage("aiWordPrompt") private var aiWordPrompt = ""
    @AppStorage("wrongWordsData") private var wrongWordsData = ""
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
    @State private var wordQuestionIndex = 0
    @State private var wordCorrectCount = 0
    @State private var wordFeedback = "Choose the correct meaning to pass each word gate."

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
                .navigationTitle(AppText.t("app_name"))
            }
            .tabItem {
                Label(AppText.t("tab_today"), systemImage: "house.fill")
            }

            NavigationStack {
                appBackground {
                    appRulesView
                }
                .navigationTitle("Apps")
            }
            .tabItem {
                Label("Apps", systemImage: "app.badge.checkmark")
            }

            NavigationStack {
                appBackground {
                    movementView
                }
                .navigationTitle(AppText.t("tab_move"))
            }
            .tabItem {
                Label(AppText.t("tab_move"), systemImage: "figure.walk")
            }

            NavigationStack {
                appBackground {
                    recordsView
                }
                .navigationTitle(AppText.t("nav_records"))
            }
            .tabItem {
                Label(AppText.t("tab_records"), systemImage: "calendar")
            }

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
                Text("Learning Unlock")
                    .font(.largeTitle)
                    .bold()

                Text("Entertainment apps stay locked first. Learning app usage earns entertainment minutes.")
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                StatCard(
                    title: "Required",
                    value: "\(requiredLearningAppCount)",
                    subtitle: "study apps",
                    color: .purple,
                    iconName: "checklist"
                )

                StatCard(
                    title: "Earned",
                    value: "\(gameTimeMinutes)",
                    subtitle: "minutes",
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

                Text("App Groups")
                    .font(.headline)
            }

            Text("Choose learning apps to monitor and entertainment apps to lock or unlock. Automatic usage reading needs the DeviceActivity extension in the next Xcode step.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            #if canImport(FamilyControls)
            Button {
                isLearningPickerPresented = true
            } label: {
                Label("Choose Learning Apps", systemImage: "book.closed.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                isEntertainmentPickerPresented = true
            } label: {
                Label("Choose Entertainment Apps", systemImage: "gamecontroller.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            #else
            Text("FamilyControls picker is unavailable in this build.")
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

            Text(AppText.t("authorization", screenTimeManager.authorizationState.displayText))
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
                Label(gameTimeMinutes > 0 ? "Apply Earned Unlock" : "Lock Entertainment Apps", systemImage: gameTimeMinutes > 0 ? "lock.open.fill" : "lock.fill")
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

            sentenceRecitationCard(for: question)
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

    private func sentenceRecitationCard(for question: WordQuestion) -> some View {
        let score = recitationScore(expected: question.example, spoken: speechRecitationManager.transcript)

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "waveform.circle.fill")
                    .foregroundStyle(.blue)

                Text("Sentence Recitation")
                    .font(.headline)

                Spacer()

                Text("\(score)%")
                    .font(.headline)
                    .foregroundStyle(score >= 80 ? .green : .orange)
            }

            Text("Target sentence")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(question.example)
                .font(.headline)

            if !speechRecitationManager.transcript.isEmpty {
                Text("Your speech")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(speechRecitationManager.transcript)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ProgressView(value: Double(score), total: 100)
                    .tint(score >= 80 ? .green : .orange)
            }

            HStack {
                Button {
                    Task {
                        await speechRecitationManager.startRecording()
                    }
                } label: {
                    Label(speechRecitationManager.isRecording ? "Recording..." : "Start Reciting", systemImage: "mic.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(speechRecitationManager.isRecording)

                Button {
                    speechRecitationManager.stopRecording()
                } label: {
                    Label("Stop", systemImage: "stop.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(!speechRecitationManager.isRecording)
            }

            Button {
                speechRecitationManager.reset()
            } label: {
                Label("Clear Speech Result", systemImage: "xmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Text(speechRecitationManager.statusMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 18))
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

                Text("Move Unlock Rule")
                    .font(.headline)
            }

            Text("Window: \(movementStartHour):00-\(movementEndHour):00. Goal: \(movementTargetMinutes) min \(movementActivityType).")
                .font(.subheadline)

            Text("Progress in window: \(movementProgressMinutes) / \(movementTargetMinutes) min. Reward: \(movementRewardMinutesEarned) min.")
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

            Text("Each completed learning app goal earns \(gameMinutesPerTask) entertainment minutes. Movement can add \(movementRewardMinutes) minutes.")
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
                Label("Select Entertainment Apps", systemImage: "gamecontroller.fill")
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

                Text("Learning App Goals")
                    .font(.headline)
            }

            Text("Adjust the expected usage time for each daily learning app.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper("Required study apps: \(requiredLearningAppCount)", value: $requiredLearningAppCount, in: 1...3, step: 1)
            Stepper("Math app: \(mathMinutes) min", value: $mathMinutes, in: 5...180, step: 5)
            Stepper("English app: \(englishMinutes) min", value: $englishMinutes, in: 5...180, step: 5)
            Stepper("Reading app: \(readingMinutes) min", value: $readingMinutes, in: 5...180, step: 5)

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
                Text("Core").tag("Gaokao Core")
                Text("Advanced").tag("Gaokao Advanced")
                Text("Challenge").tag("Gaokao Challenge")
            }
            .pickerStyle(.segmented)

            Stepper("Daily words: \(dailyWordGoal)", value: $dailyWordGoal, in: 5...10, step: 1)

            TextField("Custom words: abandon=放弃=Never abandon your dream.", text: $customWordList, axis: .vertical)
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

    private var parentMovementSettingsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "figure.run.circle.fill")
                    .foregroundStyle(.orange)

                Text("Movement Window")
                    .font(.headline)
            }

            Text("Set the daily activity window and the movement reward.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Stepper("Start: \(movementStartHour):00", value: $movementStartHour, in: 0...23, step: 1)
            Stepper("End: \(movementEndHour):00", value: $movementEndHour, in: 1...24, step: 1)
            Stepper("Goal: \(movementTargetMinutes) min", value: $movementTargetMinutes, in: 5...180, step: 5)
            Stepper("Reward: \(movementRewardMinutes) min", value: $movementRewardMinutes, in: 0...60, step: 5)

            Picker("Activity", selection: $movementActivityType) {
                Text("Workout").tag("Workout")
                Text("Exercise Minutes").tag("Exercise Minutes")
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
        speechRecitationManager.reset()

        if wordChallengeFinished {
            englishCompleted = true
            updateTodayProgress()
        }
    }

    private func resetWordChallenge() {
        wordQuestionIndex = 0
        wordCorrectCount = 0
        wordFeedback = "Choose the correct meaning to pass each word gate."
        speechRecitationManager.reset()
    }

    private func saveWrongWord(_ question: WordQuestion) {
        let entry = "\(question.word): \(question.correctMeaning)"
        var words = wrongWords.filter { $0 != entry }
        words.insert(entry, at: 0)
        wrongWordsData = words.prefix(30).joined(separator: "|")
    }

    private func recitationScore(expected: String, spoken: String) -> Int {
        let expectedWords = normalizedWords(from: expected)
        let spokenWords = Set(normalizedWords(from: spoken))
        guard !expectedWords.isEmpty, !spokenWords.isEmpty else { return 0 }

        let matchedCount = expectedWords.filter { spokenWords.contains($0) }.count
        return Int((Double(matchedCount) / Double(expectedWords.count) * 100).rounded())
    }

    private func normalizedWords(from text: String) -> [String] {
        text
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
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
                let parts = rawItem.split(separator: "=", maxSplits: 2).map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                guard parts.count >= 2, !parts[0].isEmpty, !parts[1].isEmpty else {
                    return nil
                }

                let sentence = parts.count >= 3 && !parts[2].isEmpty ? parts[2] : "Please recite a sentence with \(parts[0])."

                return WordQuestion(
                    word: parts[0],
                    pronunciation: "custom",
                    correctMeaning: parts[1],
                    options: makeOptions(correct: parts[1]),
                    example: sentence
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
        case "Gaokao Advanced", "Builder":
            return gaokaoAdvancedWords
        case "Gaokao Challenge", "Explorer":
            return gaokaoChallengeWords
        default:
            return gaokaoCoreWords
        }
    }

    private static let gaokaoCoreWords: [WordQuestion] = [
        WordQuestion(word: "abandon", pronunciation: "/uh-ban-duhn/", correctMeaning: "放弃", options: ["放弃", "吸收", "适应"], example: "Never abandon your dream when life becomes difficult."),
        WordQuestion(word: "ability", pronunciation: "/uh-bil-uh-tee/", correctMeaning: "能力", options: ["能力", "态度", "证据"], example: "Reading every day can improve your language ability."),
        WordQuestion(word: "abroad", pronunciation: "/uh-brawd/", correctMeaning: "在国外", options: ["在国外", "准确的", "方便的"], example: "Many students hope to study abroad in the future."),
        WordQuestion(word: "absorb", pronunciation: "/uhb-zorb/", correctMeaning: "吸收", options: ["吸收", "争论", "表明"], example: "Good learners absorb new knowledge from mistakes."),
        WordQuestion(word: "academic", pronunciation: "/ak-uh-dem-ik/", correctMeaning: "学术的", options: ["学术的", "灵活的", "有效的"], example: "Academic success depends on effort and method."),
        WordQuestion(word: "access", pronunciation: "/ak-ses/", correctMeaning: "通道；使用权", options: ["通道；使用权", "责任", "机会"], example: "The Internet gives students access to many resources."),
        WordQuestion(word: "accurate", pronunciation: "/ak-yur-it/", correctMeaning: "准确的", options: ["准确的", "经济的", "自信的"], example: "An accurate answer requires careful reading."),
        WordQuestion(word: "achieve", pronunciation: "/uh-cheev/", correctMeaning: "实现", options: ["实现", "比较", "保护"], example: "You can achieve your goal through daily practice."),
        WordQuestion(word: "adapt", pronunciation: "/uh-dapt/", correctMeaning: "适应", options: ["适应", "创造", "影响"], example: "Teenagers need to adapt to a changing world."),
        WordQuestion(word: "attitude", pronunciation: "/at-i-tood/", correctMeaning: "态度", options: ["态度", "结果", "平衡"], example: "A positive attitude helps us face challenges.")
    ]

    private static let gaokaoAdvancedWords: [WordQuestion] = [
        WordQuestion(word: "approach", pronunciation: "/uh-prohch/", correctMeaning: "方法；接近", options: ["方法；接近", "环境", "证据"], example: "A good approach makes vocabulary learning easier."),
        WordQuestion(word: "argument", pronunciation: "/ahr-gyuh-muhnt/", correctMeaning: "争论；论点", options: ["争论；论点", "机会", "责任"], example: "His argument was clear and supported by facts."),
        WordQuestion(word: "benefit", pronunciation: "/ben-uh-fit/", correctMeaning: "益处", options: ["益处", "结果", "能力"], example: "Exercise can benefit both the body and the mind."),
        WordQuestion(word: "challenge", pronunciation: "/chal-inj/", correctMeaning: "挑战", options: ["挑战", "选择", "习惯"], example: "Every challenge is a chance to become stronger."),
        WordQuestion(word: "combine", pronunciation: "/kuhm-byn/", correctMeaning: "结合", options: ["结合", "放弃", "比较"], example: "KidDaily combines learning tasks with healthy habits."),
        WordQuestion(word: "communicate", pronunciation: "/kuh-myoo-ni-kayt/", correctMeaning: "交流", options: ["交流", "适应", "吸收"], example: "We should communicate with parents honestly."),
        WordQuestion(word: "concentrate", pronunciation: "/kon-suhn-trayt/", correctMeaning: "集中注意力", options: ["集中注意力", "实现", "影响"], example: "Put away your phone and concentrate on the sentence."),
        WordQuestion(word: "consequence", pronunciation: "/kon-si-kwens/", correctMeaning: "后果", options: ["后果", "证据", "通道"], example: "Every choice may bring a consequence."),
        WordQuestion(word: "contribute", pronunciation: "/kuhn-trib-yoot/", correctMeaning: "贡献", options: ["贡献", "保护", "解释"], example: "Small daily efforts contribute to future success."),
        WordQuestion(word: "convenient", pronunciation: "/kuhn-veen-yuhnt/", correctMeaning: "方便的", options: ["方便的", "准确的", "学术的"], example: "Online tools make review more convenient.")
    ]

    private static let gaokaoChallengeWords: [WordQuestion] = [
        WordQuestion(word: "distinguish", pronunciation: "/di-sting-gwish/", correctMeaning: "区分", options: ["区分", "贡献", "结合"], example: "Readers must distinguish facts from opinions."),
        WordQuestion(word: "economy", pronunciation: "/ih-kon-uh-mee/", correctMeaning: "经济", options: ["经济", "态度", "证据"], example: "Education plays an important role in the economy."),
        WordQuestion(word: "efficient", pronunciation: "/ih-fish-uhnt/", correctMeaning: "高效的", options: ["高效的", "方便的", "准确的"], example: "An efficient plan saves time before exams."),
        WordQuestion(word: "environment", pronunciation: "/en-vy-ruhn-muhnt/", correctMeaning: "环境", options: ["环境", "后果", "能力"], example: "A quiet environment helps students concentrate."),
        WordQuestion(word: "evidence", pronunciation: "/ev-i-duhns/", correctMeaning: "证据", options: ["证据", "机会", "挑战"], example: "The writer used evidence to support the argument."),
        WordQuestion(word: "flexible", pronunciation: "/flek-suh-bul/", correctMeaning: "灵活的", options: ["灵活的", "学术的", "积极的"], example: "A flexible schedule can reduce stress."),
        WordQuestion(word: "indicate", pronunciation: "/in-di-kayt/", correctMeaning: "表明", options: ["表明", "吸收", "放弃"], example: "The results indicate that practice is useful."),
        WordQuestion(word: "influence", pronunciation: "/in-floo-uhns/", correctMeaning: "影响", options: ["影响", "实现", "接近"], example: "Good habits influence a student's future."),
        WordQuestion(word: "opportunity", pronunciation: "/op-er-too-nuh-tee/", correctMeaning: "机会", options: ["机会", "后果", "方法"], example: "Every mistake is an opportunity to learn."),
        WordQuestion(word: "responsibility", pronunciation: "/ri-spon-suh-bil-uh-tee/", correctMeaning: "责任", options: ["责任", "经济", "通道"], example: "Learning is a responsibility we should take seriously.")
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
