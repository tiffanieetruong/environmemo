-- EnvironMemo: run this once in Supabase -> SQL Editor -> New query -> Run.
-- One table holds every record. coll = collection (pins, posts, players, ...),
-- id = record id, data = the record as JSON.
create table if not exists public.docs (
  coll text not null,
  id text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (coll, id)
);

-- Classroom prototype: anyone with the link can read and write.
-- Fine for a class session; lock this down before using it with the public.
alter table public.docs enable row level security;
drop policy if exists "read docs" on public.docs;
drop policy if exists "add docs" on public.docs;
drop policy if exists "edit docs" on public.docs;
drop policy if exists "delete docs" on public.docs;
create policy "read docs"   on public.docs for select using (true);
create policy "add docs"    on public.docs for insert with check (true);
create policy "edit docs"   on public.docs for update using (true) with check (true);
create policy "delete docs" on public.docs for delete using (true);

-- Live updates to every phone (group walk counts, new posts, invites).
alter table public.docs replica identity full;
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;
