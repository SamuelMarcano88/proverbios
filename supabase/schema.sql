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

drop policy if exists "Users can read their own quiz attempts"
  on public.quiz_attempts;
create policy "Users can read their own quiz attempts"
  on public.quiz_attempts for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can create their own quiz attempts"
  on public.quiz_attempts;
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

drop policy if exists "Users can read their own saved proverbs"
  on public.saved_proverbs;
create policy "Users can read their own saved proverbs"
  on public.saved_proverbs for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can save their own proverbs"
  on public.saved_proverbs;
create policy "Users can save their own proverbs"
  on public.saved_proverbs for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can remove their own saved proverbs"
  on public.saved_proverbs;
create policy "Users can remove their own saved proverbs"
  on public.saved_proverbs for delete
  to authenticated
  using ((select auth.uid()) = user_id);

create table if not exists public.community_posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  author_name text not null,
  content text not null check (char_length(content) between 1 and 1000),
  created_at timestamptz not null default now()
);

create index if not exists community_posts_created_at_idx
  on public.community_posts (created_at desc);

alter table public.community_posts enable row level security;

drop policy if exists "Anyone can read community posts"
  on public.community_posts;
create policy "Anyone can read community posts"
  on public.community_posts for select
  to anon, authenticated
  using (true);

drop policy if exists "Users can create community posts"
  on public.community_posts;
create policy "Users can create community posts"
  on public.community_posts for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete their own community posts"
  on public.community_posts;
create policy "Users can delete their own community posts"
  on public.community_posts for delete
  to authenticated
  using ((select auth.uid()) = user_id);

grant usage on schema public to anon, authenticated;
grant select on table public.community_posts to anon, authenticated;
grant insert, delete on table public.community_posts to authenticated;
