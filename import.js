const reportsStorageKey = "kidDailyDigitalReportsV2";
const selectedChildStorageKey = "kidDailyDigitalSelectedChildV2";

const csvInput = document.getElementById("csv-input");
const fileInput = document.getElementById("csv-file-input");
const childNameInput = document.getElementById("child-name-input");
const importStatus = document.getElementById("import-status");
const previewTitle = document.getElementById("preview-title");
const previewList = document.getElementById("preview-list");

const fallbackReports = [
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

function setStatus(text) {
  importStatus.textContent = text;
}

function parseCsv(text) {
  return text
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean)
    .map((line) => line.split(",").map((cell) => cell.trim()))
    .filter((row) => row.length >= 2)
    .filter((row) => row[0] !== "App名称")
    .map(([appName, minutes, startTime]) => ({
      appName,
      minutes: Number(minutes),
      startTime
    }))
    .filter((row) => row.appName && Number.isFinite(row.minutes));
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

function buildReport(rows) {
  const fallbackStartTimes = ["18:30", "17:20", "20:15", "16:40", "19:50"];
  const totals = {
    learning: 0,
    entertainment: 0,
    reading: 0
  };

  rows.forEach((row) => {
    totals[classifyApp(row.appName)] += row.minutes;
  });

  const totalMinutes = rows.reduce((sum, row) => sum + row.minutes, 0);
  const topApps = [...rows]
    .sort((a, b) => b.minutes - a.minutes)
    .slice(0, 3)
    .map((row) => row.appName);

  const report = {
    name: childNameInput.value.trim() || "孩子",
    date: new Date().toISOString().slice(0, 10),
    totalMinutes,
    learningMinutes: totals.learning,
    entertainmentMinutes: totals.entertainment,
    readingMinutes: totals.reading,
    appUsage: rows
      .sort((a, b) => b.minutes - a.minutes)
      .map((row, index) => {
        const startTime = row.startTime || fallbackStartTimes[index] || "18:00";

        return {
          appName: row.appName,
          minutes: row.minutes,
          category: getCategoryLabel(classifyApp(row.appName)),
          startTime,
          endTime: addMinutesToTime(startTime, row.minutes)
        };
      }),
    topApps,
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

function renderPreview(report) {
  previewTitle.textContent = `${report.name} 的数字成长日报`;
  previewList.innerHTML = "";

  [
    ["今日总使用时间", formatMinutes(report.totalMinutes)],
    ["学习时间", formatMinutes(report.learningMinutes)],
    ["娱乐时间", formatMinutes(report.entertainmentMinutes)],
    ["阅读时间", formatMinutes(report.readingMinutes)],
    ["最常使用应用", report.topApps.join(" / ")],
    ["应用使用明细", report.appUsage.map((app) => `${app.appName} ${formatMinutes(app.minutes)} ${app.startTime}-${app.endTime}`).join(" / ")],
    ["数字成长评分", `${report.growthScore}分 · ${report.rating}`],
    ["AI 成长建议", report.aiComment]
  ].forEach(([label, value]) => {
    const item = document.createElement("div");
    item.innerHTML = `<span>${label}</span><strong>${value}</strong>`;
    previewList.appendChild(item);
  });
}

function getReportFromInput() {
  const rows = parseCsv(csvInput.value);

  if (rows.length === 0) {
    throw new Error("没有识别到有效 CSV 数据。请使用：App名称,时间");
  }

  return buildReport(rows);
}

function previewReport() {
  try {
    const report = getReportFromInput();
    renderPreview(report);
    setStatus("已生成预览。");
    return report;
  } catch (error) {
    setStatus(error.message);
    return null;
  }
}

function saveImportedReport() {
  const report = previewReport();

  if (!report) {
    return;
  }

  const savedReports = JSON.parse(localStorage.getItem(reportsStorageKey) || "null") || fallbackReports;
  const remainingReports = savedReports.filter((savedReport) => savedReport.name !== report.name);
  const nextReports = [report, ...remainingReports];

  localStorage.setItem(reportsStorageKey, JSON.stringify(nextReports));
  localStorage.setItem(selectedChildStorageKey, "0");
  setStatus("已生成日报，正在打开日报页面...");
  window.location.href = "daily.html";
}

fileInput.addEventListener("change", () => {
  const file = fileInput.files[0];

  if (!file) {
    return;
  }

  const reader = new FileReader();
  reader.onload = () => {
    csvInput.value = reader.result;
    previewReport();
  };
  reader.readAsText(file);
});

document.getElementById("preview-button").addEventListener("click", previewReport);
document.getElementById("generate-report-button").addEventListener("click", saveImportedReport);

previewReport();
