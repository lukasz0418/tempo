-- ---------------------------------------------------------------------------
-- Tempo — schemat backendu (Supabase / Postgres)
--
-- Odwzorowanie lokalnego SQLite. Zasady, które muszą się zgadzać po obu
-- stronach, bo na nich stoi cała synchronizacja:
--
--   * `id` to UUID generowany PRZEZ KLIENTA. Serwer go nie nadaje — dzięki
--     temu rekord powstaje offline i nie trzeba potem przepisywać relacji.
--     Stąd brak `default gen_random_uuid()`: wartość zawsze przychodzi z apki.
--   * `updated_at` rozstrzyga konflikty (wygrywa nowszy zapis).
--   * `deleted` to tombstone. Nigdy nie kasujemy wierszy fizycznie —
--     bez nagrobka usunięcie z telefonu nie dotarłoby do PC.
--   * `dirty` istnieje TYLKO lokalnie i nie ma go w tych tabelach.
--     Oznacza „niewysłane na serwer", więc na serwerze nie ma sensu.
--
-- Uruchom w SQL Editor w panelu Supabase.
-- ---------------------------------------------------------------------------

-- Wszystkie tabele mają user_id wskazujące na zalogowanego użytkownika.
-- Aplikacja jest jednoosobowa, ale RLS i tak opiera się na tej kolumnie —
-- to jedyne zabezpieczenie przed odczytaniem cudzych danych, gdyby
-- projekt kiedyś obsłużył więcej niż jedno konto.

create table if not exists categories (
  id                   uuid primary key,
  user_id              uuid not null references auth.users(id) on delete cascade,
  name                 text not null,
  color                integer not null,
  icon                 text,
  default_productivity text not null default 'neutral',
  archived             boolean not null default false,
  sort_order           integer not null default 0,
  created_at           timestamptz not null,
  updated_at           timestamptz not null,
  deleted              boolean not null default false
);

create table if not exists tasks (
  id                         uuid primary key,
  user_id                    uuid not null references auth.users(id) on delete cascade,
  title                      text not null,
  notes                      text,
  category_id                uuid references categories(id),
  parent_id                  uuid,
  estimate_min_seconds       integer,
  estimate_max_seconds       integer,
  estimate_was_suggested     boolean not null default false,
  status                     text not null default 'inbox',
  energy                     text,
  context                    text,
  priority                   integer not null default 0,
  due_at                     timestamptz,
  start_at                   timestamptz,
  -- Data kalendarzowa bez strefy: „wtorek" ma zostać wtorkiem
  -- niezależnie od tego, gdzie jesteś.
  planned_for                date,
  completed_at               timestamptz,
  recurrence_rule            text,
  recurrence_from_completion boolean not null default true,
  postponed_count            integer not null default 0,
  sort_order                 integer not null default 0,
  created_at                 timestamptz not null,
  updated_at                 timestamptz not null,
  deleted                    boolean not null default false
);

create table if not exists time_entries (
  id           uuid primary key,
  user_id      uuid not null references auth.users(id) on delete cascade,
  task_id      uuid references tasks(id),
  category_id  uuid references categories(id),
  description  text not null default '',
  started_at   timestamptz not null,
  -- NULL = stoper wciąż chodzi. Świadomie bez ograniczenia
  -- „najwyżej jeden otwarty": przy synchronizacji dwóch urządzeń
  -- przejściowo mogą istnieć dwa i lepiej je pogodzić w aplikacji,
  -- niż odrzucić zapis i stracić pomiar.
  ended_at     timestamptz,
  productivity text,
  mood_after   integer,
  energy_after integer,
  source       text not null default 'timer',
  device_id    text not null default '',
  created_at   timestamptz not null,
  updated_at   timestamptz not null,
  deleted      boolean not null default false
);

create table if not exists app_usages (
  id               uuid primary key,
  user_id          uuid not null references auth.users(id) on delete cascade,
  device_id        text not null,
  platform         text not null default 'unknown',
  app_id           text not null,
  app_name         text not null default '',
  window_title     text,
  started_at       timestamptz not null,
  ended_at         timestamptz not null,
  duration_seconds integer not null,
  productivity     text not null default 'unknown',
  rule_id          text,
  category_id      uuid references categories(id),
  reviewed         boolean not null default false,
  time_entry_id    uuid references time_entries(id),
  idle             boolean not null default false,
  created_at       timestamptz not null,
  updated_at       timestamptz not null,
  deleted          boolean not null default false
);

