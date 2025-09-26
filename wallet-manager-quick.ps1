# 💼 ACCESO RÁPIDO - WALLET MANAGER SUI
# Ejecuta el wallet manager desde cualquier ubicación

$WalletScript = Join-Path $PSScriptRoot ".script\wallet-manager\wallet-manager.ps1"

if (Test-Path $WalletScript) {
    & $WalletScript @args
} else {
    Write-Host "❌ Error: Wallet manager no encontrado en .script\wallet-manager\" -ForegroundColor Red
    Write-Host "💡 Ejecuta .\install-wallet-manager.ps1 para verificar instalación" -ForegroundColor Yellow
}
