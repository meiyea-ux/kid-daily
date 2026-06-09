create table if not exists public.kid_daily_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  reports jsonb not null default '[]'::jsonb,
  selected_child_index integer not null default 0,
  updated_at timestamptz not null default now()
);

alter table public.kid_daily_user_data enable row level security;

drop policy if exists "Users can read own Kid Daily data" on public.kid_daily_user_data;
create policy "Users can read own Kid Daily data"
on public.kid_daily_user_data
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert own Kid Daily data" on public.kid_daily_user_data;
create policy "Users can insert own Kid Daily data"
on public.kid_daily_user_data
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update own Kid Daily data" on public.kid_daily_user_data;
create policy "Users can update own Kid Daily data"
on public.kid_daily_user_data
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists set_kid_daily_user_data_updated_at on public.kid_daily_user_data;
create trigger set_kid_daily_user_data_updated_at
before update on public.kid_daily_user_data
for each row
execute function public.set_updated_at();