create table if not exists activity_rules (
  id           uuid primary key,
  user_id      uuid not null references auth.users(id) on delete cascade,
  label        text not null default '',
  match_target text not null default 'appId',
  match_type   text not null default 'contains',
  pattern      text not null,
  platform     text,
  productivity text not null,
  category_id  uuid references categories(id),
  priority     integer not null default 0,
  enabled      boolean not null default true,
  is_builtin   boolean not null default false,
  created_at   timestamptz not null,
  updated_at   timestamptz not null,
  deleted      boolean not null default false
);

create table if not exists ideas (
  id            uuid primary key,
  user_id       uuid not null references auth.users(id) on delete cascade,
  title         text not null,
  body          text,
  kind          text not null default 'feature',
  status        text not null default 'inbox',
  impact        integer,
  effort        integer,
  tags          text not null default '',
  exported_at   timestamptz,
  source_screen text,
  created_at    timestamptz not null,
  updated_at    timestamptz not null,
  deleted       boolean not null default false
);

create table if not exists day_plans (
  id                uuid primary key,
  user_id           uuid not null references auth.users(id) on delete cascade,
  date              date not null,
  available_minutes integer,
  intention         text,
  wins              text,
  struggles         text,
  change_tomorrow   text,
  mood_end          integer,
  reviewed_at       timestamptz,
  created_at        timestamptz not null,
  updated_at        timestamptz not null,
  deleted           boolean not null default false,
  unique (user_id, date)
);

create table if not exists devices (
  id           uuid primary key,
  user_id      uuid not null references auth.users(id) on delete cascade,
  name         text not null,
  platform     text not null,
  last_seen_at timestamptz not null,
  created_at   timestamptz not null,
  updated_at   timestamptz not null,
  deleted      boolean not null default false
);

-- ---------------------------------------------------------------------------
-- Indeksy
--
-- Najważniejsze są te na (user_id, updated_at): po nich chodzi KAŻDY pull,
-- czyli zapytanie „daj wszystko zmienione od czasu X". Bez nich synchronizacja
-- skanuje całą tabelę przy każdym uruchomieniu aplikacji.
-- ---------------------------------------------------------------------------

create index if not exists idx_categories_sync    on categories(user_id, updated_at);
create index if not exists idx_tasks_sync         on tasks(user_id, updated_at);
create index if not exists idx_time_entries_sync  on time_entries(user_id, updated_at);
create index if not exists idx_app_usages_sync    on app_usages(user_id, updated_at);
create index if not exists idx_rules_sync         on activity_rules(user_id, updated_at);
create index if not exists idx_ideas_sync         on ideas(user_id, updated_at);
create index if not exists idx_day_plans_sync     on day_plans(user_id, updated_at);
create index if not exists idx_devices_sync       on devices(user_id, updated_at);

-- Zapytania statystyczne chodzą po czasie startu, nie po updated_at.
create index if not exists idx_time_entries_started on time_entries(user_id, started_at);
create index if not exists idx_app_usages_started   on app_usages(user_id, started_at);

-- ---------------------------------------------------------------------------
-- Row Level Security
--
-- Włączane na każdej tabeli osobno. Bez tego anonimowy klucz Supabase
-- (który siedzi w aplikacji i jest z natury publiczny) daje dostęp
-- do wszystkich wierszy — to najczęstszy błąd konfiguracyjny w projektach
-- na Supabase.
-- ---------------------------------------------------------------------------

do $$
declare
  t text;
begin
  foreach t in array array[
    'categories', 'tasks', 'time_entries', 'app_usages',
    'activity_rules', 'ideas', 'day_plans', 'devices'
  ] loop
    execute format('alter table %I enable row level security', t);

    execute format($f$
      create policy %I on %I
        for all
        to authenticated
        using (user_id = (select auth.uid()))
        with check (user_id = (select auth.uid()))
    $f$, t || '_owner', t);
  end loop;
end $$;

-- ---------------------------------------------------------------------------
-- Uwaga na koniec: darmowy projekt Supabase jest usypiany po tygodniu
-- bezczynności i trzeba go wtedy wznowić ręcznie w panelu. Przy aplikacji
-- używanej codziennie to bez znaczenia, ale po dłuższym urlopie pierwsza
-- synchronizacja się nie uda i będzie to wyglądać na błąd aplikacji.
-- ---------------------------------------------------------------------------
