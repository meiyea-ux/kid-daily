const reportsStorageKey = "kidDailyDigitalReportsV2";
const selectedChildStorageKey = "kidDailyDigitalSelectedChildV2";
const supabaseUrl = "https://vjxainvzqawflspdchhg.supabase.co";
const supabasePublishableKey = "sb_publishable_ZpSnxUTDfmVnu0MMGbcjOw_b_icH-Jl";
const supabaseClient = window.supabase
  ? window.supabase.createClient(supabaseUrl, supabasePublishableKey)
  : null;
let currentUser = null;

const weeklyTrend = [
  { day: "周一", score: 76 },
  { day: "周二", score: 78 },
  { day: "周三", score: 80 },
  { day: "周四", score: 79 },
  { day: "周五", score: 82 },
  { day: "周六", score: 85 },
  { day: "周日", score: 82 }
];

const weeklySummary = "本周整体表现稳定，学习时间逐步提升，娱乐时间有所下降。建议继续保持阅读习惯。";

const weeklyUsage = [
  { day: "周一", totalMinutes: 168, learningMinutes: 42, entertainmentMinutes: 98, readingMinutes: 18 },
  { day: "周二", totalMinutes: 160, learningMinutes: 44, entertainmentMinutes: 92, readingMinutes: 19 },
  { day: "周三", totalMinutes: 158, learningMinutes: 45, entertainmentMinutes: 90, readingMinutes: 20 },
  { day: "周四", totalMinutes: 150, learningMinutes: 46, entertainmentMinutes: 82, readingMinutes: 22 },
  { day: "周五", totalMinutes: 155, learningMinutes: 48, entertainmentMinutes: 84, readingMinutes: 23 },
  { day: "周六", totalMinutes: 172, learningMinutes: 52, entertainmentMinutes: 95, readingMinutes: 25 },
  { day: "周日", totalMinutes: 155, learningMinutes: 45, entertainmentMinutes: 90, readingMinutes: 20 }
];

const defaultDailyReports = [
  {
    name: "Lucy",
    date: "2026-06-09",
    totalMinutes: 155,
    learningMinutes: 45,
    entertainmentMinutes: 90,
    readingMinutes: 20,
    appUsage: [
      { appName: "YouTube Kids", minutes: 90, category: "娱乐", startTime: "18:30", endTime: "20:00" },
      { appName: "ABC Reading", minutes: 45, category: "学习", startTime: "17:20", endTime: "18:05" },
      { appName: "Safari", minutes: 20, category: "阅读", startTime: "20:15", endTime: "20:35" }
    ],
    topApps: ["YouTube Kids", "ABC Reading", "Safari"],
    trends: {
      learning: "+12%",
      entertainment: "-8%"
    }
  },
  {
    name: "Rain",
    date: "2026-06-09",
    totalMinutes: 155,
    learningMinutes: 45,
    entertainmentMinutes: 90,
    readingMinutes: 20,
    appUsage: [
      { appName: "YouTube Kids", minutes: 90, category: "娱乐", startTime: "18:30", endTime: "20:00" },
      { appName: "ABC Reading", minutes: 45, category: "学习", startTime: "17:20", endTime: "18:05" },
      { appName: "Safari", minutes: 20, category: "阅读", startTime: "20:15", endTime: "20:35" }
    ],
    topApps: ["YouTube Kids", "ABC Reading", "Safari"],
    trends: {
      learning: "+12%",
      entertainment: "-8%"
    }
  }
];

const savedReports = localStorage.getItem(reportsStorageKey);
let dailyReports = savedReports ? JSON.parse(savedReports) : defaultDailyReports;

function setText(id, text) {
  const element = document.getElementById(id);

  if (element) {
    element.textContent = text;
  }
}

function setAuthMessage(text) {
  setText("auth-message", text);
}

function getSelectedChildIndex() {
  const activeButton = document.querySelector(".child-button.active");

  if (activeButton) {
    return Number(activeButton.dataset.childIndex);
  }

  const savedSelectedChild = Number(localStorage.getItem(selectedChildStorageKey));

  return Number.isInteger(savedSelectedChild) ? savedSelectedChild : 0;
}

