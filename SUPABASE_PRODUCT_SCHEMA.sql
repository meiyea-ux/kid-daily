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

alter table public.children enable row level security;
alter table public.daily_reports enable row level security;
alter table public.app_usage enable row level security;
alter table public.teacher_profiles enable row level security;
alter table public.teacher_classes enable row level security;
alter table public.teacher_assignments enable row level security;
alter table public.teacher_assignment_checkins enable row level security;

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
