# 🚀 Deploy na Vercel - Passo a Passo

## ✨ Por que Vercel?

✅ **Grátis** - Até 100GB de banda/mês  
✅ **Automático** - Deploy ao fazer git push  
✅ **Rápido** - Servidores globais  
✅ **Simples** - Interface intuitiva  
✅ **Node.js nativo** - JavaScript puro  
✅ **Logs em tempo real** - Fácil debug

---

## 📋 Pré-requisitos

1. **Conta GitHub** (grátis)

   - https://github.com/signup

2. **Conta Vercel** (grátis)

   - https://vercel.com/signup
   - Vincule com GitHub

3. **Git instalado**
   ```bash
   git --version
   ```

---

## 🔧 Configuração Local (5 minutos)

### 1️⃣ Inicializar repositório Git

```bash
cd c:\Users\Administrador\Desktop\tiktokoficial2

# Se ainda não tiver git
git init

# Configurar usuário
git config user.name "Seu Nome"
git config user.email "seu.email@gmail.com"

# Ou globalmente:
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@gmail.com"
```

### 2️⃣ Criar arquivo .gitignore

```bash
# PowerShell
@"
node_modules/
.env
.env.local
.vercel/
dist/
"@ | Out-File -Encoding UTF8 .gitignore
```

### 3️⃣ Adicionar todos os arquivos

```bash
git add .
git commit -m "Initial commit - TikTok Shop com webhook"
```

### 4️⃣ Criar repositório no GitHub

1. Acesse: https://github.com/new
2. Nome: `tiktok-shop` (ou outro)
3. Descrição: `TikTok Shop com PIX via Webhook`
4. Público ou Privado (sua escolha)
5. Clique "Create repository"

### 5️⃣ Conectar ao GitHub

```bash
# Copie os comandos do GitHub e execute
# Deve ser algo como:

git branch -M main
git remote add origin https://github.com/SEU_USER/tiktok-shop.git
git push -u origin main
```

---

## ☁️ Deploy na Vercel (3 minutos)

### 1️⃣ Conectar GitHub à Vercel

1. Acesse: https://vercel.com/dashboard
2. Clique "Import Project"
3. Selecione "Import Git Repository"
4. Busque por `tiktok-shop` (ou seu repo)
5. Clique "Import"

### 2️⃣ Configurar Projeto

Na tela de importação:

- **Project Name**: `tiktok-shop` ✓
- **Framework**: `Other` (não selecione nada)
- **Build Command**: deixe em branco
- **Output Directory**: deixe em branco

### 3️⃣ Deploy!

Clique "Deploy" e espere 1-2 minutos...

✅ Pronto! Seu webhook está ao vivo!

A URL será algo como: **`https://tiktok-shop.vercel.app`**

---

## 🧪 Testar o Webhook

### URL do Webhook:

```
https://tiktok-shop.vercel.app/api/webhook
```

### Teste com cURL:

```bash
curl -X POST https://tiktok-shop.vercel.app/api/webhook \
  -H "Content-Type: application/json" \
  -d '{
    "event": "payment_approved",
    "transaction_id": "TXN123456",
    "reference": "PED1700000000000",
    "status": "paid",
    "qr_code": "00020126...",
    "amount": 4790,
    "paid_at": "2025-11-22T10:30:00Z",
    "customer": {"name": "Teste"},
    "address": {"city": "São Paulo"},
    "items": []
  }'
```

### Resposta esperada:

```json
{
  "success": true,
  "message": "Novo pedido criado e marcado como pago",
  "order_id": "PED1700000000000",
  "transaction_id": "TXN123456"
}
```

---

## 📊 Ver Logs em Tempo Real

1. Acesse: https://vercel.com/dashboard
2. Clique no seu projeto `tiktok-shop`
3. Aba "Functions" ou "Logs"
4. Veja os logs em tempo real enquanto o webhook é chamado

---

## 🔄 Fazer Atualizações

Depois que tudo está rodando, para fazer alterações:

```bash
# 1. Edite os arquivos localmente
# 2. Commit das mudanças
git add .
git commit -m "Descrição da mudança"

# 3. Push para GitHub
git push

# 4. Vercel faz deploy automaticamente!
```