async function saveReportsToCloud() {
  if (!supabaseClient || !currentUser) {
    return;
  }

  const { error } = await supabaseClient
    .from("kid_daily_user_data")
    .upsert({
      user_id: currentUser.id,
      reports: dailyReports,
      selected_child_index: getSelectedChildIndex()
    });

  if (error) {
    setText("save-status", `云端保存失败：${error.message}`);
    return;
  }

  setText("save-status", "已保存到云端和当前浏览器。");
}

async function loadReportsFromCloud(user) {
  if (!supabaseClient || !user) {
    return;
  }

  const { data, error } = await supabaseClient
    .from("kid_daily_user_data")
    .select("reports, selected_child_index")
    .eq("user_id", user.id)
    .maybeSingle();

  if (error) {
    setText("save-status", `云端读取失败：${error.message}`);
    return;
  }

  if (data?.reports?.length) {
    dailyReports = data.reports;
    localStorage.setItem(reportsStorageKey, JSON.stringify(dailyReports));
    localStorage.setItem(selectedChildStorageKey, String(data.selected_child_index || 0));
    renderChildButtons(data.selected_child_index || 0);
    showReport(data.selected_child_index || 0);
    setText("save-status", "已从云端读取数据。");
    return;
  }

  await saveReportsToCloud();
}

function setAuthView(user) {
  const appContent = document.getElementById("app-content");
  const authForm = document.getElementById("auth-form");
  const authUser = document.getElementById("auth-user");
  currentUser = user;

  if (user) {
    appContent.classList.remove("locked");
    authForm.style.display = "none";
    authUser.style.display = "grid";
    setText("auth-title", "已登录，可以查看孩子日报");
    setText("auth-user-email", user.email);
    setAuthMessage("账号登录成功。正在同步云端数据。");
    loadReportsFromCloud(user);
    return;
  }

  appContent.classList.add("locked");
  authForm.style.display = "grid";
  authUser.style.display = "none";
  setText("auth-title", "登录后查看孩子日报");
  setText("auth-user-email", "");
  setAuthMessage("使用邮箱和密码登录。第一次使用可以先注册账号。");
}

function getAuthInput() {
  return {
    email: document.getElementById("auth-email").value.trim(),
    password: document.getElementById("auth-password").value
  };
}

async function signUp() {
  const { email, password } = getAuthInput();

  if (!email || !password) {
    setAuthMessage("请先输入邮箱和密码。");
    return;
  }

  if (password.length < 6) {
    setAuthMessage("密码至少需要 6 位。");
    return;
  }

  const { error } = await supabaseClient.auth.signUp({
    email,
    password
  });

  if (error) {
    setAuthMessage(error.message);
    return;
  }

  setAuthMessage("注册成功。请检查邮箱确认邮件；如果项目关闭了邮箱确认，也可以直接点击登录。");
}

async function signIn() {
  const { email, password } = getAuthInput();

  if (!email || !password) {
    setAuthMessage("请先输入邮箱和密码。");
    return;
  }

  const { data, error } = await supabaseClient.auth.signInWithPassword({
    email,
    password
  });

  if (error) {
    setAuthMessage(error.message);
    return;
  }

  setAuthView(data.user);
}

async function signOut() {
  await supabaseClient.auth.signOut();
  setAuthView(null);
}

async function initAuth() {
  if (!supabaseClient) {
    setAuthMessage("Supabase 没有加载成功，请检查网络后刷新页面。");
    return;
  }

  const { data } = await supabaseClient.auth.getUser();
  setAuthView(data.user);

  supabaseClient.auth.onAuthStateChange((event, session) => {
    setAuthView(session?.user || null);
  });
}

function parseDuration(text) {
  if (typeof text !== "string") {
    return 0;
  }

  const hourMatch = text.match(/(\d+)小时/);
  const minuteMatch = text.match(/(\d+)分钟/);
  const hours = hourMatch ? Number(hourMatch[1]) : 0;
  const minutes = minuteMatch ? Number(minuteMatch[1]) : 0;

  return hours * 60 + minutes;
}

