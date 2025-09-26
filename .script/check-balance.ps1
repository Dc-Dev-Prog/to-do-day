param(
    [string]$Red,
    [string[]]$Redes = @(),
    [switch]$Testnet,
    [switch]$Mainnet,
    [switch]$Devnet,
    [switch]$Detallado,
    [string]$Address
)

Write-Host "💰 VERIFICADOR DE SALDOS SUI v3.0 (Simplificado)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# Determinar redes a verificar
$redesAVerificar = @()
if ($Testnet) { $redesAVerificar = @("testnet") }
elseif ($Mainnet) { $redesAVerificar = @("mainnet") }
elseif ($Devnet) { $redesAVerificar = @("devnet") }
elseif ($Red) { $redesAVerificar = @($Red) }
elseif ($Redes.Count -gt 0) { $redesAVerificar = $Redes }
else { $redesAVerificar = @("testnet", "mainnet", "devnet") }

Write-Host "🌐 Verificando saldos en: $($redesAVerificar -join ', ')" -ForegroundColor Yellow

# Guardar red actual
$redOriginal = sui client active-env

# Obtener dirección del wallet
if (-not $Address) {
    try {
        $Address = sui client active-address
        Write-Host "📍 Dirección: $Address" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error: No se pudo obtener la dirección del wallet" -ForegroundColor Red
        exit 1
    }
}

# Función para convertir MIST a SUI
function ConvertTo-SUI {
    param([string]$mistValue)
    if ([string]::IsNullOrEmpty($mistValue) -or $mistValue -eq "0") {
        return "0.000000000"
    }
    $suiValue = [decimal]$mistValue / 1000000000
    return $suiValue.ToString("F9")
}

# Función para obtener precio SUI
function Get-SuiPrice {
    try {
        $response = Invoke-RestMethod -Uri "https://api.coingecko.com/api/v3/simple/price?ids=sui&vs_currencies=usd" -TimeoutSec 5
        return [decimal]$response.sui.usd
    }
    catch {
        return 4.0  # Precio por defecto si falla la API
    }
}

# Obtener precio SUI
$suiPrice = Get-SuiPrice
Write-Host "💱 Precio SUI: $($suiPrice.ToString('F4')) USD" -ForegroundColor Green

# Función para verificar saldo en una red específica
function Get-SaldoEnRed {
    param([string]$Red)
    
    Write-Host "`n💰 VERIFICANDO SALDO EN $($Red.ToUpper())..." -ForegroundColor Magenta
    
    # Cambiar a la red si es necesario
    if ($Red -ne $redOriginal) {
        Write-Host "   🔄 Cambiando a $Red..." -ForegroundColor Gray
        sui client switch --env $Red | Out-Null
    }
    
    try {
        # Obtener balance
        $balanceOutput = sui client balance 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "   ❌ Error al obtener balance" -ForegroundColor Red
            return @{
                Red        = $Red
                Error      = $true
                SuiBalance = "0.000000000"
                UsdValue   = "0.00"
                Status     = "❌ Error"
            }
        }
        
        # Parsear balance
        $suiBalance = "0.000000000"
        $balanceText = $balanceOutput -join "`n"
        
        if ($balanceText -match "Sui\s+(\d+)\s+([0-9.]+)\s+SUI") {
            $mistAmount = $matches[1]
            $suiBalance = ConvertTo-SUI -mistValue $mistAmount
        }
        elseif ($balanceText -match "Balance:\s*(\d+)\s*MIST") {
            $mistAmount = $matches[1]
            $suiBalance = ConvertTo-SUI -mistValue $mistAmount
        }
        
        # Calcular USD
        $usdValue = ([decimal]$suiBalance * $suiPrice).ToString('F4')
        
        # Determinar estado
        $status = if ([decimal]$suiBalance -gt 0.1) { "✅ Suficiente" } 
        elseif ([decimal]$suiBalance -gt 0) { "⚠️ Bajo" } 
        else { "❌ Vacío" }
        
        Write-Host "   💰 Saldo: $suiBalance SUI" -ForegroundColor Green
        Write-Host "   💵 Valor: $usdValue USD" -ForegroundColor Cyan
        Write-Host "   📊 Estado: $status" -ForegroundColor $(if ($status.StartsWith("✅")) { "Green" } elseif ($status.StartsWith("⚠️")) { "Yellow" } else { "Red" })
        
        return @{
            Red        = $Red
            Error      = $false
            SuiBalance = $suiBalance
            UsdValue   = $usdValue
            Status     = $status
        }
        
    }
    catch {
        Write-Host "   ❌ Error inesperado: $($_.Exception.Message)" -ForegroundColor Red
        return @{
            Red        = $Red
            Error      = $true
            SuiBalance = "0.000000000"
            UsdValue   = "0.00"
            Status     = "❌ Error"
        }
    }
}