Acompanhe o deploy em: https://vercel.com/dashboard

---

## ⚙️ Configurar no Paradise Pags

Agora configure seu webhook:

1. Acesse: https://dashboard.paradisepags.com/
2. Configurações → Integrações → Webhooks
3. URL: `https://tiktok-shop.vercel.app/api/webhook`
4. Eventos:
   - ✅ `payment_approved`
   - ✅ `payment_failed` (opcional)
5. Clique "Salvar" ou "Testar"

---

## 🎯 Estrutura de Pastas (Seu Projeto)

```
tiktok-shop/
├── checkout.html                 # Sua página de checkout
├── iphone-product-page.html      # Sua página de produtos
├── assets/                        # Imagens e recursos
├── api/
│   └── webhook.js                # ⭐ Webhook no Vercel
├── package.json                  # Configuração npm
├── vercel.json                   # Configuração Vercel
├── .gitignore                    # O que não enviar ao Git
└── .git/                         # Histórico Git (automático)
```

---

## 📈 Escalabilidade

| Plano  | Requisições/mês | Banda | Preço     |
| ------ | --------------- | ----- | --------- |
| Grátis | Ilimitadas      | 100GB | R$ 0      |
| Pro    | Ilimitadas      | 1TB   | R$ 20/mês |

Grátis é suficiente para lojas pequenas/médias!

---

## 🐛 Troubleshooting

### ❌ "Cannot find module"

**Solução:** Vercel não precisa de node_modules. Está normal.

### ❌ Webhook retorna 404

**Solução:** URL deve ser exatamente:

```
https://seu-projeto.vercel.app/api/webhook
```

### ❌ Erro 500 no webhook

**Solução:**

- Verifique logs no Vercel dashboard
- Confirme credenciais Supabase
- Valide que banco `pedidos` existe

### ❌ Deploy não começa automaticamente

**Solução:**

- Confirme que GitHub está conectado
- Faça um novo push: `git push`
- Aguarde 30 segundos

---

## 🔐 Variáveis de Ambiente (Opcional)

Se quiser adicionar segurança:

1. No Vercel dashboard → Projeto → Settings → Environment Variables
2. Adicione:

   ```
   SUPABASE_URL=https://dcahdux...
   SUPABASE_KEY=eyJhbGc...
   ```

3. Atualize `api/webhook.js`:
   ```javascript
   const SUPABASE_URL = process.env.SUPABASE_URL;
   const SUPABASE_KEY = process.env.SUPABASE_KEY;
   ```

---

## 🌍 Domínio Personalizado (Opcional)

Se quiser `webhook.seusite.com` em vez de `.vercel.app`:

1. Vercel Dashboard → Projeto → Settings → Domains
2. Clique "Add Domain"
3. Digite seu domínio
4. Siga instruções de DNS

---

## 📞 Próximos Passos

- [ ] 1. Criar conta GitHub
- [ ] 2. Criar repositório no GitHub
- [ ] 3. Fazer git push do projeto
- [ ] 4. Conectar GitHub à Vercel
- [ ] 5. Fazer deploy
- [ ] 6. Testar webhook com cURL
- [ ] 7. Configurar URL no Paradise Pags
- [ ] 8. Fazer pagamento de teste
- [ ] 9. Validar dados no Supabase
- [ ] 10. Monitorar logs

---

## ✅ Checklist Final

- [ ] Git inicializado e committed
- [ ] GitHub conectado
- [ ] Vercel app criado
- [ ] URL do webhook funciona
- [ ] Paradise Pags configurado
- [ ] Testes passando
- [ ] Logs visíveis no Vercel

---

## 📚 Recursos

- **Docs Vercel**: https://vercel.com/docs
- **Serverless Functions**: https://vercel.com/docs/concepts/functions/serverless-functions
- **Environment Variables**: https://vercel.com/docs/concepts/projects/environment-variables
- **GitHub + Vercel**: https://vercel.com/docs/concepts/git

---

## ✨ Resultado

✅ Webhook rodando 24/7  
✅ Deploy automático via Git  
✅ Logs em tempo real  
✅ Escalável e confiável  
✅ Grátis!

**Status:** Pronto para produção! 🚀
