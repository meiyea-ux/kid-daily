# Kid Daily iOS 自动上传版方案

## 目标

Kid Daily 下一阶段目标是从“家长手动导入数据的网页产品”，升级为：

1. 孩子在 iPad 或 iPhone 上安装 Kid Daily iOS App
2. 家长授权屏幕使用时间相关权限
3. iOS App 自动生成孩子的设备使用数据
4. 数据上传到 Supabase 云端
5. 家长登录 Kid Daily 网页查看每日数字成长日报

## 重要结论

普通网页不能直接读取 iPad 或 iPhone 的屏幕使用时间。

如果要自动读取或监测孩子设备使用情况，必须开发 iOS / iPadOS 原生 App，并使用 Apple 的 Screen Time 相关能力。

## 需要的账号和工具

### 必需

- Apple Developer 账号
- Mac 电脑
- Xcode
- 一台真实 iPhone 或 iPad
- Supabase 项目
- 当前 Kid Daily 网页项目

### 当前已有

- Kid Daily 网页
- GitHub 仓库
- Vercel 部署
- Supabase 项目
- Supabase 登录能力初版

## Apple 相关技术

Kid Daily iOS App 需要研究和使用这些 Apple 框架：

- FamilyControls
- DeviceActivity
- ManagedSettings

它们属于 Apple Screen Time API 体系。

## 产品结构

### 1. 孩子端 iOS App

作用：

- 请求家长授权
- 读取或生成设备活动报告
- 汇总 App 使用时间
- 将每日数据上传到 Supabase

孩子端 App 初版不需要复杂界面，只需要：

- 登录或绑定孩子
- 显示授权状态
- 显示今日是否已上传
- 手动触发一次上传
- 后续再做自动定时上传

### 2. 家长端网页

作用：

- 家长登录
- 查看孩子列表
- 查看每日数字成长日报
- 查看 App 使用明细
- 查看每周趋势
- 查看 AI 成长建议

当前网页已经具备大部分展示能力。

下一步需要把本地浏览器数据改为 Supabase 云端数据。

## Supabase 数据表设计

### profiles

保存家长账号信息。

字段：

- id
- email
- created_at

### children

保存孩子信息。

字段：

- id
- parent_user_id
- name
- device_name
- created_at

### daily_reports

保存每天总览数据。

字段：

- id
- child_id
- report_date
- total_minutes
- learning_minutes
- entertainment_minutes
- reading_minutes
- growth_score
- ai_comment
- created_at

### app_usage

保存每个 App 的使用明细。

字段：

- id
- report_id
- app_name
- category
- minutes
- start_time
- end_time
- created_at

## 最快 MVP 路线

### 阶段 1：网页端云端化

先不做 iOS App。

目标：

- 家长登录
- 孩子列表保存到 Supabase
- 日报保存到 Supabase
- 不再只依赖浏览器本地数据

原因：

iOS App 上传的数据最终也要进入 Supabase。先把云端数据结构做好，后面 iOS App 才有地方上传。

### 阶段 2：孩子端手动上传 App

开发一个最简单的 iOS App。

目标：

- 家长在孩子设备上登录或绑定孩子
- App 里手动输入或导入 App 使用数据
- 点击上传到 Supabase

原因：

先验证“孩子设备上传，家长网页查看”的闭环。

### 阶段 3：接入 Screen Time API

目标：

- 申请并配置 Apple Screen Time 相关能力
- 使用 DeviceActivity 生成设备活动报告
- 将使用数据转换为 Kid Daily 的日报格式

风险：

- Apple 权限和审核可能比较严格
- 需要真机测试
- 需要 iOS 开发能力

### 阶段 4：自动上传

目标：

- 按天生成报告
- 自动上传到 Supabase
- 家长网页每天自动看到最新日报

## 现实风险

1. 网页不能直接读取 iOS 屏幕使用时间
2. 必须做原生 iOS App
3. 需要 Apple Developer 账号
4. 需要 Mac 和 Xcode
5. Screen Time API 有隐私和权限限制
6. App Store 审核可能要求明确的家长控制用途

## 推荐下一步

不要马上写 iOS App。

下一步先做：

**把当前 Kid Daily 网页的数据保存到 Supabase。**

这样做的原因：

- 这是 iOS 自动上传的基础
- 当前项目已经有 Supabase 登录
- 不需要马上处理 Apple 权限
- 可以最快把产品从“本地演示”升级为“云端产品”

完成后，产品结构会变成：

```text
家长登录网页
→ 数据存在 Supabase
→ 换电脑也能看到
→ 后续 iOS App 直接上传到同一套数据表
```