# Función para generar reporte individual por red
function New-ReporteSaldo {
    param(
        [string]$Red,
        [hashtable]$Resultado
    )
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Crear carpeta específica de la red
    $carpetaRed = "docs\reports\balance\$Red"
    if (-not (Test-Path $carpetaRed)) {
        New-Item -Path $carpetaRed -ItemType Directory -Force | Out-Null
    }
    
    $archivo = "$carpetaRed\reporte-balance-$Red-$timestamp.md"
    
    $suiBalance = $Resultado.SuiBalance
    $usdValue = $Resultado.UsdValue
    $status = $Resultado.Status
    $iconoRed = if ($Red -eq "mainnet") { "💎" } elseif ($Red -eq "testnet") { "🧪" } else { "🔧" }
    $iconoEstado = if ($status.StartsWith("✅")) { "✅" } elseif ($status.StartsWith("⚠️")) { "⚠️" } else { "❌" }
    
    if ($Resultado.Error) {
        # Reporte de error
        $contenido = @"
# 💰 Reporte de Saldo SUI - $($Red.ToUpper()) $iconoRed ❌

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | $fecha |
| **🌐 Red** | $($Red.ToUpper()) |
| **👤 Wallet** | ``$Address`` |
| **📊 Estado** | ❌ Error de Conexión |

## 🚫 Error en Consulta

❌ **No se pudo obtener el saldo** en **$($Red.ToUpper())**.

### 💡 Posibles Causas:
- Problemas de conectividad con la red $($Red.ToUpper())
- Red temporalmente no disponible
- Configuración de wallet incorrecta
- Problemas con el CLI de Sui

### 🎯 Soluciones:
1. **Verificar Conectividad**: ``sui client active-env``
2. **Cambiar Red**: ``sui client switch --env $Red``
3. **Reintentar**: ``.\.script\check-balance.ps1 -Red $Red``
4. **Verificar Wallet**: ``sui client active-address``

"@
    }
    else {
        # Reporte exitoso
        $estadoDescripcion = if ([decimal]$suiBalance -gt 0.1) { 
            "🎉 **Excelente balance** para desplegar contratos sin problemas."
        }
        elseif ([decimal]$suiBalance -gt 0) { 
            "⚠️ **Balance bajo** - Considera añadir más SUI antes del despliegue."
        }
        else { 
            "❌ **Sin fondos** - Necesitas añadir SUI para realizar transacciones."
        }
        
        $contenido = @"
# 💰 Reporte de Saldo SUI - $($Red.ToUpper()) $iconoRed

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | $fecha |
| **🌐 Red** | $($Red.ToUpper()) |
| **👤 Wallet** | ``$Address`` |
| **💰 Saldo SUI** | $suiBalance |
| **💵 Valor USD** | $usdValue USD |
| **📊 Estado** | $status $iconoEstado |
| **💱 Precio SUI** | $suiPrice USD |

## 💸 Análisis de Balance

### 📊 Resumen Financiero

| Concepto | Valor | Estado |
|----------|-------|--------|
| **💰 Balance SUI** | $suiBalance | $iconoEstado |
| **💵 Valor en USD** | $usdValue USD | - |
| **📈 Precio Actual SUI** | $suiPrice USD | - |

### 📋 Evaluación del Balance

$estadoDescripcion

"@

        if ([decimal]$suiBalance -eq 0) {
            $contenido += @"

## 💳 Cómo Obtener SUI

"@
            if ($Red -eq "mainnet") {
                $contenido += @"
### 🏪 Mainnet - Comprar SUI Real:
1. **Exchanges Centralizados**: Binance, Coinbase, KuCoin, Bybit
2. **DEX**: SuiSwap, Turbos Finance, Cetus
3. **Bridge**: Wormhole, LayerZero desde otras chains
4. **P2P**: Plataformas de intercambio peer-to-peer

### 💡 Recomendaciones:
- **Mínimo recomendado**: 0.1 SUI (~$0.40 USD)
- **Para múltiples despliegues**: 1+ SUI
- **Considera fees de red**: ~0.02-0.05 SUI por transacción

"@
            }
            else {
                $contenido += @"
### 🚰 $($Red.ToUpper()) - SUI Gratuito:
1. **Faucet Oficial**: [https://faucet.sui.io](https://faucet.sui.io)
2. **Discord Sui**: Canal #devnet-faucet o #testnet-faucet
3. **CLI Command**: ``sui client faucet``
4. **Automático**: Algunos exploradores tienen faucet integrado

### 💡 Notas:
- **SUI gratuito**: Para desarrollo y pruebas únicamente
- **Límite diario**: Generalmente 1-10 SUI por día
- **Reset automático**: Los balances pueden resetearse periódicamente

"@
            }
        }
        elseif ([decimal]$suiBalance -gt 0 -and [decimal]$suiBalance -lt 0.05) {
            $contenido += @"

## ⚠️ Balance Bajo - Recomendaciones

### 💡 Acciones Sugeridas:
1. **Añadir más fondos**: Este balance puede no ser suficiente para despliegues
2. **Calcular costos**: Usa ``.\.script\calcular-costo-despliegue.ps1 -Red $Red``
3. **Hacer pruebas menores**: Tests unitarios o transacciones simples primero

"@
        }
        else {
            $contenido += @"

## ✅ Balance Suficiente - Próximos Pasos

### 🚀 Listo para:
1. **Despliegue de Contratos**: ``.\.script\deploy.ps1``
2. **Actualización de Paquetes**: ``.\.script\upgrade.ps1``
3. **Múltiples Transacciones**: Balance suficiente para operaciones complejas

### 💡 Optimización:
- **Balance actual**: Más que suficiente para la mayoría de operaciones
- **Uso eficiente**: Considera este balance para múltiples despliegues

"@
        }
    }
    
    $contenido += @"

## 🛠️ Herramientas Disponibles

### 💰 Verificación de Balances
``````powershell
# Verificar solo esta red
.\.script\check-balance.ps1 -Red $Red

# Verificar múltiples redes
.\.script\check-balance.ps1 -Redes @("mainnet", "testnet")

# Solo mainnet
.\.script\check-balance.ps1 -SoloMainnet

# Solo testnet  
.\.script\check-balance.ps1 -SoloTestnet

# Solo devnet
.\.script\check-balance.ps1 -SoloDevnet

# Con detalles adicionales
.\.script\check-balance.ps1 -Red $Red -Detallado
``````

### 🚀 Despliegue y Gestión
``````bash
# Calcular costos de despliegue
.\.script\calcular-costo-despliegue.ps1 -Red $Red

# Desplegar contrato
.\.script\deploy.ps1

# Verificar paquetes desplegados
.\.script\check-packages.ps1 -Red $Red

# Actualizar contrato existente
.\.script\upgrade.ps1
``````

### 🌐 Gestión de Redes
``````bash
# Cambiar a esta red
sui client switch --env $Red

# Ver red actual
sui client active-env

# Listar todas las redes
sui client envs

# Ver dirección activa
sui client active-address
``````

## 🔗 Enlaces Útiles

- 🌐 **SUI Explorer**: [https://suiexplorer.com/?network=$Red](https://suiexplorer.com/?network=$Red)
- 👤 **Tu Wallet**: [https://suiexplorer.com/address/$Address?network=$Red](https://suiexplorer.com/address/$Address?network=$Red)
"@

    if ($Red -ne "mainnet") {
        $contenido += @"
- 🚰 **Faucet**: [https://faucet.sui.io](https://faucet.sui.io)
"@
    }
    
    $contenido += @"
- 📚 **Documentación**: [https://docs.sui.io](https://docs.sui.io)
- 💰 **Precio SUI**: [https://coinmarketcap.com/currencies/sui/](https://coinmarketcap.com/currencies/sui/)

## 📄 Información del Reporte

| Campo | Valor |
|-------|-------|
| **🏷️ Versión del Script** | 3.0 (Simplificado) |
| **📅 Generado** | $fecha |
| **🌐 Red Específica** | $($Red.ToUpper()) |
| **💱 Precio SUI** | $suiPrice USD |
| **📊 Análisis** | Individual por Red |

---

*Creado con ❤️ por el equipo de desarrollo de **Dc Studio***
"@

    $contenido | Out-File -FilePath $archivo -Encoding UTF8
    Write-Host "   📁 Reporte generado: $archivo" -ForegroundColor Green
}

# Procesar cada red individualmente
$resultadosGlobales = @()
foreach ($red in $redesAVerificar) {
    $resultado = Get-SaldoEnRed -Red $red
    $resultadosGlobales += $resultado
    
    # Generar reporte inmediatamente para esta red
    New-ReporteSaldo -Red $red -Resultado $resultado
}

# Restaurar red original
sui client switch --env $redOriginal | Out-Null

# Resumen final
$totalSui = ($resultadosGlobales | Where-Object { -not $_.Error } | ForEach-Object { [decimal]$_.SuiBalance } | Measure-Object -Sum).Sum
$totalUsd = $totalSui * $suiPrice
$redesConSaldo = ($resultadosGlobales | Where-Object { -not $_.Error -and [decimal]$_.SuiBalance -gt 0 }).Count

Write-Host "`n📊 RESUMEN FINAL:" -ForegroundColor Cyan
Write-Host "   💰 Total SUI: $($totalSui.ToString('F6'))" -ForegroundColor White
Write-Host "   💵 Total USD: $($totalUsd.ToString('F2'))" -ForegroundColor White
Write-Host "   🌐 Redes con saldo: $redesConSaldo/$($redesAVerificar.Count)" -ForegroundColor White

foreach ($resultado in $resultadosGlobales) {
    if (-not $resultado.Error) {
        $red = $resultado.Red
        $saldo = $resultado.SuiBalance
        $status = $resultado.Status
        $icono = if ($status.StartsWith("✅")) { "✅" } elseif ($status.StartsWith("⚠️")) { "⚠️" } else { "❌" }
        Write-Host "   └─ $red`: $saldo SUI $icono" -ForegroundColor Gray
    }
}

Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Magenta
if ($totalSui -gt 0.1) {
    Write-Host "   • Para desplegar: .\.script\deploy.ps1" -ForegroundColor White
    Write-Host "   • Para calcular costos: .\.script\calcular-costo-despliegue.ps1" -ForegroundColor White
    Write-Host "   • Para verificar paquetes: .\.script\check-packages.ps1" -ForegroundColor White
}
else {
    Write-Host "   • Para fondear testnet: https://faucet.sui.io" -ForegroundColor White
    Write-Host "   • Para fondear devnet: https://faucet.sui.io" -ForegroundColor White
    Write-Host "   • Para comprar SUI mainnet: Exchanges" -ForegroundColor White
}

Write-Host "`n✅ Verificación completa! Reportes guardados en docs\reports\balance\" -ForegroundColor Green