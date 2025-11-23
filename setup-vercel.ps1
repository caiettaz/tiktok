# Setup Script para Vercel - Execute este arquivo

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "🚀 Setup TikTok Shop - Vercel" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se está na pasta correta
$current = Get-Location
Write-Host "📁 Pasta atual: $current" -ForegroundColor Yellow

# Verificar Git
Write-Host ""
Write-Host "Verificando Git..." -ForegroundColor Yellow
$gitVersion = git --version 2>$null
if ($gitVersion) {
    Write-Host "✅ Git encontrado: $gitVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Git não encontrado! Instale em: https://git-scm.com/download/win" -ForegroundColor Red
    exit
}

# Verificar se já tem .git
Write-Host ""
if (Test-Path ".\.git") {
    Write-Host "✅ Repositório Git já inicializado" -ForegroundColor Green
} else {
    Write-Host "Inicializando repositório Git..." -ForegroundColor Yellow
    git init
    Write-Host "✅ Repositório inicializado" -ForegroundColor Green
}

# Criar .gitignore
Write-Host ""
Write-Host "Criando .gitignore..." -ForegroundColor Yellow
@"
node_modules/
.env
.env.local
.vercel/
dist/
*.log
"@ | Out-File -Encoding UTF8 .gitignore -Force
Write-Host "✅ .gitignore criado" -ForegroundColor Green

# Configurar Git (opcional)
Write-Host ""
Write-Host "Configurar Git globalmente? (S/N)" -ForegroundColor Cyan
$configGit = Read-Host

if ($configGit -eq "S" -or $configGit -eq "s") {
    Write-Host "Digite seu nome:" -ForegroundColor Cyan
    $name = Read-Host
    
    Write-Host "Digite seu email:" -ForegroundColor Cyan
    $email = Read-Host
    
    git config --global user.name "$name"
    git config --global user.email "$email"
    
    Write-Host "✅ Git configurado com:" -ForegroundColor Green
    Write-Host "   Nome: $name"
    Write-Host "   Email: $email"
}

# Fazer commit
Write-Host ""
Write-Host "Fazendo commit inicial..." -ForegroundColor Yellow
git add .
git commit -m "Initial commit - TikTok Shop com webhook para Vercel"
Write-Host "✅ Commit realizado" -ForegroundColor Green

# Próximos passos
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "✨ Próximos Passos:" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1️⃣  Criar repositório no GitHub:" -ForegroundColor Cyan
Write-Host "    https://github.com/new" -ForegroundColor White
Write-Host ""
Write-Host "2️⃣  Conectar este repositório ao GitHub:" -ForegroundColor Cyan
Write-Host "    git branch -M main" -ForegroundColor White
Write-Host "    git remote add origin https://github.com/SEU_USER/tiktok-shop.git" -ForegroundColor White
Write-Host "    git push -u origin main" -ForegroundColor White
Write-Host ""
Write-Host "3️⃣  Criar conta Vercel e conectar GitHub:" -ForegroundColor Cyan
Write-Host "    https://vercel.com/dashboard" -ForegroundColor White
Write-Host ""
Write-Host "4️⃣  Importar projeto no Vercel:" -ForegroundColor Cyan
Write-Host "    Click 'Import Project' → 'Import Git Repository'" -ForegroundColor White
Write-Host ""
Write-Host "5️⃣  Configurar no Paradise Pags:" -ForegroundColor Cyan
Write-Host "    URL: https://seu-projeto.vercel.app/api/webhook" -ForegroundColor White
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "📖 Leia o guia completo:" -ForegroundColor Yellow
Write-Host "   VERCEL_DEPLOY.md" -ForegroundColor White
Write-Host "=====================================" -ForegroundColor Cyan
