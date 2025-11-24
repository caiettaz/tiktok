-- Criar tabela pedidos
CREATE TABLE IF NOT EXISTS public.pedidos (
  id BIGSERIAL PRIMARY KEY,
  pedido_id VARCHAR(255) UNIQUE NOT NULL,
  transacao_id VARCHAR(255),
  pix_key TEXT,
  nome VARCHAR(255),
  cpf VARCHAR(20),
  email VARCHAR(255),
  telefone VARCHAR(20),
  cep VARCHAR(10),
  rua VARCHAR(255),
  numero VARCHAR(10),
  complemento VARCHAR(255),
  bairro VARCHAR(255),
  cidade VARCHAR(255),
  estado VARCHAR(2),
  valor_total DECIMAL(10, 2),
  total_itens INTEGER,
  itens JSONB,
  status VARCHAR(50),
  pago_em TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Criar índices para melhorar performance
CREATE INDEX IF NOT EXISTS idx_pedidos_cpf ON public.pedidos(cpf);
CREATE INDEX IF NOT EXISTS idx_pedidos_email ON public.pedidos(email);
CREATE INDEX IF NOT EXISTS idx_pedidos_status ON public.pedidos(status);
CREATE INDEX IF NOT EXISTS idx_pedidos_created_at ON public.pedidos(created_at);
CREATE INDEX IF NOT EXISTS idx_pedidos_pedido_id ON public.pedidos(pedido_id);

-- Habilitar RLS (Row Level Security)
ALTER TABLE public.pedidos ENABLE ROW LEVEL SECURITY;

-- Política para permitir INSERT anônimo
CREATE POLICY "Allow anonymous insert on pedidos" ON public.pedidos
  FOR INSERT
  WITH CHECK (true);

-- Política para permitir SELECT anônimo
CREATE POLICY "Allow anonymous select on pedidos" ON public.pedidos
  FOR SELECT
  USING (true);

-- Política para permitir UPDATE anônimo
CREATE POLICY "Allow anonymous update on pedidos" ON public.pedidos
  FOR UPDATE
  USING (true);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION public.update_pedidos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_pedidos_updated_at_trigger
BEFORE UPDATE ON public.pedidos
FOR EACH ROW
EXECUTE FUNCTION public.update_pedidos_updated_at();
