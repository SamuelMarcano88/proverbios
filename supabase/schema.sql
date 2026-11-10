create table if not exists public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  profile text not null check (profile in ('wise', 'simple', 'foolish')),
  scores jsonb not null,
  created_at timestamptz not null default now()
);

create index if not exists quiz_attempts_user_created_at_idx
  on public.quiz_attempts (user_id, created_at desc);

alter table public.quiz_attempts enable row level security;

create policy "Users can read their own quiz attempts"
  on public.quiz_attempts for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "Users can create their own quiz attempts"
  on public.quiz_attempts for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create table if not exists public.saved_proverbs (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  proverb_id text not null,
  reference text not null,
  text text not null,
  created_at timestamptz not null default now(),
  primary key (user_id, proverb_id)
);

alter table public.saved_proverbs enable row level security;

create policy "Users can read their own saved proverbs"
  on public.saved_proverbs for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "Users can save their own proverbs"
  on public.saved_proverbs for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "Users can remove their own saved proverbs"
  on public.saved_proverbs for delete
  to authenticated
  using ((select auth.uid()) = user_id);
