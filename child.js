const reportsStorageKey = "kidDailyDigitalReportsV2";
const selectedChildStorageKey = "kidDailyDigitalSelectedChildV2";
const supabaseUrl = "https://vjxainvzqawflspdchhg.supabase.co";
const supabasePublishableKey = "sb_publishable_ZpSnxUTDfmVnu0MMGbcjOw_b_icH-Jl";
const supabaseClient = window.supabase
  ? window.supabase.createClient(supabaseUrl, supabasePublishableKey)
  : null;

let currentUser = null;
let cloudReports = [];

function setText(id, text) {
  const element = document.getElementById(id);

  if (element) {
    element.textContent = text;
  }
}

function setUploadStatus(text) {
  setText("child-upload-status", text);
}

function setAuthMessage(text) {
  setText("child-auth-message", text);
}

function showUploadSuccess(report) {
  const card = document.getElementById("child-success-card");

  if (!card) {
    return;
  }

  setText("success-child-name", report.name);
  setText("success-total-time", formatMinutes(report.totalMinutes));
  setText("success-score", `${report.growthScore}分`);
  card.classList.add("visible");
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

function classifyApp(appName) {
  const name = appName.toLowerCase();

  if (name.includes("youtube") || name.includes("game") || name.includes("video") || name.includes("tiktok")) {
    return "entertainment";
  }

  if (name.includes("abc reading") || name.includes("learning") || name.includes("math") || name.includes("study")) {
    return "learning";
  }

  if (name.includes("safari") || name.includes("book") || name.includes("reader") || name.includes("kindle")) {
    return "reading";
  }

  return "entertainment";
}

function getCategoryLabel(category) {
  if (category === "learning") {
    return "学习";
  }

  if (category === "reading") {
    return "阅读";
  }

  return "娱乐";
}

function calculateGrowthScore(report) {
  let score = 0;

  if (report.learningMinutes >= 45) {
    score += 30;
  }

  if (report.readingMinutes >= 20) {
    score += 20;
  }

  if (report.entertainmentMinutes <= 90) {
    score += 25;
  }

  if (report.totalMinutes <= 180) {
    score += 15;
  }

  if (report.totalMinutes > 0 && report.entertainmentMinutes / report.totalMinutes <= 0.5) {
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

function buildAiComment(report) {
  const score = calculateGrowthScore(report);
  const rating = getRating(score);

  return `今天的数字成长评分为${score}分，评级为${rating}。总使用时间为${formatMinutes(report.totalMinutes)}，学习时间为${formatMinutes(report.learningMinutes)}，阅读时间为${formatMinutes(report.readingMinutes)}，娱乐时间为${formatMinutes(report.entertainmentMinutes)}。建议明天继续保持阅读习惯，并优先减少15分钟视频类娱乐内容。`;
}

function readMobileRows() {
  return Array.from(document.querySelectorAll(".mobile-app-row"))
    .map((row) => {
      const appName = row.querySelector('[data-field="appName"]').value.trim();
      const minutes = Number(row.querySelector('[data-field="minutes"]').value);
      const startTime = row.querySelector('[data-field="startTime"]').value || "18:00";

      return { appName, minutes, startTime };
    })
    .filter((row) => row.appName && Number.isFinite(row.minutes) && row.minutes > 0);
}

function buildReportFromRows(rows) {
  const totals = {
    learning: 0,
    entertainment: 0,
    reading: 0
  };

  rows.forEach((row) => {
    totals[classifyApp(row.appName)] += row.minutes;
  });

  const totalMinutes = rows.reduce((sum, row) => sum + row.minutes, 0);
  const appUsage = rows
    .sort((a, b) => b.minutes - a.minutes)
    .map((row) => {
      const category = classifyApp(row.appName);

      return {
        appName: row.appName,
        minutes: row.minutes,
        category: getCategoryLabel(category),
        startTime: row.startTime,
        endTime: addMinutesToTime(row.startTime, row.minutes)
      };
    });

  const report = {
    name: document.getElementById("child-name").value.trim() || "孩子",
    date: new Date().toISOString().slice(0, 10),
    totalMinutes,
    learningMinutes: totals.learning,
    entertainmentMinutes: totals.entertainment,
    readingMinutes: totals.reading,
    appUsage,
    topApps: appUsage.slice(0, 3).map((app) => app.appName),
    trends: {
      learning: "+12%",
      entertainment: "-8%"
    }
  };

  report.growthScore = calculateGrowthScore(report);
  report.rating = getRating(report.growthScore);
  report.aiComment = buildAiComment(report);

  return report;
}

function mergeReportIntoReports(report, reports) {
  const remainingReports = reports.filter((savedReport) => savedReport.name !== report.name);

  return [report, ...remainingReports];
}

function saveToLocalReports(nextReports) {
  localStorage.setItem(reportsStorageKey, JSON.stringify(nextReports));
  localStorage.setItem(selectedChildStorageKey, "0");
}

async function loadCloudReports() {
  if (!currentUser) {
    cloudReports = [];
    return;
  }

  const { data, error } = await supabaseClient
    .from("kid_daily_user_data")
    .select("reports")
    .eq("user_id", currentUser.id)
    .maybeSingle();

  if (error) {
    setUploadStatus(`云端读取失败：${error.message}`);
    cloudReports = JSON.parse(localStorage.getItem(reportsStorageKey) || "[]");
    return;
  }

  cloudReports = Array.isArray(data?.reports)
    ? data.reports
    : JSON.parse(localStorage.getItem(reportsStorageKey) || "[]");

  localStorage.setItem(reportsStorageKey, JSON.stringify(cloudReports));
}

async function findOrCreateChild(report) {
  const { data: existingChildren, error: selectError } = await supabaseClient
    .from("children")
    .select("id")
    .eq("parent_user_id", currentUser.id)
    .eq("name", report.name)
    .limit(1);

  if (selectError) {
    throw selectError;
  }

  if (existingChildren.length > 0) {
    return existingChildren[0].id;
  }

  const { data: child, error: insertError } = await supabaseClient
    .from("children")
    .insert({
      parent_user_id: currentUser.id,
      name: report.name,
      device_name: "iPad / iPhone"
    })
    .select("id")
    .single();

  if (insertError) {
    throw insertError;
  }

  return child.id;
}

function normalizeTimeForDatabase(timeText) {
  if (typeof timeText !== "string" || !/^\d{2}:\d{2}$/.test(timeText)) {
    return null;
  }

  return timeText;
}

async function syncReportToProductTables(report) {
  const childId = await findOrCreateChild(report);

  const { data: dailyReport, error: reportError } = await supabaseClient
    .from("daily_reports")
    .upsert(
      {
        child_id: childId,
        parent_user_id: currentUser.id,
        report_date: report.date,
        total_minutes: report.totalMinutes,
        learning_minutes: report.learningMinutes,
        entertainment_minutes: report.entertainmentMinutes,
        reading_minutes: report.readingMinutes,
        growth_score: calculateGrowthScore(report),
        rating: getRating(calculateGrowthScore(report)),
        ai_comment: report.aiComment
      },
      { onConflict: "child_id,report_date" }
    )
    .select("id")
    .single();

  if (reportError) {
    throw reportError;
  }

  const { error: deleteError } = await supabaseClient
    .from("app_usage")
    .delete()
    .eq("report_id", dailyReport.id)
    .eq("parent_user_id", currentUser.id);

  if (deleteError) {
    throw deleteError;
  }

  const appRows = report.appUsage.map((app) => ({
    report_id: dailyReport.id,
    parent_user_id: currentUser.id,
    child_id: childId,
    app_name: app.appName,
    category: app.category,
    minutes: app.minutes,
    start_time: normalizeTimeForDatabase(app.startTime),
    end_time: normalizeTimeForDatabase(app.endTime)
  }));

  if (appRows.length === 0) {
    return;
  }

  const { error: appUsageError } = await supabaseClient
    .from("app_usage")
    .insert(appRows);

  if (appUsageError) {
    throw appUsageError;
  }
}

async function saveReportToCloud(report, nextReports) {
  const { error } = await supabaseClient
    .from("kid_daily_user_data")
    .upsert({
      user_id: currentUser.id,
      reports: nextReports,
      selected_child_index: 0
    });

  if (error) {
    throw error;
  }

  await syncReportToProductTables(report);
}

async function uploadMobileReport() {
  if (!currentUser) {
    setUploadStatus("请先登录家长账号。");
    return;
  }

  const rows = readMobileRows();

  if (rows.length === 0) {
    setUploadStatus("请至少填写一个 App 使用记录。");
    return;
  }

  const report = buildReportFromRows(rows);
  const nextReports = mergeReportIntoReports(report, cloudReports);
  saveToLocalReports(nextReports);

  setUploadStatus("正在上传到云端...");

  try {
    await saveReportToCloud(report, nextReports);
    cloudReports = nextReports;
    setUploadStatus(`上传成功：${report.name} 今天总使用 ${formatMinutes(report.totalMinutes)}，成长评分 ${report.growthScore} 分。`);
    showUploadSuccess(report);
  } catch (error) {
    setUploadStatus(`上传失败：${error.message}`);
  }
}

function addMobileAppRow() {
  const list = document.getElementById("mobile-app-list");
  const row = document.createElement("div");

  row.className = "mobile-app-row";
  row.innerHTML = `
    <input class="text-input" data-field="appName" type="text" placeholder="App 名称" aria-label="App 名称">
    <input class="text-input" data-field="minutes" type="number" min="0" placeholder="分钟" aria-label="分钟">
    <input class="text-input" data-field="startTime" type="time" value="18:00" aria-label="开始时间">
  `;
  list.appendChild(row);
}

function setAuthView(user) {
  const uploadCard = document.getElementById("child-upload-card");
  const authForm = document.querySelector(".child-auth-form");
  const authUser = document.getElementById("child-auth-user");

  currentUser = user;

  if (user) {
    uploadCard.classList.remove("locked");
    authForm.style.display = "none";
    authUser.style.display = "grid";
    setText("child-auth-email-text", user.email);
    setAuthMessage("已登录，可以上传孩子端数据。");
    loadCloudReports();
    return;
  }

  uploadCard.classList.add("locked");
  cloudReports = [];
  authForm.style.display = "grid";
  authUser.style.display = "none";
  setText("child-auth-email-text", "");
  setAuthMessage("请使用家长账号登录。这个版本不会自动读取屏幕使用时间，需要手动填写。");
}

async function signIn() {
  if (!supabaseClient) {
    setAuthMessage("Supabase 没有加载成功，请刷新页面后重试。");
    return;
  }

  const email = document.getElementById("child-auth-email").value.trim();
  const password = document.getElementById("child-auth-password").value;

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
    setAuthMessage("Supabase 没有加载成功，请刷新页面后重试。");
    return;
  }

  const { data } = await supabaseClient.auth.getUser();
  setAuthView(data.user);

  supabaseClient.auth.onAuthStateChange((event, session) => {
    setAuthView(session?.user || null);
  });
}

document.getElementById("child-sign-in-button").addEventListener("click", signIn);
document.getElementById("child-sign-out-button").addEventListener("click", signOut);
document.getElementById("add-mobile-app-button").addEventListener("click", addMobileAppRow);
document.getElementById("upload-mobile-report-button").addEventListener("click", uploadMobileReport);

initAuth();
