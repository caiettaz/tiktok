# 📊 Fluxo de Dados - TikTok Shop

## 1️⃣ TABELA `leads` - Iniciação de Compra

**Quando:** Usuário clica em "Finalizar Compra" no `index.html`
**Função:** `saveLead()` em `index.html`
**Localização:** `index.html` linhas ~4955+

**Dados Enviados:**

```javascript
{
  nome: string,
  cpf: string,
  email: string,
  telefone: string,
  cep: string,
  rua: string,
  numero: string,
  complemento: string,
  bairro: string,
  cidade: string,
  estado: string,
  total_itens: number,
  valor_total: number,
  itens: array,
  status: "lead"
}
```

**Fluxo:**

1. Usuário preenche CPF + Nome + Email + Telefone (modal CPF)
2. Usuário preenche Endereço (modal Endereço)
3. Usuário clica "Finalizar Compra"
4. `goToCheckout()` valida todos os campos
5. `saveLead()` é chamada ✅ **ENVIANDO PARA TABELA `leads`**
6. Redireciona para `checkout.html`

---

## 2️⃣ TABELA `pedidos` - Pagamento Confirmado

**Quando:** Sistema confirma que o pagamento foi aprovado
**Função:** `sendPaidOrderToSupabase()` em `checkout.html`
**Localização:** `checkout.html` linhas ~330+

**Dados Enviados:**

```javascript
{
  pedido_id: string,           // order_id da Paradise Pags
  transacao_id: string,        // transaction_id
  pix_key: string,             // Código PIX completo
  nome: string,
  cpf: string,
  email: string,
  telefone: string,
  cep: string,
  rua: string,
  numero: string,
  complemento: string,
  bairro: string,
  cidade: string,
  estado: string,
  valor_total: number,
  total_itens: number,
  itens: array,
  status: "pix_paid",
  pago_em: timestamp
}
```

**Fluxo:**

1. Usuário está em `checkout.html` com PIX gerado
2. Sistema executa `generatePix()` → `displayPixQrCode()` → `startPaymentPolling()`
3. Polling verifica a cada 5 segundos o status da transação na API Paradise Pags
4. Quando `status === "approved"` → **ENVIANDO PARA TABELA `pedidos`** ✅
5. Limpa localStorage
6. Redireciona para `sucesso.html`

---

## 3️⃣ Estados do Pagamento

| Status          | Descrição                            | Salvo em     |
| --------------- | ------------------------------------ | ------------ |
| `lead`          | Compra iniciada (antes do pagamento) | `leads`      |
| `pix_generated` | PIX gerado (aguardando pagamento)    | localStorage |
| `pix_paid`      | Pagamento confirmado ✅              | `pedidos`    |
| `pix_failed`    | Pagamento recusado ❌                | `pedidos`    |
| `pix_expired`   | PIX expirou (5 min timeout) ⏱️       | `pedidos`    |

---

## 4️⃣ Resumo das Tabelas

### Tabela `leads`

- **Propósito:** Capturar interessados que iniciaram checkout
- **Acionador:** Clique em "Finalizar Compra"
- **Status:** Sempre "lead"
- **Uso:** Gerar lead magnet, emails de follow-up, análise de abandoned cart

### Tabela `pedidos`

- **Propósito:** Registrar pedidos pagos/confirmados
- **Acionador:** Confirmação de pagamento PIX
- **Status:** "pix_paid", "pix_failed", "pix_expired"
- **Uso:** Fulfillment, rastreamento de pedidos, relatórios de vendas

---

## 5️⃣ Dados Separados Corretamente ✅

```
┌─────────────────────────────────────┐
│     Usuário Clica em "Finalizar"    │
└──────────────┬──────────────────────┘
               │
               ▼
    ┌──────────────────────┐
    │   Valida Campos      │
    │  (goToCheckout())    │
    └──────────────┬───────┘
                   │
                   ▼
      ┌────────────────────────┐
      │  saveLead() executada  │
      └──────────┬─────────────┘
                 │
                 ▼
      ┌─────────────────────┐
      │ INSERT EM `leads`  │ ✅ LEADS
      └──────────┬─────────┘
                 │
                 ▼
      ┌─────────────────────┐
      │ Redireciona para    │
      │ checkout.html       │
      └──────────┬─────────┘
                 │
                 ▼
      ┌─────────────────────┐
      │ PIX é gerado        │
      │ startPolling()      │
      └──────────┬─────────┘
                 │
                 ▼
      ┌─────────────────────┐
      │ Aguarda 5s...       │
      │ Verifica Status     │
      │ (cada 5 segundos)   │
      └──────────┬─────────┘
                 │
                 ▼
      ┌─────────────────────┐
      │ Status = "approved" │
      │ ? SIM              │
      └──────────┬─────────┘
                 │
                 ▼
      ┌─────────────────────┐
      │ sendPaidOrder()     │
      │ executada           │
      └──────────┬─────────┘
                 │
                 ▼
      ┌─────────────────────┐
      │ INSERT EM `pedidos` │ ✅ PEDIDOS
      └──────────┬─────────┘
                 │
                 ▼
      ┌─────────────────────┐
      │ Limpa localStorage  │
      │ Redireciona sucesso │
      └─────────────────────┘
```

---

## 6️⃣ Debug Console

Para verificar os dados sendo enviados, abra o DevTools (F12) e veja os logs:

```
📤 Enviando lead para Supabase: {...}
📤 Enviando pedido pago para tabela pedidos: {...}
✅ Lead salvo com sucesso!
✅ Pedido pago enviado para Supabase com sucesso!
```
