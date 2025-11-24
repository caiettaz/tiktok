# 🔧 Verificação e Configuração da Tabela PEDIDOS

## 1️⃣ Executar o SQL no Supabase

1. Acesse: **https://app.supabase.com**
2. Selecione seu projeto
3. Vá para **SQL Editor**
4. Clique em **New Query**
5. Cole o conteúdo de `CREATE_PEDIDOS_TABLE.sql`
6. Clique em **RUN**

## 2️⃣ Verificar o Fluxo de Envio

### Quando o usuário faz checkout:

1. **Clica "Finalizar Compra"** → Salva em tabela `leads` ✅
2. **Redireciona para checkout.html** → PIX gerado
3. **Pagamento aprovado** → Polling detecta `status === "approved"` → Envia para tabela `pedidos` ✅

### Como verificar no DevTools (F12):

1. Abra **Console**
2. Procure por:
   - `📤 Enviando pedido pago para tabela pedidos:` - Mostra dados sendo enviados
   - `✅ Pedido pago enviado para Supabase com sucesso!` - Sucesso ✅
   - `❌ Erro ao enviar pedido para Supabase:` - Erro ❌

## 3️⃣ Verificar Dados no Supabase

1. Acesse **https://app.supabase.com**
2. Vá para **Editor** → Tabelas
3. Procure por **pedidos**
4. Clique para ver as linhas inseridas

## 4️⃣ Checklist de Validação

- [ ] Tabela `pedidos` foi criada no Supabase
- [ ] RLS policies estão habilitadas
- [ ] Índices foram criados
- [ ] Usuário completou checkout (dados em `leads`)
- [ ] Pagamento foi aprovado
- [ ] Dados aparecem em `pedidos`

## 5️⃣ Campos da Tabela PEDIDOS

| Campo          | Tipo      | Descrição                                       |
| -------------- | --------- | ----------------------------------------------- |
| `id`           | BIGSERIAL | ID único da linha                               |
| `pedido_id`    | VARCHAR   | ID único do pedido (gerado pela Paradise Pags)  |
| `transacao_id` | VARCHAR   | ID da transação                                 |
| `pix_key`      | TEXT      | Código PIX completo                             |
| `nome`         | VARCHAR   | Nome do cliente                                 |
| `cpf`          | VARCHAR   | CPF do cliente                                  |
| `email`        | VARCHAR   | Email do cliente                                |
| `telefone`     | VARCHAR   | Telefone do cliente                             |
| `cep`          | VARCHAR   | CEP de entrega                                  |
| `rua`          | VARCHAR   | Rua de entrega                                  |
| `numero`       | VARCHAR   | Número da casa                                  |
| `complemento`  | VARCHAR   | Complemento (apto, bloco, etc)                  |
| `bairro`       | VARCHAR   | Bairro de entrega                               |
| `cidade`       | VARCHAR   | Cidade de entrega                               |
| `estado`       | VARCHAR   | Estado (UF)                                     |
| `valor_total`  | DECIMAL   | Valor total do pedido                           |
| `total_itens`  | INTEGER   | Quantidade de itens                             |
| `itens`        | JSONB     | Array com detalhes dos itens                    |
| `status`       | VARCHAR   | Status: `pix_paid`, `pix_failed`, `pix_expired` |
| `pago_em`      | TIMESTAMP | Data/hora do pagamento                          |
| `created_at`   | TIMESTAMP | Data de criação                                 |
| `updated_at`   | TIMESTAMP | Data da última atualização                      |

## 6️⃣ Comparação: LEADS vs PEDIDOS

| Aspecto         | LEADS                               | PEDIDOS                                 |
| --------------- | ----------------------------------- | --------------------------------------- |
| **Quando cria** | Ao clicar "Finalizar Compra"        | Quando pagamento é aprovado             |
| **Status**      | `lead`                              | `pix_paid`, `pix_failed`, `pix_expired` |
| **Propósito**   | Capturar interessados               | Registrar vendas confirmadas            |
| **Função**      | Lead magnet, análise abandoned cart | Fulfillment, rastreamento               |

---

## 7️⃣ Troubleshooting

### Se os dados não estão sendo salvos:

1. **Abra o DevTools (F12)** → Console
2. **Procure por erros** como:
   - `❌ Erro ao enviar pedido para Supabase`
   - `❌ Erro ao enviar dados:`
3. **Verifique o erro específico**:

   - Política de segurança (RLS)?
   - Nome da tabela errado?
   - Colunas não existem?
   - Credenciais do Supabase inválidas?

4. **Verifique no checkout.html**:
   - SUPABASE_URL está correto?
   - SUPABASE_KEY está correto?
   - Dados estão sendo formatados corretamente?
