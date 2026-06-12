create table if not exists public.children (
  id uuid primary key default gen_random_uuid(),
  parent_user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  device_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.daily_reports (
  id uuid primary key default gen_random_uuid(),
  child_id uuid not null references public.children(id) on delete cascade,
  parent_user_id uuid not null references auth.users(id) on delete cascade,
  report_date date not null,
  total_minutes integer not null default 0,
  learning_minutes integer not null default 0,
  entertainment_minutes integer not null default 0,
  reading_minutes integer not null default 0,
  growth_score integer not null default 0,
  rating text not null default '需关注',
  ai_comment text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (child_id, report_date)
);

create table if not exists public.app_usage (
  id uuid primary key default gen_random_uuid(),
  report_id uuid not null references public.daily_reports(id) on delete cascade,
  parent_user_id uuid not null references auth.users(id) on delete cascade,
  child_id uuid not null references public.children(id) on delete cascade,
  app_name text not null,
  category text not null default '娱乐',
  minutes integer not null default 0,
  start_time time,
  end_time time,
  created_at timestamptz not null default now()
);

create table if not exists public.teacher_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'Teacher',
  school_name text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.teacher_classes (
  id uuid primary key default gen_random_uuid(),
  teacher_user_id uuid not null references auth.users(id) on delete cascade,
  class_name text not null,
  class_code text not null unique,
  description text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.teacher_assignments (
  id uuid primary key default gen_random_uuid(),
  teacher_user_id uuid not null references auth.users(id) on delete cascade,
  class_id uuid references public.teacher_classes(id) on delete cascade,
  assignment_type text not null default 'study',
  title text not null,
  description text not null default '',
  resource_url text not null default '',
  target_minutes integer not null default 20,
  due_date date,
  requires_check_in boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.teacher_assignment_checkins (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.teacher_assignments(id) on delete cascade,
  child_id uuid references public.children(id) on delete set null,
  parent_user_id uuid references auth.users(id) on delete set null,
  student_name text not null default '',
  checkin_status text not null default 'submitted',
  checkin_note text not null default '',
  evidence_url text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.kiddaily_groups (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null references auth.users(id) on delete cascade,
  group_name text not null,
  group_type text not null default 'family',
  group_code text not null unique,
  description text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.kiddaily_group_members (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.kiddaily_groups(id) on delete cascade,
  member_user_id uuid not null references auth.users(id) on delete cascade,
  child_id uuid references public.children(id) on delete set null,
  display_name text not null,
  role text not null default 'member',
  created_at timestamptz not null default now(),
  unique (group_id, member_user_id, child_id)
);

create index if not exists children_parent_user_id_idx
on public.children(parent_user_id);

create index if not exists daily_reports_parent_date_idx
on public.daily_reports(parent_user_id, report_date desc);

create index if not exists app_usage_report_id_idx
on public.app_usage(report_id);

create index if not exists teacher_classes_teacher_idx
on public.teacher_classes(teacher_user_id, created_at desc);

create index if not exists teacher_assignments_teacher_idx
on public.teacher_assignments(teacher_user_id, created_at desc);

create index if not exists teacher_assignments_class_idx
on public.teacher_assignments(class_id, created_at desc);

create index if not exists teacher_checkins_assignment_idx
on public.teacher_assignment_checkins(assignment_id, created_at desc);

create index if not exists kiddaily_groups_owner_idx
on public.kiddaily_groups(owner_user_id, created_at desc);

create index if not exists kiddaily_groups_code_idx
on public.kiddaily_groups(group_code);

create index if not exists kiddaily_group_members_user_idx
on public.kiddaily_group_members(member_user_id, created_at desc);

create index if not exists kiddaily_group_members_group_idx
on public.kiddaily_group_members(group_id, created_at desc);

alter table public.children enable row level security;
alter table public.daily_reports enable row level security;
alter table public.app_usage enable row level security;
alter table public.teacher_profiles enable row level security;
alter table public.teacher_classes enable row level security;
alter table public.teacher_assignments enable row level security;
alter table public.teacher_assignment_checkins enable row level security;
alter table public.kiddaily_groups enable row level security;
alter table public.kiddaily_group_members enable row level security;

drop policy if exists "Parents can read own children" on public.children;
create policy "Parents can read own children"
on public.children
for select
to authenticated
using (auth.uid() = parent_user_id);

drop policy if exists "Parents can insert own children" on public.children;
create policy "Parents can insert own children"
on public.children
for insert
to authenticated
with check (auth.uid() = parent_user_id);

drop policy if exists "Parents can update own children" on public.children;
create policy "Parents can update own children"
on public.children
for update
to authenticated
using (auth.uid() = parent_user_id)
with check (auth.uid() = parent_user_id);

drop policy if exists "Parents can delete own children" on public.children;
create policy "Parents can delete own children"
on public.children
for delete
to authenticated
using (auth.uid() = parent_user_id);

drop policy if exists "Parents can read own daily reports" on public.daily_reports;
create policy "Parents can read own daily reports"
on public.daily_reports
for select
to authenticated
using (auth.uid() = parent_user_id);

drop policy if exists "Parents can insert own daily reports" on public.daily_reports;
create policy "Parents can insert own daily reports"
on public.daily_reports
for insert
to authenticated
with check (auth.uid() = parent_user_id);

drop policy if exists "Parents can update own daily reports" on public.daily_reports;
create policy "Parents can update own daily reports"
on public.daily_reports
for update
to authenticated
using (auth.uid() = parent_user_id)
with check (auth.uid() = parent_user_id);

drop policy if exists "Parents can delete own daily reports" on public.daily_reports;
create policy "Parents can delete own daily reports"
on public.daily_reports
for delete
to authenticated
using (auth.uid() = parent_user_id);

drop policy if exists "Parents can read own app usage" on public.app_usage;
create policy "Parents can read own app usage"
on public.app_usage
for select
to authenticated
using (auth.uid() = parent_user_id);

drop policy if exists "Parents can insert own app usage" on public.app_usage;
create policy "Parents can insert own app usage"
on public.app_usage
for insert
to authenticated
with check (auth.uid() = parent_user_id);

drop policy if exists "Parents can update own app usage" on public.app_usage;
create policy "Parents can update own app usage"
on public.app_usage
for update
to authenticated
using (auth.uid() = parent_user_id)
with check (auth.uid() = parent_user_id);

drop policy if exists "Parents can delete own app usage" on public.app_usage;
create policy "Parents can delete own app usage"
on public.app_usage
for delete
to authenticated
using (auth.uid() = parent_user_id);

drop policy if exists "Teachers can read own profile" on public.teacher_profiles;
create policy "Teachers can read own profile"
on public.teacher_profiles
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Teachers can insert own profile" on public.teacher_profiles;
create policy "Teachers can insert own profile"
on public.teacher_profiles
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Teachers can update own profile" on public.teacher_profiles;
create policy "Teachers can update own profile"
on public.teacher_profiles
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Teachers can read own classes" on public.teacher_classes;
create policy "Teachers can read own classes"
on public.teacher_classes
for select
to authenticated
using (auth.uid() = teacher_user_id);

drop policy if exists "Teachers can insert own classes" on public.teacher_classes;
create policy "Teachers can insert own classes"
on public.teacher_classes
for insert
to authenticated
with check (auth.uid() = teacher_user_id);

drop policy if exists "Teachers can update own classes" on public.teacher_classes;
create policy "Teachers can update own classes"
on public.teacher_classes
for update
to authenticated
using (auth.uid() = teacher_user_id)
with check (auth.uid() = teacher_user_id);

drop policy if exists "Teachers can delete own classes" on public.teacher_classes;
create policy "Teachers can delete own classes"
on public.teacher_classes
for delete
to authenticated
using (auth.uid() = teacher_user_id);

drop policy if exists "Teachers can read own assignments" on public.teacher_assignments;
create policy "Teachers can read own assignments"
on public.teacher_assignments
for select
to authenticated
using (auth.uid() = teacher_user_id);

drop policy if exists "Teachers can insert own assignments" on public.teacher_assignments;
create policy "Teachers can insert own assignments"
on public.teacher_assignments
for insert
to authenticated
with check (auth.uid() = teacher_user_id);

drop policy if exists "Teachers can update own assignments" on public.teacher_assignments;
create policy "Teachers can update own assignments"
on public.teacher_assignments
for update
to authenticated
using (auth.uid() = teacher_user_id)
with check (auth.uid() = teacher_user_id);

drop policy if exists "Teachers can delete own assignments" on public.teacher_assignments;
create policy "Teachers can delete own assignments"
on public.teacher_assignments
for delete
to authenticated
using (auth.uid() = teacher_user_id);

drop policy if exists "Teachers can read own assignment checkins" on public.teacher_assignment_checkins;
create policy "Teachers can read own assignment checkins"
on public.teacher_assignment_checkins
for select
to authenticated
using (
  exists (
    select 1
    from public.teacher_assignments assignments
    where assignments.id = teacher_assignment_checkins.assignment_id
      and assignments.teacher_user_id = auth.uid()
  )
);

drop policy if exists "Parents can insert child assignment checkins" on public.teacher_assignment_checkins;
create policy "Parents can insert child assignment checkins"
on public.teacher_assignment_checkins
for insert
to authenticated
with check (auth.uid() = parent_user_id);

drop policy if exists "Parents can read own child assignment checkins" on public.teacher_assignment_checkins;
create policy "Parents can read own child assignment checkins"
on public.teacher_assignment_checkins
for select
to authenticated
using (auth.uid() = parent_user_id);

drop policy if exists "Group members can read accessible groups" on public.kiddaily_groups;
create policy "Group members can read accessible groups"
on public.kiddaily_groups
for select
to authenticated
using (
  auth.uid() = owner_user_id
  or exists (
    select 1
    from public.kiddaily_group_members members
    where members.group_id = kiddaily_groups.id
      and members.member_user_id = auth.uid()
  )
);

drop policy if exists "Users can create own groups" on public.kiddaily_groups;
create policy "Users can create own groups"
on public.kiddaily_groups
for insert
to authenticated
with check (auth.uid() = owner_user_id);

drop policy if exists "Owners can update own groups" on public.kiddaily_groups;
create policy "Owners can update own groups"
on public.kiddaily_groups
for update
to authenticated
using (auth.uid() = owner_user_id)
with check (auth.uid() = owner_user_id);

drop policy if exists "Members can read group memberships" on public.kiddaily_group_members;
create policy "Members can read group memberships"
on public.kiddaily_group_members
for select
to authenticated
using (member_user_id = auth.uid());

drop policy if exists "Users can insert own memberships" on public.kiddaily_group_members;
create policy "Users can insert own memberships"
on public.kiddaily_group_members
for insert
to authenticated
with check (auth.uid() = member_user_id);

drop function if exists public.join_kiddaily_group(text, uuid, text);

create or replace function public.join_kiddaily_group(
  p_group_code text,
  p_child_id uuid,
  p_display_name text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  target_group_id uuid;
  membership_id uuid;
begin
  select id
  into target_group_id
  from public.kiddaily_groups
  where group_code = upper(trim(p_group_code))
  limit 1;

  if target_group_id is null then
    raise exception 'Group code not found';
  end if;

  if p_child_id is not null and not exists (
    select 1
    from public.children
    where id = p_child_id
      and parent_user_id = auth.uid()
  ) then
    raise exception 'Child does not belong to current user';
  end if;

  insert into public.kiddaily_group_members (
    group_id,
    member_user_id,
    child_id,
    display_name,
    role
  )
  values (
    target_group_id,
    auth.uid(),
    p_child_id,
    coalesce(nullif(trim(p_display_name), ''), 'Member'),
    'member'
  )
  on conflict (group_id, member_user_id, child_id)
  do update set display_name = excluded.display_name
  returning id into membership_id;

  return membership_id;
end;
$$;

drop function if exists public.get_kiddaily_group_leaderboard(uuid);

create or replace function public.get_kiddaily_group_leaderboard(p_group_id uuid)
returns table (
  member_id uuid,
  display_name text,
  child_id uuid,
  score integer,
  report_days integer
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (
    select 1
    from public.kiddaily_group_members members
    where members.group_id = p_group_id
      and members.member_user_id = auth.uid()
  ) and not exists (
    select 1
    from public.kiddaily_groups groups
    where groups.id = p_group_id
      and groups.owner_user_id = auth.uid()
  ) then
    raise exception 'Not a member of this group';
  end if;

  return query
  select
    members.id,
    members.display_name,
    members.child_id,
    coalesce(round(avg(reports.growth_score))::integer, 0) as score,
    count(reports.id)::integer as report_days
  from public.kiddaily_group_members members
  left join public.children children
    on children.id = members.child_id
  left join public.daily_reports reports
    on reports.child_id = members.child_id
   and reports.parent_user_id = children.parent_user_id
   and reports.report_date >= current_date - interval '7 days'
  where members.group_id = p_group_id
  group by members.id, members.display_name, members.child_id
  order by score desc, report_days desc;
end;
$$;

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists set_children_updated_at on public.children;
create trigger set_children_updated_at
before update on public.children
for each row
execute function public.set_updated_at();

drop trigger if exists set_daily_reports_updated_at on public.daily_reports;
create trigger set_daily_reports_updated_at
before update on public.daily_reports
for each row
execute function public.set_updated_at();

drop trigger if exists set_teacher_profiles_updated_at on public.teacher_profiles;
create trigger set_teacher_profiles_updated_at
before update on public.teacher_profiles
for each row
execute function public.set_updated_at();

drop trigger if exists set_teacher_classes_updated_at on public.teacher_classes;
create trigger set_teacher_classes_updated_at
before update on public.teacher_classes
for each row
execute function public.set_updated_at();

drop trigger if exists set_teacher_assignments_updated_at on public.teacher_assignments;
create trigger set_teacher_assignments_updated_at
before update on public.teacher_assignments
for each row
execute function public.set_updated_at();

drop trigger if exists set_kiddaily_groups_updated_at on public.kiddaily_groups;
create trigger set_kiddaily_groups_updated_at
before update on public.kiddaily_groups
for each row
execute function public.set_updated_at();

grant execute on function public.join_kiddaily_group(text, uuid, text) to authenticated;
grant execute on function public.get_kiddaily_group_leaderboard(uuid) to authenticated;