function getReportMinutes(report) {
  const learningMinutes = report.learningMinutes ?? parseDuration(report.learningTime);
  const entertainmentMinutes = report.entertainmentMinutes ?? parseDuration(report.entertainmentTime);
  const readingMinutes = report.readingMinutes ?? parseDuration(report.readingTime);
  const parsedTotalMinutes = report.totalMinutes ?? parseDuration(report.totalUsage);
  const totalMinutes = parsedTotalMinutes || learningMinutes + entertainmentMinutes + readingMinutes;

  return {
    totalMinutes,
    learningMinutes,
    entertainmentMinutes,
    readingMinutes
  };
}

function formatMinutes(minutes) {
  const hours = Math.floor(minutes / 60);
  const rest = minutes % 60;

  if (hours === 0) {
    return `${rest}分钟`;
  }

  if (rest === 0) {
    return `${hours}小时`;
  }

  return `${hours}小时${rest}分钟`;
}

function addMinutesToTime(startTime, minutes) {
  const [hourText, minuteText] = startTime.split(":");
  const startMinutes = Number(hourText) * 60 + Number(minuteText);
  const endMinutes = (startMinutes + minutes) % (24 * 60);
  const hours = String(Math.floor(endMinutes / 60)).padStart(2, "0");
  const rest = String(endMinutes % 60).padStart(2, "0");

  return `${hours}:${rest}`;
}

function timeToMinutes(timeText) {
  const [hourText, minuteText] = timeText.split(":");

  return Number(hourText) * 60 + Number(minuteText);
}

function calculateGrowthScore(report) {
  const minutes = getReportMinutes(report);
  let score = 0;

  if (minutes.learningMinutes >= 45) {
    score += 30;
  }

  if (minutes.readingMinutes >= 20) {
    score += 20;
  }

  if (minutes.entertainmentMinutes <= 90) {
    score += 25;
  }

  if (minutes.totalMinutes <= 180) {
    score += 15;
  }

  if (minutes.totalMinutes > 0 && minutes.entertainmentMinutes / minutes.totalMinutes <= 0.5) {
    score += 10;
  }

  return score;
}

function getRating(score) {
  if (score >= 80) {
    return "优秀";
  }

  if (score >= 65) {
    return "良好";
  }

  return "需关注";
}

function getDailyConclusion(report) {
  const minutes = getReportMinutes(report);
  const score = calculateGrowthScore(report);
  const entertainmentRatio = minutes.totalMinutes > 0 ? minutes.entertainmentMinutes / minutes.totalMinutes : 0;

  if (minutes.entertainmentMinutes > 90 || entertainmentRatio > 0.5) {
    return {
      level: "warning",
      icon: "!",
      title: "今天娱乐时间偏高",
      text: `今天娱乐使用为${formatMinutes(minutes.entertainmentMinutes)}，占总使用时间比例较高。建议优先关注视频和游戏类 App 的使用边界。`,
      action: "明天减少视频 15 分钟"
    };
  }

  if (score >= 80) {
    return {
      level: "good",
      icon: "✓",
      title: "今天数字使用整体健康",
      text: `学习和阅读时间表现稳定，总使用时间为${formatMinutes(minutes.totalMinutes)}，目前处在比较容易管理的范围内。`,
      action: "保持阅读 20 分钟以上"
    };
  }

  return {
    level: "notice",
    icon: "i",
    title: "今天需要轻度关注",
    text: `今天成长评分为${score}分，建议继续提高学习和阅读内容占比，让数字设备更多服务于成长。`,
    action: "学习不少于 45 分钟"
  };
}

function renderDailyConclusion(report) {
  const card = document.getElementById("daily-conclusion-card");
  const conclusion = getDailyConclusion(report);

  if (!card) {
    return;
  }

  card.classList.remove("good", "notice", "warning");
  card.classList.add(conclusion.level);
  setText("conclusion-icon", conclusion.icon);
  setText("conclusion-title", conclusion.title);
  setText("conclusion-text", conclusion.text);
  setText("conclusion-action", conclusion.action);
}

function createAiComment(report) {
  const minutes = getReportMinutes(report);
  const score = calculateGrowthScore(report);
  const rating = getRating(score);

  return `今天的数字成长评分为${score}分，评级为${rating}。学习时间为${formatMinutes(minutes.learningMinutes)}，阅读时间为${formatMinutes(minutes.readingMinutes)}，这两项为孩子的数字使用质量提供了积极支撑；娱乐时间为${formatMinutes(minutes.entertainmentMinutes)}，仍需保持边界感。建议明天继续保留阅读习惯，并优先把15分钟视频时间转移到学习或亲子讨论中。`;
}

