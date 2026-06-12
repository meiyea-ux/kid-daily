const supabaseUrl = "https://vjxainvzqawflspdchhg.supabase.co";
const supabasePublishableKey = "sb_publishable_ZpSnxUTDfmVnu0MMGbcjOw_b_icH-Jl";
const supabaseClient = window.supabase
  ? window.supabase.createClient(supabaseUrl, supabasePublishableKey)
  : null;

let currentUser = null;
let myChildren = [];
let myGroups = [];
let selectedGroupId = null;

function setText(id, text) {
  const element = document.getElementById(id);

  if (element) {
    element.textContent = text;
  }
}

function escapeHtml(value) {
  return String(value || "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function groupTypeLabel(type) {
  return type === "school" ? "学校群" : "家庭群";
}

function randomGroupCode() {
  return `KD${Math.random().toString(36).slice(2, 8).toUpperCase()}`;
}

function renderAuthState() {
  const isSignedIn = Boolean(currentUser);
  document.getElementById("groups-content").classList.toggle("locked", !isSignedIn);
  document.getElementById("group-auth-form").style.display = isSignedIn ? "none" : "grid";
  document.getElementById("group-auth-user").style.display = isSignedIn ? "grid" : "none";
  setText("group-user-email", currentUser?.email || "");
}

async function signUp() {
  if (!supabaseClient) {
    setText("group-auth-message", "Supabase 未加载，无法注册。");
    return;
  }

  const email = document.getElementById("group-email").value.trim();
  const password = document.getElementById("group-password").value;

  if (!email || password.length < 6) {
    setText("group-auth-message", "请输入邮箱和至少 6 位密码。");
    return;
  }

  const { error } = await supabaseClient.auth.signUp({ email, password });
  setText("group-auth-message", error ? `注册失败：${error.message}` : "注册成功。请检查邮箱验证，或直接登录。");
}

async function signIn() {
  if (!supabaseClient) {
    setText("group-auth-message", "Supabase 未加载，无法登录。");
    return;
  }

  const email = document.getElementById("group-email").value.trim();
  const password = document.getElementById("group-password").value;
  const { data, error } = await supabaseClient.auth.signInWithPassword({ email, password });

  if (error) {
    setText("group-auth-message", `登录失败：${error.message}`);
    return;
  }

  currentUser = data.user;
  renderAuthState();
  setText("group-auth-message", "已登录群组账号。");
  await loadAllGroupData();
}

async function signOut() {
  await supabaseClient?.auth.signOut();
  currentUser = null;
  myChildren = [];
  myGroups = [];
  selectedGroupId = null;
  renderAuthState();
  renderChildSelect();
  renderGroups();
  renderLeaderboard([]);
}

async function loadChildren() {
  if (!currentUser) return;

  const { data, error } = await supabaseClient
    .from("children")
    .select("id,name")
    .eq("parent_user_id", currentUser.id)
    .order("created_at", { ascending: false });

  if (error) {
    setText("join-group-status", `读取孩子失败：${error.message}`);
    return;
  }

  myChildren = data || [];
  renderChildSelect();
}

function renderChildSelect() {
  const select = document.getElementById("member-child-select");
  select.innerHTML = "";

  const emptyOption = document.createElement("option");
  emptyOption.value = "";
  emptyOption.textContent = myChildren.length ? "不绑定孩子，仅查看" : "暂无孩子，可仅查看";
  select.appendChild(emptyOption);

  myChildren.forEach((child) => {
    const option = document.createElement("option");
    option.value = child.id;
    option.textContent = child.name;
    select.appendChild(option);
  });
}

async function createGroup() {
  if (!currentUser) {
    setText("create-group-status", "请先登录。");
    return;
  }

  const groupName = document.getElementById("new-group-name").value.trim();
  const groupType = document.getElementById("new-group-type").value;
  const description = document.getElementById("new-group-description").value.trim();

  if (!groupName) {
    setText("create-group-status", "请输入群组名称。");
    return;
  }

  const groupCode = randomGroupCode();
  const { data: group, error } = await supabaseClient
    .from("kiddaily_groups")
    .insert({
      owner_user_id: currentUser.id,
      group_name: groupName,
      group_type: groupType,
      group_code: groupCode,
      description
    })
    .select("id")
    .single();

  if (error) {
    setText("create-group-status", `创建失败：${error.message}`);
    return;
  }

  await supabaseClient
    .from("kiddaily_group_members")
    .insert({
      group_id: group.id,
      member_user_id: currentUser.id,
      child_id: null,
      display_name: currentUser.email || "Owner",
      role: "owner"
    });

  document.getElementById("new-group-name").value = "";
  document.getElementById("new-group-description").value = "";
  setText("create-group-status", `群组已创建，群码：${groupCode}`);
  await loadGroups();
}

async function joinGroup() {
  if (!currentUser) {
    setText("join-group-status", "请先登录。");
    return;
  }

  const groupCode = document.getElementById("join-group-code").value.trim().toUpperCase();
  const childId = document.getElementById("member-child-select").value || null;
  const selectedChild = myChildren.find((child) => child.id === childId);
  const displayName = document.getElementById("member-display-name").value.trim() || selectedChild?.name || currentUser.email || "Member";

  if (!groupCode) {
    setText("join-group-status", "请输入群码。");
    return;
  }

  const { error } = await supabaseClient.rpc("join_kiddaily_group", {
    p_group_code: groupCode,
    p_child_id: childId,
    p_display_name: displayName
  });

  if (error) {
    setText("join-group-status", `加入失败：${error.message}`);
    return;
  }

  document.getElementById("join-group-code").value = "";
  setText("join-group-status", "已加入群组。");
  await loadGroups();
}

async function loadGroups() {
  if (!currentUser) return;

  const { data, error } = await supabaseClient
    .from("kiddaily_group_members")
    .select("id, role, display_name, child_id, kiddaily_groups(id, group_name, group_type, group_code, description)")
    .eq("member_user_id", currentUser.id)
    .order("created_at", { ascending: false });

  if (error) {
    setText("leaderboard-status", `读取群组失败：${error.message}`);
    return;
  }

  const seen = new Set();
  myGroups = (data || [])
    .map((membership) => ({
      membershipId: membership.id,
      role: membership.role,
      displayName: membership.display_name,
      childId: membership.child_id,
      ...membership.kiddaily_groups
    }))
    .filter((group) => {
      if (!group.id || seen.has(group.id)) return false;
      seen.add(group.id);
      return true;
    });

  renderGroups();

  if (!selectedGroupId && myGroups.length > 0) {
    selectedGroupId = myGroups[0].id;
    await loadLeaderboard(selectedGroupId);
  }
}

function renderGroups() {
  const list = document.getElementById("group-list");
  list.innerHTML = "";

  if (myGroups.length === 0) {
    list.innerHTML = '<p class="empty-list">还没有群组。你可以创建一个，或用群码加入。</p>';
    return;
  }

  myGroups.forEach((group) => {
    const item = document.createElement("article");
    item.className = `group-list-item${group.id === selectedGroupId ? " active" : ""}`;
    item.innerHTML = `
      <div>
        <span class="assignment-type">${escapeHtml(groupTypeLabel(group.group_type))}</span>
        <strong>${escapeHtml(group.group_name)}</strong>
        <p>${escapeHtml(group.description || "暂无群组说明")}</p>
      </div>
      <div class="teacher-code">
        <span>群码</span>
        <b>${escapeHtml(group.group_code)}</b>
      </div>
    `;
    item.addEventListener("click", async () => {
      selectedGroupId = group.id;
      renderGroups();
      await loadLeaderboard(group.id);
    });
    list.appendChild(item);
  });
}

async function loadLeaderboard(groupId) {
  const group = myGroups.find((item) => item.id === groupId);
  setText("leaderboard-title", group ? `${group.group_name} 排行榜` : "群组排行榜");
  setText("leaderboard-status", "正在读取最近 7 天成绩...");

  const { data, error } = await supabaseClient.rpc("get_kiddaily_group_leaderboard", {
    p_group_id: groupId
  });

  if (error) {
    setText("leaderboard-status", `读取排行榜失败：${error.message}`);
    renderLeaderboard([]);
    return;
  }

  setText("leaderboard-status", "最近 7 天平均成长评分。群组只展示排名分数和记录天数。");
  renderLeaderboard(data || []);
}

function renderLeaderboard(rows) {
  const list = document.getElementById("leaderboard-list");
  list.innerHTML = "";

  if (rows.length === 0) {
    list.innerHTML = '<p class="empty-list">暂无排行数据。成员需要先同步日报。</p>';
    return;
  }

  rows.forEach((row, index) => {
    const item = document.createElement("article");
    item.className = "leaderboard-item";
    item.innerHTML = `
      <div class="rank-badge">${index + 1}</div>
      <div>
        <strong>${escapeHtml(row.display_name)}</strong>
        <p>${row.report_days} 天记录 · 最近 7 天成长评分排名</p>
      </div>
      <div class="leaderboard-score">
        <span>成长评分</span>
        <b>${row.score}</b>
      </div>
    `;
    list.appendChild(item);
  });
}

async function loadAllGroupData() {
  await loadChildren();
  await loadGroups();
}

async function restoreSession() {
  if (!supabaseClient) {
    setText("group-auth-message", "Supabase 未加载，群组功能不可用。");
    return;
  }

  const { data } = await supabaseClient.auth.getUser();
  currentUser = data.user;
  renderAuthState();

  if (currentUser) {
    await loadAllGroupData();
  }
}

document.getElementById("group-sign-up-button").addEventListener("click", signUp);
document.getElementById("group-sign-in-button").addEventListener("click", signIn);
document.getElementById("group-sign-out-button").addEventListener("click", signOut);
document.getElementById("create-group-button").addEventListener("click", createGroup);
document.getElementById("join-group-button").addEventListener("click", joinGroup);
document.getElementById("refresh-groups-button").addEventListener("click", loadAllGroupData);

restoreSession();
