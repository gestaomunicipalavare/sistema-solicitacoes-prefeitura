-- Execute no SQL Editor de um projeto Supabase novo.
create table if not exists public.administradores (usuario_id uuid primary key references auth.users(id) on delete cascade);
create table if not exists public.solicitacoes (
 id bigint generated always as identity primary key,
 protocolo text not null unique,
 criado_em timestamptz not null default now(),
 nome text not null check (char_length(nome) between 2 and 120),
 telefone text not null check (char_length(telefone) between 5 and 25),
 endereco text not null check (char_length(endereco) between 5 and 200),
 tipo text not null check (tipo in ('Iluminação pública','Buraco em via pública','Poda de árvores','Limpeza urbana','Saneamento','Outros')),
 descricao text not null check (char_length(descricao) between 10 and 1500),
 setor text not null,
 status text not null default 'Pendente' check (status in ('Pendente','Em análise','Em execução','Concluída'))
);
alter table public.administradores enable row level security;
alter table public.solicitacoes enable row level security;
revoke all on public.administradores from anon, authenticated;
revoke all on public.solicitacoes from anon, authenticated;
grant select on public.administradores to authenticated;
grant insert on public.solicitacoes to anon, authenticated;
grant select, update on public.solicitacoes to authenticated;
grant usage, select on sequence public.solicitacoes_id_seq to anon, authenticated;
create policy "Administradores podem consultar seu próprio cadastro" on public.administradores for select to authenticated using (usuario_id = (select auth.uid()));
create policy "Público pode enviar solicitações" on public.solicitacoes for insert to anon, authenticated with check (status = 'Pendente');
create policy "Administradores podem consultar solicitações" on public.solicitacoes for select to authenticated using (exists (select 1 from public.administradores a where a.usuario_id = (select auth.uid())));
create policy "Administradores podem atualizar solicitações" on public.solicitacoes for update to authenticated using (exists (select 1 from public.administradores a where a.usuario_id = (select auth.uid()))) with check (exists (select 1 from public.administradores a where a.usuario_id = (select auth.uid())));
-- Depois de criar uma conta em Authentication > Users, substitua o UUID abaixo
-- e execute separadamente:
-- insert into public.administradores(usuario_id) values ('UUID-DO-USUARIO');