function renderTopApps(apps) {
  const appList = document.getElementById("top-apps");

  if (!appList) {
    return;
  }

  appList.innerHTML = "";

  apps.forEach((app) => {
    const item = document.createElement("li");
    item.textContent = app;
    appList.appendChild(item);
  });
}

function getAppUsage(report) {
  const fallbackStartTimes = ["18:30", "17:20", "20:15", "16:40", "19:50"];

  if (Array.isArray(report.appUsage)) {
    return report.appUsage.map((app, index) => {
      const startTime = app.startTime || fallbackStartTimes[index] || "18:00";
      const endTime = app.endTime || addMinutesToTime(startTime, app.minutes || 0);

      return {
        ...app,
        startTime,
        endTime
      };
    });
  }

  const minutes = getReportMinutes(report);
  const fallbackApps = report.topApps || [];

  return fallbackApps.map((appName, index) => {
    const fallbackMinutes = [minutes.entertainmentMinutes, minutes.learningMinutes, minutes.readingMinutes][index] || 0;
    const fallbackCategory = ["娱乐", "学习", "阅读"][index] || "其他";

    return {
      appName,
      minutes: fallbackMinutes,
      category: fallbackCategory,
      startTime: fallbackStartTimes[index] || "18:00",
      endTime: addMinutesToTime(fallbackStartTimes[index] || "18:00", fallbackMinutes)
    };
  });
}

function renderAppDetails(report) {
  const detailList = document.getElementById("app-detail-list");
  const appUsage = getAppUsage(report).sort((a, b) => b.minutes - a.minutes);

  if (!detailList) {
    return;
  }

  detailList.innerHTML = "";

  appUsage.forEach((app) => {
    const item = document.createElement("div");
    item.className = "app-detail-item";
    item.innerHTML = `
      <div>
        <strong>${app.appName}</strong>
        <span class="app-category">${app.category}</span>
        <span class="app-time">使用时间：${app.startTime} - ${app.endTime}</span>
      </div>
      <em>${formatMinutes(app.minutes)}</em>
    `;
    detailList.appendChild(item);
  });
}

function renderAppPieChart(report) {
  const pieChart = document.getElementById("app-pie-chart");
  const pieLegend = document.getElementById("app-pie-legend");
  const appUsage = getAppUsage(report).sort((a, b) => b.minutes - a.minutes);
  const totalMinutes = appUsage.reduce((sum, app) => sum + app.minutes, 0);
  const colors = ["#2563eb", "#22c55e", "#f97316", "#7c3aed", "#06b6d4"];
  let currentPercent = 0;
  const gradientParts = [];

  if (!pieChart || !pieLegend) {
    return;
  }

  pieLegend.innerHTML = "";

  appUsage.forEach((app, index) => {
    const percent = totalMinutes > 0 ? Math.round((app.minutes / totalMinutes) * 100) : 0;
    const nextPercent = currentPercent + percent;
    const color = colors[index % colors.length];
    const legendItem = document.createElement("div");

    gradientParts.push(`${color} ${currentPercent}% ${nextPercent}%`);
    currentPercent = nextPercent;

    legendItem.className = "app-pie-legend-item";
    legendItem.innerHTML = `
      <span style="background: ${color};"></span>
      <strong>${app.appName}</strong>
      <em>${percent}% · ${formatMinutes(app.minutes)}</em>
    `;
    pieLegend.appendChild(legendItem);
  });

  pieChart.style.background = `
    radial-gradient(circle at center, #ffffff 56%, transparent 58%),
    conic-gradient(${gradientParts.join(", ")})
  `;
  setText("app-pie-total", formatMinutes(totalMinutes));
}

