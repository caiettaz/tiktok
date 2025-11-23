# Script para simular pagamento aprovado no Paradise Pags
# Uso: .\test-payment-simulation.ps1 -external_id "PED1234567890"

param(
    [string]$external_id = "PED$(Get-Date -Format 'yyyyMMddHHmmss')",
    [int]$amount = 4790,
    [string]$webhook_url = "https://tiktok-eight-ebon.vercel.app/api/webhook"
)

Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Simulador de Pagamento - Paradise Pags      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Cyan

# 1️⃣ Simular resposta aprovada do Paradise Pags via webhook
$payload = @{
    transaction_id = "$(Get-Random -Minimum 1000 -Maximum 9999)"
    external_id = $external_id
    status = "approved"
    amount = $amount
    payment_method = "pix"
    customer = @{
        name = "Cliente Teste"
        email = "teste@example.com"
        document = "12345678900"
        phone = "11999999999"
    }
    raw_status = "COMPLETED"
    webhook_type = "transaction"
    timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    tracking = @{
        utm_source = "Teste"
        utm_campaign = "Teste"
    }
} | ConvertTo-Json

Write-Host "`n📤 Enviando webhook para: $webhook_url" -ForegroundColor Yellow
Write-Host "📦 Payload:" -ForegroundColor Yellow
Write-Host ($payload | ConvertFrom-Json | ConvertTo-Json -Depth 10) -ForegroundColor Gray

try {
    $response = Invoke-WebRequest -Uri $webhook_url `
        -Method POST `
        -Headers @{
            "Content-Type" = "application/json"
            "X-API-Key" = "sk_26f533607b3a028e53340190a840d766b6e021c606e80fa7d1cacd7c1803e3e8"
        } `
        -Body $payload `
        -UseBasicParsing

    Write-Host "`n✅ Webhook enviado com sucesso!" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Resposta: $($response.Content)" -ForegroundColor Green

} catch {
    Write-Host "`n❌ Erro ao enviar webhook:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

# 2️⃣ Verificar status via API Paradise Pags
Write-Host "`n" -ForegroundColor Gray
Write-Host "═" * 48 -ForegroundColor Gray
Write-Host "`n🔍 Consultando status via API Paradise Pags..." -ForegroundColor Yellow

$query_url = "https://multi.paradisepags.com/api/v1/query.php?action=list_transactions&external_id=$external_id"

try {
    $query_response = Invoke-WebRequest -Uri $query_url `
        -Method GET `
        -Headers @{
            "X-API-Key" = "sk_26f533607b3a028e53340190a840d766b6e021c606e80fa7d1cacd7c1803e3e8"
            "Content-Type" = "application/json"
        } `
        -UseBasicParsing

    $transactions = $query_response.Content | ConvertFrom-Json
    
    if ($transactions.Count -gt 0) {
        Write-Host "✅ Transações encontradas:" -ForegroundColor Green
        Write-Host ($transactions | ConvertTo-Json -Depth 10) -ForegroundColor Green
    } else {
        Write-Host "⚠️  Nenhuma transação encontrada com external_id: $external_id" -ForegroundColor Yellow
    }

} catch {
    Write-Host "❌ Erro ao consultar API:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host "`n" -ForegroundColor Gray
Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Teste concluído!                             ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Cyan
