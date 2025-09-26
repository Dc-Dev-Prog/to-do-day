# 📦 ACCESO RÁPIDO - PACKAGES MANAGER SUI
# Ejecuta los scripts de gestión de paquetes desde cualquier ubicación

param(
    [Parameter(Position=0)]
    [string]$Comando = "",
    
    [string]$Red = "",
    [switch]$DEMO,
    [switch]$Help,
    [switch]$Lista
)

$PackagesDir = Join-Path $PSScriptRoot ".script\packages-manager"

if ($Help -or $Comando -eq "help") {
    Write-Host "
📦 PACKAGES MANAGER SUI - ACCESO RÁPIDO
======================================

USO:
    .\packages-manager-quick.ps1 <comando> [parámetros]

COMANDOS DISPONIBLES:
    deploy          🚀 Desplegar paquetes
    upgrade         🔄 Actualizar paquetes existentes
    check           📦 Verificar paquetes desplegados
    inspect         🔍 Inspeccionar paquete específico
    cost            💰 Calcular costos de despliegue

PARÁMETROS COMUNES:
    -Red <red>      Red específica (mainnet/testnet/devnet)
    -DEMO           Modo demostración (sin transacciones)
    -Help           Mostrar esta ayuda

EJEMPLOS:
    .\packages-manager-quick.ps1 deploy -Red testnet
    .\packages-manager-quick.ps1 check -Red all
    .\packages-manager-quick.ps1 upgrade -DEMO
    .\packages-manager-quick.ps1 inspect
    .\packages-manager-quick.ps1 cost -Red mainnet

UBICACIÓN:
    Scripts: .\.script\packages-manager\
    Reportes: .\.script\packages-manager\reports\
" -ForegroundColor Green
    return
}

if (-not (Test-Path $PackagesDir)) {
    Write-Host "❌ Error: Directorio packages-manager no encontrado" -ForegroundColor Red
    Write-Host "📍 Se esperaba en: $PackagesDir" -ForegroundColor Yellow
    return
}

switch ($Comando.ToLower()) {
    "deploy" {
        $scriptPath = Join-Path $PackagesDir "deploy.ps1"
        $args = @()
        if ($Red) { $args += @("-Red", $Red) }
        if ($DEMO) { $args += "-DEMO" }
        & $scriptPath @args
    }
    
    "upgrade" {
        $scriptPath = Join-Path $PackagesDir "upgrade.ps1" 
        $args = @()
        if ($Red) { $args += @("-Red", $Red) }
        if ($DEMO) { $args += "-DEMO" }
        & $scriptPath @args
    }
    
    "check" {
        $scriptPath = Join-Path $PackagesDir "check-packages.ps1"
        $args = @()
        if ($Red) { $args += @("-Red", $Red) }
        & $scriptPath @args
    }
    
    "inspect" {
        $scriptPath = Join-Path $PackagesDir "inspect-package.ps1"
        $args = @()
        if ($Red) { $args += @("-Red", $Red) }
        & $scriptPath @args
    }
    
    "cost" {
        $scriptPath = Join-Path $PackagesDir "calcular-costo-despliegue.ps1"
        $args = @()
        if ($Red) { $args += @("-Red", $Red) }
        & $scriptPath @args
    }
    
    "" {
        # Menú interactivo
        Write-Host "
📦 PACKAGES MANAGER SUI
=====================

🎯 Selecciona una operación:" -ForegroundColor Cyan
        Write-Host "[1] 🚀 Deploy - Desplegar paquetes" -ForegroundColor White
        Write-Host "[2] 🔄 Upgrade - Actualizar paquetes" -ForegroundColor White
        Write-Host "[3] 📦 Check - Verificar paquetes" -ForegroundColor White
        Write-Host "[4] 🔍 Inspect - Inspeccionar paquete" -ForegroundColor White
        Write-Host "[5] 💰 Cost - Calcular costos" -ForegroundColor White
        Write-Host "[0] ❌ Salir" -ForegroundColor Yellow
        
        Write-Host -NoNewline "`nIngresa opción (0-5): " -ForegroundColor Cyan
        $choice = $Host.UI.ReadLine()
        
        switch ($choice.Trim()) {
            "1" { & $PSCommandPath "deploy" }
            "2" { & $PSCommandPath "upgrade" }
            "3" { & $PSCommandPath "check" }
            "4" { & $PSCommandPath "inspect" }
            "5" { & $PSCommandPath "cost" }
            "0" { Write-Host "`n👋 ¡Hasta luego!" -ForegroundColor Green }
            default { Write-Host "`n❌ Opción inválida" -ForegroundColor Red }
        }
    }
    
    default {
        Write-Host "❌ Comando desconocido: $Comando" -ForegroundColor Red
        Write-Host "💡 Use -Help para ver comandos disponibles" -ForegroundColor Yellow
    }
}