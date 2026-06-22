-- Tables pour synchroniser réservations et avis entre le site public et l'admin.
-- À exécuter une fois dans Supabase : Project > SQL Editor > New query > coller > Run.

create table if not exists reservations (
  id bigint generated always as identity primary key,
  nom text not null,
  tel text,
  salle text not null check (salle in ('lagon', 'tokyo')),
  date date not null,
  heure text not null,
  heure_num numeric,
  nb integer not null default 4,
  montant numeric not null default 0,
  paiement text default 'especes',
  statut text not null default 'en attente' check (statut in ('confirmé', 'en attente', 'annulé')),
  created_at timestamptz not null default now()
);

create table if not exists avis (
  id bigint generated always as identity primary key,
  prenom text not null,
  comment text not null,
  note integer not null check (note between 1 and 5),
  statut text not null default 'en_attente' check (statut in ('en_attente', 'valide')),
  created_at timestamptz not null default now()
);

alter table reservations enable row level security;
alter table avis enable row level security;

-- Le site public et l'admin utilisent tous deux la clé "anon" (pas d'authentification
-- serveur pour l'instant, comme c'était déjà le cas avec le mot de passe client-side).
-- On autorise donc toutes les opérations avec cette clé.
create policy "anon full access reservations" on reservations
  for all using (true) with check (true);

create policy "anon full access avis" on avis
  for all using (true) with check (true);
