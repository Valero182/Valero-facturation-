-- VALERO HÔTEL — Schéma Supabase
-- À exécuter dans Supabase > SQL Editor, une seule fois.
create extension if not exists pgcrypto;

create table if not exists public.hotel_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  name text not null default 'Valero Hôtel',
  phone text default '20 25 03 91',
  address text default 'Zogbohoué, Cotonou, Bénin',
  ifu text,
  rccm text,
  updated_at timestamptz not null default now()
);

create table if not exists public.invoices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  invoice_number text unique,
  doc_type text not null check (doc_type in ('Facture','Pro forma')),
  client text not null,
  client_phone text,
  client_ifu text,
  client_address text,
  doc_date date not null default current_date,
  category text,
  description text not null,
  quantity numeric(12,2) not null default 1,
  unit_price numeric(14,2) not null default 0,
  discount numeric(14,2) not null default 0,
  tax_rate numeric(6,2) not null default 0,
  tax_amount numeric(14,2) not null default 0,
  total numeric(14,2) not null default 0,
  paid numeric(14,2) not null default 0,
  payment_method text,
  notes text,
  created_at timestamptz not null default now()
);

create index if not exists invoices_user_date_idx on public.invoices(user_id, created_at desc);

alter table public.hotel_settings enable row level security;
alter table public.invoices enable row level security;

drop policy if exists "settings own rows" on public.hotel_settings;
create policy "settings own rows" on public.hotel_settings
for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "invoices own rows" on public.invoices;
create policy "invoices own rows" on public.invoices
for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Numérotation automatique par utilisateur et année.
create or replace function public.assign_invoice_number()
returns trigger language plpgsql security definer set search_path = public
as $$
declare next_num bigint;
begin
  if new.invoice_number is null or new.invoice_number = '' then
    perform pg_advisory_xact_lock(hashtext(new.user_id::text));
    select count(*) + 1 into next_num
    from public.invoices
    where user_id = new.user_id
      and extract(year from doc_date) = extract(year from new.doc_date);
    new.invoice_number := 'VH-' || extract(year from new.doc_date)::int || '-' || lpad(next_num::text, 4, '0');
  end if;
  return new;
end;
$$;

drop trigger if exists invoices_number_trigger on public.invoices;
create trigger invoices_number_trigger
before insert on public.invoices
for each row execute function public.assign_invoice_number();
