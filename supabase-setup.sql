-- ============================================================
-- HitTrax Progress Tracker — one-time Supabase setup
-- Run in: Supabase dashboard -> your project -> SQL Editor -> New query -> Run
-- Project: https://xuipllbtrsebavtffjdy.supabase.co  (same one Budget/DivTracker use)
--
-- Until this is run the app still works — it just stays on this device
-- ("Local only" pill). After running it, sign in and sessions sync everywhere.
-- ============================================================

create table if not exists public.hittrax (
  user_id     uuid        primary key references auth.users(id) on delete cascade,
  data        jsonb       not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

alter table public.hittrax enable row level security;

-- Each signed-in user can only see and change THEIR OWN row.
drop policy if exists "own hittrax select" on public.hittrax;
drop policy if exists "own hittrax insert" on public.hittrax;
drop policy if exists "own hittrax update" on public.hittrax;
create policy "own hittrax select" on public.hittrax for select using (auth.uid() = user_id);
create policy "own hittrax insert" on public.hittrax for insert with check (auth.uid() = user_id);
create policy "own hittrax update" on public.hittrax for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

grant select, insert, update on public.hittrax to authenticated;

-- ============================================================
-- Nothing else to configure: the Email provider is already enabled for the
-- Budget app, and this uses the same account (same email + password).
-- Optional: Authentication -> URL Configuration -> add
--   https://rustygator5.github.io/hittrax/
-- to the redirect allow-list if you ever use password reset from this app.
-- ============================================================
