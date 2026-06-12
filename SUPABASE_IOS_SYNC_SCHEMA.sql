create table if not exists public.child_pairing_codes (
  id uuid primary key default gen_random_uuid(),
  child_id uuid not null references public.children(id) on delete cascade,
  parent_user_id uuid not null references auth.users(id) on delete cascade,
  pairing_code text not null unique,
  expires_at timestamptz not null default (now() + interval '30 minutes'),
  used_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists child_pairing_codes_code_idx
on public.child_pairing_codes(pairing_code);

create index if not exists child_pairing_codes_parent_idx
on public.child_pairing_codes(parent_user_id, created_at desc);

alter table public.child_pairing_codes enable row level security;

drop policy if exists "Parents can read own pairing codes" on public.child_pairing_codes;
create policy "Parents can read own pairing codes"
on public.child_pairing_codes
for select
to authenticated
using (auth.uid() = parent_user_id);

drop policy if exists "Parents can insert own pairing codes" on public.child_pairing_codes;
create policy "Parents can insert own pairing codes"
on public.child_pairing_codes
for insert
to authenticated
with check (auth.uid() = parent_user_id);

drop policy if exists "Parents can update own pairing codes" on public.child_pairing_codes;
create policy "Parents can update own pairing codes"
on public.child_pairing_codes
for update
to authenticated
using (auth.uid() = parent_user_id)
with check (auth.uid() = parent_user_id);

create or replace function public.upload_kiddaily_record_by_pairing_code(
  p_pairing_code text,
  p_report_date date,
  p_math_completed boolean,
  p_english_completed boolean,
  p_reading_completed boolean,
  p_completed_count integer,
  p_game_time_minutes integer,
  p_learning_minutes integer default 0,
  p_entertainment_minutes integer default 0,
  p_reading_minutes integer default 0
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  code_row public.child_pairing_codes%rowtype;
  report_id uuid;
  score integer;
  rating_text text;
begin
  select *
  into code_row
  from public.child_pairing_codes
  where pairing_code = upper(trim(p_pairing_code))
    and expires_at > now()
  order by created_at desc
  limit 1;

  if not found then
    raise exception 'Invalid or expired pairing code';
  end if;

  score := least(100, greatest(0, p_completed_count * 25 + case when p_game_time_minutes > 0 then 25 else 0 end));

  if score >= 80 then
    rating_text := '优秀';
  elsif score >= 60 then
    rating_text := '良好';
  else
    rating_text := '需关注';
  end if;

  insert into public.daily_reports (
    child_id,
    parent_user_id,
    report_date,
    total_minutes,
    learning_minutes,
    entertainment_minutes,
    reading_minutes,
    growth_score,
    rating,
    ai_comment
  )
  values (
    code_row.child_id,
    code_row.parent_user_id,
    p_report_date,
    greatest(0, p_learning_minutes + p_entertainment_minutes + p_reading_minutes),
    greatest(0, p_learning_minutes),
    greatest(0, p_entertainment_minutes),
    greatest(0, p_reading_minutes),
    score,
    rating_text,
    '来自 KidDaily iOS 儿童端同步：完成 ' || p_completed_count || ' 个任务，获得 ' || p_game_time_minutes || ' 分钟游戏时间。'
  )
  on conflict (child_id, report_date)
  do update set
    total_minutes = excluded.total_minutes,
    learning_minutes = excluded.learning_minutes,
    entertainment_minutes = excluded.entertainment_minutes,
    reading_minutes = excluded.reading_minutes,
    growth_score = excluded.growth_score,
    rating = excluded.rating,
    ai_comment = excluded.ai_comment,
    updated_at = now()
  returning id into report_id;

  return report_id;
end;
$$;

grant execute on function public.upload_kiddaily_record_by_pairing_code(
  text,
  date,
  boolean,
  boolean,
  boolean,
  integer,
  integer,
  integer,
  integer,
  integer
) to anon, authenticated;
