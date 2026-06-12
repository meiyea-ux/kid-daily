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

create table if not exists public.child_remote_settings (
  child_id uuid primary key references public.children(id) on delete cascade,
  parent_user_id uuid not null references auth.users(id) on delete cascade,
  math_minutes integer not null default 20,
  english_minutes integer not null default 20,
  reading_minutes integer not null default 15,
  game_minutes_per_task integer not null default 10,
  math_note text not null default 'Practice number skills',
  english_note text not null default 'Learn words and sentences',
  reading_note text not null default 'Read a story or book',
  word_level text not null default 'Gaokao Core',
  daily_word_goal integer not null default 10,
  custom_word_list text not null default '',
  ai_word_prompt text not null default '',
  updated_at timestamptz not null default now()
);

create index if not exists child_remote_settings_parent_idx
on public.child_remote_settings(parent_user_id);

alter table public.child_remote_settings
add column if not exists word_level text not null default 'Gaokao Core';

alter table public.child_remote_settings
add column if not exists daily_word_goal integer not null default 10;

alter table public.child_remote_settings
add column if not exists custom_word_list text not null default '';

alter table public.child_remote_settings
add column if not exists ai_word_prompt text not null default '';

alter table public.child_pairing_codes enable row level security;
alter table public.child_remote_settings enable row level security;

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

drop policy if exists "Parents can read own remote settings" on public.child_remote_settings;
create policy "Parents can read own remote settings"
on public.child_remote_settings
for select
to authenticated
using (auth.uid() = parent_user_id);

drop policy if exists "Parents can insert own remote settings" on public.child_remote_settings;
create policy "Parents can insert own remote settings"
on public.child_remote_settings
for insert
to authenticated
with check (auth.uid() = parent_user_id);

drop policy if exists "Parents can update own remote settings" on public.child_remote_settings;
create policy "Parents can update own remote settings"
on public.child_remote_settings
for update
to authenticated
using (auth.uid() = parent_user_id)
with check (auth.uid() = parent_user_id);

drop function if exists public.get_kiddaily_settings_by_pairing_code(text);

create or replace function public.get_kiddaily_settings_by_pairing_code(p_pairing_code text)
returns table (
  math_minutes integer,
  english_minutes integer,
  reading_minutes integer,
  game_minutes_per_task integer,
  math_note text,
  english_note text,
  reading_note text,
  word_level text,
  daily_word_goal integer,
  custom_word_list text,
  ai_word_prompt text
)
language plpgsql
security definer
set search_path = public
as $$
begin
  return query
  select
    coalesce(settings.math_minutes, 20),
    coalesce(settings.english_minutes, 20),
    coalesce(settings.reading_minutes, 15),
    coalesce(settings.game_minutes_per_task, 10),
    coalesce(settings.math_note, 'Practice number skills'),
    coalesce(settings.english_note, 'Learn words and sentences'),
    coalesce(settings.reading_note, 'Read a story or book'),
    coalesce(settings.word_level, 'Gaokao Core'),
    coalesce(settings.daily_word_goal, 10),
    coalesce(settings.custom_word_list, ''),
    coalesce(settings.ai_word_prompt, '')
  from public.child_pairing_codes codes
  left join public.child_remote_settings settings
    on settings.child_id = codes.child_id
  where codes.pairing_code = upper(trim(p_pairing_code))
    and codes.expires_at > now()
  order by codes.created_at desc
  limit 1;
end;
$$;

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

  score := least(100, greatest(0, p_completed_count * 34));

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

grant execute on function public.get_kiddaily_settings_by_pairing_code(text) to anon, authenticated;
