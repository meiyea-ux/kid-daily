const supabaseUrl = "https://vjxainvzqawflspdchhg.supabase.co";
const supabasePublishableKey = "sb_publishable_ZpSnxUTDfmVnu0MMGbcjOw_b_icH-Jl";
const supabaseClient = window.supabase
  ? window.supabase.createClient(supabaseUrl, supabasePublishableKey)
  : null;

let currentTeacher = null;
let teacherClasses = [];
let teacherAssignments = [];

function setText(id, text) {
  const element = document.getElementById(id);

  if (element) {
    element.textContent = text;
  }
}

function setTeacherAuthMessage(text) {
  setText("teacher-auth-message", text);
}

function randomClassCode() {
  return `KD${Math.random().toString(36).slice(2, 8).toUpperCase()}`;
}

function assignmentTypeLabel(type) {
  const labels = {
    study: "学习资料",
    exercise: "体育锻炼",
    reading: "读书打卡"
  };

  return labels[type] || "学习任务";
}

function escapeHtml(value) {
  return String(value || "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

async function signUpTeacher() {
  if (!supabaseClient) {
    setTeacherAuthMessage("Supabase 未加载，无法注册。");
    return;
  }

  const email = document.getElementById("teacher-email").value.trim();
  const password = document.getElementById("teacher-password").value;

  if (!email || password.length < 6) {
    setTeacherAuthMessage("请输入邮箱和至少 6 位密码。");
    return;
  }

  const { error } = await supabaseClient.auth.signUp({ email, password });

  if (error) {
    setTeacherAuthMessage(`注册失败：${error.message}`);
    return;
  }

  setTeacherAuthMessage("注册成功。请检查邮箱验证，或直接尝试登录。");
}

async function signInTeacher() {
  if (!supabaseClient) {
    setTeacherAuthMessage("Supabase 未加载，无法登录。");
    return;
  }

  const email = document.getElementById("teacher-email").value.trim();
  const password = document.getElementById("teacher-password").value;

  const { data, error } = await supabaseClient.auth.signInWithPassword({ email, password });

  if (error) {
    setTeacherAuthMessage(`登录失败：${error.message}`);
    return;
  }

  currentTeacher = data.user;
  await afterTeacherLogin();
}

async function signOutTeacher() {
  if (supabaseClient) {
    await supabaseClient.auth.signOut();
  }

  currentTeacher = null;
  teacherClasses = [];
  teacherAssignments = [];
  renderTeacherAuthState();
  renderTeacherClasses();
  renderTeacherAssignments();
}

function renderTeacherAuthState() {
  const isSignedIn = Boolean(currentTeacher);
  document.getElementById("teacher-content").classList.toggle("locked", !isSignedIn);
  document.getElementById("teacher-auth-form").style.display = isSignedIn ? "none" : "grid";
  document.getElementById("teacher-auth-user").style.display = isSignedIn ? "grid" : "none";
  setText("teacher-user-email", currentTeacher?.email || "");
}

async function afterTeacherLogin() {
  renderTeacherAuthState();
  setTeacherAuthMessage("老师账号已登录。");
  await ensureTeacherProfile();
  await loadTeacherData();
}

async function ensureTeacherProfile() {
  if (!currentTeacher) return;

  const { data, error } = await supabaseClient
    .from("teacher_profiles")
    .select("*")
    .eq("user_id", currentTeacher.id)
    .maybeSingle();

  if (error) {
    setText("teacher-profile-status", `读取老师资料失败：${error.message}`);
    return;
  }

  if (data) {
    document.getElementById("teacher-display-name").value = data.display_name || "";
    document.getElementById("teacher-school-name").value = data.school_name || "";
    setText("teacher-profile-status", "老师资料已读取。");
    return;
  }

  await supabaseClient
    .from("teacher_profiles")
    .insert({
      user_id: currentTeacher.id,
      display_name: "Teacher",
      school_name: ""
    });
}

async function saveTeacherProfile() {
  if (!currentTeacher) {
    setText("teacher-profile-status", "请先登录老师账号。");
    return;
  }

  const displayName = document.getElementById("teacher-display-name").value.trim() || "Teacher";
  const schoolName = document.getElementById("teacher-school-name").value.trim();

  const { error } = await supabaseClient
    .from("teacher_profiles")
    .upsert({
      user_id: currentTeacher.id,
      display_name: displayName,
      school_name: schoolName
    });

  setText("teacher-profile-status", error ? `保存失败：${error.message}` : "老师资料已保存。");
}

async function createTeacherClass() {
  if (!currentTeacher) {
    setText("teacher-class-status", "请先登录老师账号。");
    return;
  }

  const className = document.getElementById("teacher-class-name").value.trim();
  const description = document.getElementById("teacher-class-description").value.trim();

  if (!className) {
    setText("teacher-class-status", "请输入班级名称。");
    return;
  }

  const { error } = await supabaseClient
    .from("teacher_classes")
    .insert({
      teacher_user_id: currentTeacher.id,
      class_name: className,
      class_code: randomClassCode(),
      description
    });

  if (error) {
    setText("teacher-class-status", `创建失败：${error.message}`);
    return;
  }

  document.getElementById("teacher-class-name").value = "";
  document.getElementById("teacher-class-description").value = "";
  setText("teacher-class-status", "班级已创建。");
  await loadTeacherData();
}

async function publishAssignment() {
  if (!currentTeacher) {
    setText("assignment-status", "请先登录老师账号。");
    return;
  }

  const classId = document.getElementById("assignment-class-select").value;
  const title = document.getElementById("assignment-title").value.trim();
  const description = document.getElementById("assignment-description").value.trim();
  const resourceUrl = document.getElementById("assignment-resource-url").value.trim();
  const assignmentType = document.getElementById("assignment-type").value;
  const targetMinutes = Number(document.getElementById("assignment-minutes").value) || 20;
  const dueDate = document.getElementById("assignment-due-date").value || null;
  const requiresCheckIn = document.getElementById("assignment-requires-checkin").checked;

  if (!classId) {
    setText("assignment-status", "请先创建或选择班级。");
    return;
  }

  if (!title) {
    setText("assignment-status", "请输入任务标题。");
    return;
  }

  const { error } = await supabaseClient
    .from("teacher_assignments")
    .insert({
      teacher_user_id: currentTeacher.id,
      class_id: classId,
      assignment_type: assignmentType,
      title,
      description,
      resource_url: resourceUrl,
      target_minutes: targetMinutes,
      due_date: dueDate,
      requires_check_in: requiresCheckIn
    });

  if (error) {
    setText("assignment-status", `发布失败：${error.message}`);
    return;
  }

  document.getElementById("assignment-title").value = "";
  document.getElementById("assignment-description").value = "";
  document.getElementById("assignment-resource-url").value = "";
  setText("assignment-status", "任务已发布。学生端/家长端同步后可看到。");
  await loadTeacherData();
}

async function loadTeacherData() {
  if (!currentTeacher) return;

  const { data: classes, error: classError } = await supabaseClient
    .from("teacher_classes")
    .select("*")
    .eq("teacher_user_id", currentTeacher.id)
    .order("created_at", { ascending: false });

  if (classError) {
    setText("teacher-class-status", `读取班级失败：${classError.message}`);
    return;
  }

  teacherClasses = classes || [];

  const { data: assignments, error: assignmentError } = await supabaseClient
    .from("teacher_assignments")
    .select("*, teacher_classes(class_name, class_code)")
    .eq("teacher_user_id", currentTeacher.id)
    .order("created_at", { ascending: false });

  if (assignmentError) {
    setText("assignment-status", `读取任务失败：${assignmentError.message}`);
    return;
  }

  teacherAssignments = assignments || [];
  renderTeacherClasses();
  renderTeacherAssignments();
}

function renderClassSelect() {
  const select = document.getElementById("assignment-class-select");
  select.innerHTML = "";

  if (teacherClasses.length === 0) {
    const option = document.createElement("option");
    option.value = "";
    option.textContent = "请先创建班级";
    select.appendChild(option);
    return;
  }

  teacherClasses.forEach((teacherClass) => {
    const option = document.createElement("option");
    option.value = teacherClass.id;
    option.textContent = `${teacherClass.class_name} (${teacherClass.class_code})`;
    select.appendChild(option);
  });
}

function renderTeacherClasses() {
  renderClassSelect();
  const list = document.getElementById("teacher-class-list");
  list.innerHTML = "";

  if (teacherClasses.length === 0) {
    list.innerHTML = '<p class="empty-list">还没有班级。请先创建一个班级。</p>';
    return;
  }

  teacherClasses.forEach((teacherClass) => {
    const item = document.createElement("article");
    item.className = "teacher-list-item";
    item.innerHTML = `
      <div>
        <strong>${escapeHtml(teacherClass.class_name)}</strong>
        <p>${escapeHtml(teacherClass.description || "暂无班级说明")}</p>
      </div>
      <div class="teacher-code">
        <span>班级码</span>
        <b>${escapeHtml(teacherClass.class_code)}</b>
      </div>
    `;
    list.appendChild(item);
  });
}

function renderTeacherAssignments() {
  const list = document.getElementById("teacher-assignment-list");
  list.innerHTML = "";

  if (teacherAssignments.length === 0) {
    list.innerHTML = '<p class="empty-list">还没有发布任务。</p>';
    return;
  }

  teacherAssignments.forEach((assignment) => {
    const item = document.createElement("article");
    item.className = "teacher-list-item assignment-item";
    const className = escapeHtml(assignment.teacher_classes?.class_name || "未指定班级");
    const dueDate = assignment.due_date ? `截止：${escapeHtml(assignment.due_date)}` : "无截止日期";
    const checkInText = assignment.requires_check_in ? "要求打卡" : "无需打卡";
    const resourceUrl = escapeHtml(assignment.resource_url);

    item.innerHTML = `
      <div>
        <span class="assignment-type">${escapeHtml(assignmentTypeLabel(assignment.assignment_type))}</span>
        <strong>${escapeHtml(assignment.title)}</strong>
        <p>${escapeHtml(assignment.description || "暂无任务说明")}</p>
        ${assignment.resource_url ? `<a href="${resourceUrl}" target="_blank" rel="noopener">打开资料链接</a>` : ""}
      </div>
      <div class="assignment-meta">
        <span>${className}</span>
        <span>${escapeHtml(assignment.target_minutes)} 分钟</span>
        <span>${dueDate}</span>
        <span>${checkInText}</span>
      </div>
    `;
    list.appendChild(item);
  });
}

async function restoreTeacherSession() {
  if (!supabaseClient) {
    setTeacherAuthMessage("Supabase 未加载，老师端只能查看页面。");
    return;
  }

  const { data } = await supabaseClient.auth.getUser();
  currentTeacher = data.user;
  renderTeacherAuthState();

  if (currentTeacher) {
    await afterTeacherLogin();
  }
}

document.getElementById("teacher-sign-up-button").addEventListener("click", signUpTeacher);
document.getElementById("teacher-sign-in-button").addEventListener("click", signInTeacher);
document.getElementById("teacher-sign-out-button").addEventListener("click", signOutTeacher);
document.getElementById("save-teacher-profile-button").addEventListener("click", saveTeacherProfile);
document.getElementById("create-class-button").addEventListener("click", createTeacherClass);
document.getElementById("publish-assignment-button").addEventListener("click", publishAssignment);
document.getElementById("refresh-teacher-data-button").addEventListener("click", loadTeacherData);

restoreTeacherSession();
