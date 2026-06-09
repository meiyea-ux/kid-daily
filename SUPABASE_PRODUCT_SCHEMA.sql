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

create index if not exists children_parent_user_id_idx
on public.children(parent_user_id);

create index if not exists daily_reports_parent_date_idx
on public.daily_reports(parent_user_id, report_date desc);

create index if not exists app_usage_report_id_idx
on public.app_usage(report_id);

alter table public.children enable row level security;
alter table public.daily_reports enable row level security;
alter table public.app_usage enable row level security;

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
