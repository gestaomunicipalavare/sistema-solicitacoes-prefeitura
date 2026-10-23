-- Execute uma única vez no SQL Editor do Supabase.
-- Autoriza somente administradores cadastrados a excluir solicitações.
GRANT DELETE ON TABLE public.solicitacoes TO authenticated;
DROP POLICY IF EXISTS "Administradores podem excluir solicitações" ON public.solicitacoes;
CREATE POLICY "Administradores podem excluir solicitações"
ON public.solicitacoes
FOR DELETE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.administradores a
    WHERE a.usuario_id = (SELECT auth.uid())
  )
);