function renderAppTimeline(report) {
  const timelineList = document.getElementById("app-timeline-list");
  const appUsage = getAppUsage(report).sort((a, b) => timeToMinutes(a.startTime) - timeToMinutes(b.startTime));
  const dayStart = 6 * 60;
  const dayEnd = 24 * 60;
  const timelineMinutes = dayEnd - dayStart;

  if (!timelineList) {
    return;
  }

  timelineList.innerHTML = "";

  appUsage.forEach((app) => {
    const startMinutes = Math.max(timeToMinutes(app.startTime), dayStart);
    const endMinutes = Math.min(timeToMinutes(app.endTime), dayEnd);
    const left = ((startMinutes - dayStart) / timelineMinutes) * 100;
    const width = Math.max(((endMinutes - startMinutes) / timelineMinutes) * 100, 4);
    const item = document.createElement("div");

    item.className = "timeline-item";
    item.innerHTML = `
      <div class="timeline-name">
        <strong>${app.appName}</strong>
        <span>${app.startTime} - ${app.endTime}</span>
      </div>
      <div class="timeline-track">
        <i style="left: ${left}%; width: ${width}%;"></i>
      </div>
      <em>${formatMinutes(app.minutes)}</em>
    `;
    timelineList.appendChild(item);
  });
}

function renderWeeklyChart() {
  const chart = document.getElementById("weekly-chart");

  if (!chart) {
    return;
  }

  chart.innerHTML = "";

  weeklyTrend.forEach((item) => {
    const bar = document.createElement("div");
    bar.className = "weekly-bar";
    bar.innerHTML = `
      <strong>${item.score}</strong>
      <span class="bar-track"><span class="bar-fill" style="height: ${item.score}%"></span></span>
      <em>${item.day}</em>
    `;
    chart.appendChild(bar);
  });
}

function renderWeeklyStats() {
  const statsGrid = document.getElementById("weekly-stats-grid");
  const totalMinutes = weeklyUsage.reduce((sum, day) => sum + day.totalMinutes, 0);
  const learningMinutes = weeklyUsage.reduce((sum, day) => sum + day.learningMinutes, 0);
  const entertainmentMinutes = weeklyUsage.reduce((sum, day) => sum + day.entertainmentMinutes, 0);
  const readingMinutes = weeklyUsage.reduce((sum, day) => sum + day.readingMinutes, 0);
  const averageMinutes = Math.round(totalMinutes / weeklyUsage.length);
  const bestDay = weeklyTrend.reduce((best, item) => (item.score > best.score ? item : best), weeklyTrend[0]);
  const stats = [
    ["本周总使用", formatMinutes(totalMinutes)],
    ["日均使用", formatMinutes(averageMinutes)],
    ["学习总时长", formatMinutes(learningMinutes)],
    ["娱乐总时长", formatMinutes(entertainmentMinutes)],
    ["阅读总时长", formatMinutes(readingMinutes)],
    ["本周最佳", `${bestDay.day} · ${bestDay.score}分`]
  ];

  if (!statsGrid) {
    return;
  }

  statsGrid.innerHTML = "";

  stats.forEach(([label, value]) => {
    const item = document.createElement("div");

    item.className = "weekly-stat-item";
    item.innerHTML = `<span>${label}</span><strong>${value}</strong>`;
    statsGrid.appendChild(item);
  });
}

function renderUsageBreakdown(minutes) {
  const total = minutes.totalMinutes || 1;
  const learningPercent = Math.round((minutes.learningMinutes / total) * 100);
  const entertainmentPercent = Math.round((minutes.entertainmentMinutes / total) * 100);
  const readingPercent = Math.round((minutes.readingMinutes / total) * 100);
  const donut = document.getElementById("usage-donut");

  if (donut) {
    donut.style.setProperty("--learning-percent", `${learningPercent}%`);
    donut.style.setProperty("--entertainment-percent", `${learningPercent + entertainmentPercent}%`);
  }

  setText("usage-donut-total", formatMinutes(minutes.totalMinutes));
  setText("learning-percent", `${learningPercent}%`);
  setText("entertainment-percent", `${entertainmentPercent}%`);
  setText("reading-percent", `${readingPercent}%`);

  document.getElementById("learning-bar").style.width = `${learningPercent}%`;
  document.getElementById("entertainment-bar").style.width = `${entertainmentPercent}%`;
  document.getElementById("reading-bar").style.width = `${readingPercent}%`;
}

