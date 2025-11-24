-- Script para criar/atualizar tabela "leads" no Supabase
-- Execute no Supabase SQL Editor

-- Caso a tabela já exista, delete-a primeiro (CUIDADO: isso deleta todos os dados!)
-- DROP TABLE IF EXISTS leads CASCADE;

-- Criar tabela leads
CREATE TABLE IF NOT EXISTS leads (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    email VARCHAR(255),
    telefone VARCHAR(20) NOT NULL,
    cep VARCHAR(10),
    rua VARCHAR(255),
    numero VARCHAR(10),
    complemento VARCHAR(255),
    bairro VARCHAR(255),
    cidade VARCHAR(255),
    estado VARCHAR(2),
    total_itens INTEGER DEFAULT 0,
    valor_total DECIMAL(10, 2) DEFAULT 0,
    itens JSONB,
    status VARCHAR(50) DEFAULT 'lead',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_leads_cpf ON leads(cpf);
CREATE INDEX IF NOT EXISTS idx_leads_telefone ON leads(telefone);
CREATE INDEX IF NOT EXISTS idx_leads_email ON leads(email);
CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);
CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads(created_at DESC);

-- Criar RLS (Row Level Security)
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

-- Permitir INSERT de qualquer pessoa (anon user)
DROP POLICY IF EXISTS "Allow insert leads" ON leads;
CREATE POLICY "Allow insert leads" 
  ON leads 
  FOR INSERT 
  WITH CHECK (true);

-- Permitir SELECT para todos
DROP POLICY IF EXISTS "Allow select leads" ON leads;
CREATE POLICY "Allow select leads" 
  ON leads 
  FOR SELECT 
  USING (true);

-- Criar trigger para atualizar updated_at automaticamente
DROP FUNCTION IF EXISTS update_leads_updated_at() CASCADE;
CREATE OR REPLACE FUNCTION update_leads_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_leads_updated_at ON leads;
CREATE TRIGGER update_leads_updated_at
  BEFORE UPDATE ON leads
  FOR EACH ROW
  EXECUTE FUNCTION update_leads_updated_at();

-- Pronto! A tabela está criada e pronta para usar.