function renderRiskAlerts(minutes) {
  const riskList = document.getElementById("risk-list");
  const entertainmentRatio = minutes.totalMinutes > 0 ? minutes.entertainmentMinutes / minutes.totalMinutes : 0;
  const risks = [];

  if (minutes.entertainmentMinutes > 90) {
    risks.push({
      level: "high",
      title: "娱乐时间偏高",
      text: "娱乐时间已经超过90分钟，建议明天先减少15分钟视频或游戏内容。"
    });
  } else {
    risks.push({
      level: "good",
      title: "娱乐时间可控",
      text: "娱乐时间没有超过90分钟，当前边界相对清晰。"
    });
  }

  if (minutes.totalMinutes > 180) {
    risks.push({
      level: "medium",
      title: "总使用时间偏长",
      text: "总使用时间超过3小时，建议设置固定的离屏休息时段。"
    });
  }

  if (minutes.readingMinutes < 20) {
    risks.push({
      level: "medium",
      title: "阅读时间不足",
      text: "阅读时间低于20分钟，可以用睡前阅读或分级阅读补足。"
    });
  } else {
    risks.push({
      level: "good",
      title: "阅读习惯达标",
      text: "阅读时间达到20分钟，有助于提升数字内容质量。"
    });
  }

  if (entertainmentRatio > 0.5) {
    risks.push({
      level: "high",
      title: "娱乐占比过半",
      text: "娱乐时间超过总使用时间的50%，建议提高学习和阅读内容占比。"
    });
  }

  riskList.innerHTML = "";

  risks.forEach((risk) => {
    const item = document.createElement("div");
    item.className = `risk-item ${risk.level}`;
    item.innerHTML = `<strong>${risk.title}</strong><p>${risk.text}</p>`;
    riskList.appendChild(item);
  });
}

function saveReports() {
  localStorage.setItem(reportsStorageKey, JSON.stringify(dailyReports));
  setText("save-status", "已保存到当前浏览器。");
  saveReportsToCloud();
}

function createReportForChild(name) {
  const template = defaultDailyReports[0];

  return {
    ...JSON.parse(JSON.stringify(template)),
    name,
    date: new Date().toISOString().slice(0, 10)
  };
}

function getActiveReport() {
  const activeButton = document.querySelector(".child-button.active");
  const activeIndex = activeButton ? Number(activeButton.dataset.childIndex) : 0;

  return dailyReports[activeIndex];
}

function buildExportText(report) {
  const minutes = getReportMinutes(report);
  const score = calculateGrowthScore(report);
  const rating = getRating(score);

  return [
    "Kid Daily 数字成长日报",
    "",
    `孩子：${report.name}`,
    `日期：${report.date}`,
    `成长评分：${score}分（${rating}）`,
    "",
    "使用时间分布",
    `今日总使用时间：${formatMinutes(minutes.totalMinutes)}`,
    `学习时间：${formatMinutes(minutes.learningMinutes)}`,
    `娱乐时间：${formatMinutes(minutes.entertainmentMinutes)}`,
    `阅读时间：${formatMinutes(minutes.readingMinutes)}`,
    "",
    "应用使用明细",
    ...getAppUsage(report).map((app) => `${app.appName}：${formatMinutes(app.minutes)}（${app.category}，${app.startTime}-${app.endTime}）`),
    "",
    "趋势分析",
    `学习：${report.trends?.learning || "+12%"}`,
    `娱乐：${report.trends?.entertainment || "-8%"}`,
    "",
    "本周总结",
    weeklySummary,
    "",
    "AI 成长建议",
    createAiComment(report)
  ].join("\n");
}

function exportReport() {
  const report = getActiveReport();
  const text = buildExportText(report);
  const blob = new Blob([text], { type: "text/plain;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");

  link.href = url;
  link.download = `KidDaily-${report.name}-${report.date}.txt`;
  link.click();
  URL.revokeObjectURL(url);
}

function printReport() {
  if (typeof window.print === "function") {
    window.print();
    return;
  }

  setText("save-status", "当前浏览器不支持直接打印，请先使用“导出日报”。");
}

async function generateRealAiComment() {
  const report = getActiveReport();

  setText("ai-status", "正在生成真实 AI 成长建议...");

  try {
    const response = await fetch("/api/ai-comment", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(report)
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || "AI request failed.");
    }

    setText("ai-comment", data.comment);
    setText("ai-status", "已生成真实 AI 成长建议。");
  } catch (error) {
    setText("ai-status", error.message);
  }
}

function showReport(index) {
  const report = dailyReports[index];
  const minutes = getReportMinutes(report);
  const score = calculateGrowthScore(report);
  const rating = getRating(score);
  const scoreRing = document.querySelector(".score-ring");

  localStorage.setItem(selectedChildStorageKey, String(index));

  if (scoreRing) {
    scoreRing.style.setProperty("--score-percent", `${score}%`);
  }

  setText("growth-score", `${score}分`);
  setText("growth-rating", rating);
  setText("learning-trend", report.trends?.learning || "+12%");
  setText("entertainment-trend", report.trends?.entertainment || "-8%");
  setText("weekly-summary", weeklySummary);
  renderDailyConclusion(report);
  renderUsageBreakdown(minutes);
  renderRiskAlerts(minutes);
  setText("child-name", report.name);
  setText("report-date", report.date);
  setText("total-usage", formatMinutes(minutes.totalMinutes));
  setText("learning-time", formatMinutes(minutes.learningMinutes));
  setText("learning-text", "来自 iPad 和 iPhone 中的学习类应用使用记录。");
  setText("entertainment-time", formatMinutes(minutes.entertainmentMinutes));
  setText("entertainment-text", "包含视频、游戏和其他娱乐类应用使用时间。");
  setText("reading-time", formatMinutes(minutes.readingMinutes));
  setText("reading-text", "包含电子书、分级阅读和网页阅读时间。");
  renderTopApps(report.topApps || []);
  renderAppDetails(report);
  renderAppPieChart(report);
  renderAppTimeline(report);
  setText("ai-comment", createAiComment(report));

  document.querySelectorAll(".child-button").forEach((button) => {
    button.classList.toggle("active", button.dataset.childIndex === String(index));
  });
}

function renderChildButtons(activeIndex = 0) {
  const switcher = document.getElementById("child-switcher");

  if (!switcher) {
    return;
  }

  switcher.innerHTML = "";

  dailyReports.forEach((report, index) => {
    const button = document.createElement("button");

    button.className = "child-button";
    button.type = "button";
    button.dataset.childIndex = String(index);
    button.textContent = report.name;
    button.classList.toggle("active", index === activeIndex);
    button.addEventListener("click", () => {
      showReport(index);
    });
    switcher.appendChild(button);
  });
}

function addChild() {
  const input = document.getElementById("new-child-name");
  const name = input.value.trim();

  if (!name) {
    setText("save-status", "请先输入孩子名字。");
    return;
  }

  const exists = dailyReports.some((report) => report.name.toLowerCase() === name.toLowerCase());

  if (exists) {
    setText("save-status", "这个孩子已经存在，请换一个名字。");
    return;
  }

  dailyReports.push(createReportForChild(name));
  input.value = "";
  saveReports();
  renderChildButtons(dailyReports.length - 1);
  showReport(dailyReports.length - 1);
  setText("save-status", `已新增孩子：${name}`);
}

document.getElementById("save-data-button").addEventListener("click", saveReports);
document.getElementById("generate-ai-button").addEventListener("click", generateRealAiComment);
document.getElementById("export-report-button").addEventListener("click", exportReport);
document.getElementById("print-report-button").addEventListener("click", printReport);
document.getElementById("add-child-button").addEventListener("click", addChild);
document.getElementById("sign-up-button").addEventListener("click", signUp);
document.getElementById("sign-in-button").addEventListener("click", signIn);
document.getElementById("sign-out-button").addEventListener("click", signOut);

renderWeeklyChart();
renderWeeklyStats();
initAuth();
localStorage.setItem(reportsStorageKey, JSON.stringify(dailyReports));

const savedSelectedChild = Number(localStorage.getItem(selectedChildStorageKey));
const startIndex = Number.isInteger(savedSelectedChild) && dailyReports[savedSelectedChild] ? savedSelectedChild : 0;

renderChildButtons(startIndex);
showReport(startIndex);
