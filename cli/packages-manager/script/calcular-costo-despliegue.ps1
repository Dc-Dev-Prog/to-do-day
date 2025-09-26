param(
    [string]$Red,
    [string[]]$Redes = @(),
    [switch]$Testnet,
    [switch]$Mainnet,
    [switch]$Devnet,
    [decimal]$PrecioSUI = 4.0,
    [switch]$MostrarDetalle,
    [ValidateSet("ambos", "solo-despliegue", "solo-actualizacion")]
    [string]$Tipo = "ambos"
)

Write-Host "💰 CALCULADORA DE COSTOS SUI v2.0 (Simplificado)" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# Verificar si estamos en el directorio correcto
if (-not (Test-Path "Move.toml")) {
    Write-Host "❌ Error: No se encuentra Move.toml. Ejecuta desde el directorio del proyecto." -ForegroundColor Red
    exit 1
}

# Determinar redes a calcular
$redesACalcular = @()
if ($Testnet) { $redesACalcular = @("testnet") }
elseif ($Mainnet) { $redesACalcular = @("mainnet") }
elseif ($Devnet) { $redesACalcular = @("devnet") }
elseif ($Red) { $redesACalcular = @($Red) }
elseif ($Redes.Count -gt 0) { $redesACalcular = $Redes }
else { 
    # Por defecto usar la red activa
    $redActiva = sui client active-env
    $redesACalcular = @($redActiva) 
}

Write-Host "🌐 Calculando costos para: $($redesACalcular -join ', ')" -ForegroundColor Yellow

# Guardar red actual
$redOriginal = sui client active-env

# Datos reales del último despliegue (mainnet 25/09/2025)
$MIST_TO_SUI = 0.000000001
$DEPLOYMENT_REAL_DATA = @{
    "StorageCost"      = 21432000
    "ComputationCost"  = 495000
    "StorageRebate"    = 978120
    "NonRefundableFee" = 9880
    "GasPrice"         = 495
    "TotalPaid"        = 20948880
}

# Función para calcular costos en una red específica
function Get-CostoEnRed {
    param([string]$Red)
    
    Write-Host "`n💰 CALCULANDO COSTOS EN $($Red.ToUpper())..." -ForegroundColor Magenta
    
    # Cambiar a la red si es necesario
    if ($Red -ne $redOriginal) {
        Write-Host "   🔄 Cambiando a $Red..." -ForegroundColor Gray
        sui client switch --env $Red | Out-Null
    }
    
    try {
        # Compilar proyecto
        Write-Host "   🔨 Compilando proyecto..." -ForegroundColor Yellow
        $compilacion = sui move build 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "   ❌ Error en la compilación" -ForegroundColor Red
            return @{
                Red     = $Red
                Error   = $true
                Mensaje = "Error en compilación"
            }
        }
        
        Write-Host "   ✅ Compilación exitosa" -ForegroundColor Green
        
        # Leer proyecto info
        $moveToml = Get-Content "Move.toml" -Raw
        $nombreProyecto = ($moveToml | Select-String 'name\s*=\s*"([^"]+)"').Matches[0].Groups[1].Value
        
        # Cálculos basados en datos reales
        $costoComputacionReal = $DEPLOYMENT_REAL_DATA.ComputationCost * $MIST_TO_SUI
        $costoAlmacenamientoReal = $DEPLOYMENT_REAL_DATA.StorageCost * $MIST_TO_SUI
        $costoDespliegueReal = ($DEPLOYMENT_REAL_DATA.StorageCost + $DEPLOYMENT_REAL_DATA.ComputationCost) * $MIST_TO_SUI
        $costoNetoReal = $DEPLOYMENT_REAL_DATA.TotalPaid * $MIST_TO_SUI
        
        # Estimaciones mejoradas
        $factorSeguridad = if ($Red -eq "mainnet") { 2.5 } else { 2.0 } # Testnet/devnet algo más económicas
        $costoActualizacionEstimado = $costoDespliegueReal * 0.23
        
        $costoDespliegue = $costoDespliegueReal * $factorSeguridad
        $costoActualizacion = $costoActualizacionEstimado * $factorSeguridad
        
        # Verificar balance actual
        $balance = sui client balance 2>&1 | Out-String
        $balanceActual = if ($balance -match "(\d+\.?\d*)\s+SUI") { [decimal]$Matches[1] } else { 0 }
        
        # Presupuesto recomendado
        $presupuestoRecomendado = [math]::Max(0.05, [math]::Ceiling($costoDespliegue * 10) / 10)
        $diferenciaBalance = $presupuestoRecomendado - $balanceActual
        
        Write-Host "   ✅ Cálculo completado para $Red" -ForegroundColor Green
        
        return @{
            Red                    = $Red
            Error                  = $false
            NombreProyecto         = $nombreProyecto
            CostoComputacion       = $costoComputacionReal
            CostoAlmacenamiento    = $costoAlmacenamientoReal
            CostoDespliegue        = $costoDespliegue
            CostoActualizacion     = $costoActualizacion
            CostoNetoReal          = $costoNetoReal
            BalanceActual          = $balanceActual
            PresupuestoRecomendado = $presupuestoRecomendado
            DiferenciaBalance      = $diferenciaBalance
            FactorSeguridad        = $factorSeguridad
        }
        
    }
    catch {
        Write-Host "   ❌ Error calculando $Red`: $($_.Exception.Message)" -ForegroundColor Red
        return @{
            Red     = $Red
            Error   = $true
            Mensaje = $_.Exception.Message
        }
    }
}

# Función para generar reporte individual por red
function New-ReporteCosto {
    param(
        [string]$Red,
        [hashtable]$Resultado
    )
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Crear carpeta específica de la red
    $carpetaRed = Join-Path (Split-Path $PSScriptRoot) "reports\calcular-costo\$Red"
    if (-not (Test-Path $carpetaRed)) {
        New-Item -Path $carpetaRed -ItemType Directory -Force | Out-Null
    }
    
    $archivo = "$carpetaRed\reporte-costos-$Red-$timestamp.md"
    
    # Obtener wallet
    $walletOutput = sui client active-address 2>$null
    $wallet = $walletOutput.Trim()
    
    if ($Resultado.Error) {
        # Reporte de error
        $contenido = @"
# 💰 Reporte de Costos SUI - $($Red.ToUpper()) ❌

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | $fecha |
| **🌐 Red** | $($Red.ToUpper()) |
| **👤 Wallet** | ``$wallet`` |
| **📊 Estado** | ❌ Error |

## 🚫 Error en Cálculo

❌ **No se pudo calcular el costo de despliegue** en **$($Red.ToUpper())**.

### 💡 Mensaje de Error:
``````
$($Resultado.Mensaje)
``````

### 🎯 Posibles Soluciones:
1. **Verificar Move.toml**: Asegúrate de estar en el directorio del proyecto
2. **Compilación**: Revisa errores de sintaxis en el código Move
3. **Red**: Verifica conectividad a $($Red.ToUpper())
4. **Dependencies**: Revisa las dependencias en Move.toml

"@
    }
    else {
        # Reporte exitoso
        $costoDespliegueUSD = $Resultado.CostoDespliegue * $PrecioSUI
        $costoActualizacionUSD = $Resultado.CostoActualizacion * $PrecioSUI
        $costoRealUSD = $Resultado.CostoNetoReal * $PrecioSUI
        
        $estadoBalance = if ($Resultado.DiferenciaBalance -gt 0) { "⚠️ Insuficiente" } else { "✅ Suficiente" }
        $iconoRed = if ($Red -eq "mainnet") { "💎" } else { "🧪" }
        
        $contenido = @"
# 💰 Reporte de Costos SUI - $($Red.ToUpper()) $iconoRed

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | $fecha |
| **🌐 Red** | $($Red.ToUpper()) |
| **👤 Wallet** | ``$wallet`` |
| **📦 Proyecto** | $($Resultado.NombreProyecto) |
| **💰 Balance Actual** | $($Resultado.BalanceActual) SUI |
| **📊 Estado Balance** | $estadoBalance |

## 💸 Análisis de Costos

### 🔨 Despliegue Inicial

| Concepto | SUI | USD (@ $PrecioSUI) |
|----------|-----|-----|
| **Cómputo** | $($Resultado.CostoComputacion.ToString('F6')) | $($($Resultado.CostoComputacion * $PrecioSUI).ToString('F4')) |
| **Almacenamiento** | $($Resultado.CostoAlmacenamiento.ToString('F6')) | $($($Resultado.CostoAlmacenamiento * $PrecioSUI).ToString('F4')) |
| **📦 Total Estimado** | **$($Resultado.CostoDespliegue.ToString('F6'))** | **$($costoDespliegueUSD.ToString('F4'))** |
| **✅ Último Real** | $($Resultado.CostoNetoReal.ToString('F6')) | $($costoRealUSD.ToString('F4')) |

### 🔄 Actualización de Contratos

| Concepto | SUI | USD (@ $PrecioSUI) |
|----------|-----|-----|
| **🔄 Actualización Estimada** | **$($Resultado.CostoActualizacion.ToString('F6'))** | **$($costoActualizacionUSD.ToString('F4'))** |

### 💡 Recomendaciones de Presupuesto

| Concepto | Valor | Estado |
|----------|-------|--------|
| **💡 Presupuesto Recomendado** | $($Resultado.PresupuestoRecomendado) SUI | - |
| **💰 Tu Balance Actual** | $($Resultado.BalanceActual) SUI | - |
| **📊 Diferencia** | $($Resultado.DiferenciaBalance.ToString('F4')) SUI | $(if ($Resultado.DiferenciaBalance -gt 0) { "⚠️ Necesitas más" } else { "✅ Tienes suficiente" }) |

"@

        if ($Resultado.DiferenciaBalance -gt 0) {
            $contenido += @"

## ⚠️ Fondos Insuficientes

❌ **Necesitas más SUI** para el despliegue en **$($Red.ToUpper())**.

### 💳 Cómo Obtener SUI:
"@
            if ($Red -eq "mainnet") {
                $contenido += @"
1. **🏪 Exchanges**: Binance, Coinbase, KuCoin, etc.
2. **🔄 Bridge**: Desde otras blockchains
3. **💱 DEX**: SuiSwap, Turbos Finance
4. **💰 Mínimo necesario**: $($Resultado.DiferenciaBalance.ToString('F4')) SUI adicionales

"@
            }
            else {
                $contenido += @"
1. **🚰 Faucet**: [SUI Devnet Faucet](https://docs.sui.io/guides/developer/getting-sui)
2. **🌐 Discord**: Canal #devnet-faucet en Discord de Sui
3. **🔄 CLI**: ``sui client faucet``
4. **💰 Mínimo necesario**: $($Resultado.DiferenciaBalance.ToString('F4')) SUI adicionales

"@
            }
        }
        else {
            $contenido += @"

## ✅ Fondos Suficientes

🎉 **Tienes suficiente SUI** para el despliegue en **$($Red.ToUpper())**.

### 🚀 Próximos Pasos:
1. **Compilar**: ``sui move build``
2. **Desplegar**: ``.\.script\deploy.ps1``
3. **Verificar**: ``.\.script\check-packages.ps1 -Red $Red``

"@
        }
    }
    
    $contenido += @"

## 🛠️ Herramientas Disponibles

### 💰 Cálculo de Costos
``````powershell
# Calcular costos en esta red
.\.script\calcular-costo-despliegue-v2.ps1 -Red $Red

# Solo costo de despliegue
.\.script\calcular-costo-despliegue-v2.ps1 -Red $Red -Tipo solo-despliegue

# Solo costo de actualización
.\.script\calcular-costo-despliegue-v2.ps1 -Red $Red -Tipo solo-actualizacion

# Con detalles técnicos
.\.script\calcular-costo-despliegue-v2.ps1 -Red $Red -MostrarDetalle

# Precio personalizado de SUI
.\.script\calcular-costo-despliegue-v2.ps1 -Red $Red -PrecioSUI 5.0
``````

### 🚀 Despliegue y Gestión
``````bash
# Desplegar contrato
.\.script\deploy.ps1

# Verificar paquetes
.\.script\check-packages.ps1 -Red $Red

# Verificar balances
.\.script\check-balance.ps1 -Solo$($Red.Substring(0,1).ToUpper() + $Red.Substring(1))

# Actualizar contrato existente
.\.script\upgrade.ps1
``````

### 🌐 Cambio de Redes
``````bash
# Cambiar a esta red
sui client switch --env $Red

# Listar redes disponibles
sui client envs

# Ver red actual
sui client active-env
``````

## 📊 Información Técnica

| Campo | Valor |
|-------|-------|
| **🏷️ Factor de Seguridad** | $($Resultado.FactorSeguridad)x |
| **📅 Datos Basados En** | Despliegue Real 25/09/2025 |
| **🔗 TX Real** | HHcAMN7czxSVJMeMkpzfoTKuDSPF9ZW2D24ETh253uSq |
| **⚡ Precisión** | Datos reales de mainnet |

## 🔗 Enlaces Útiles

- 🌐 **SUI Explorer**: [https://suiexplorer.com/?network=$Red](https://suiexplorer.com/?network=$Red)
- 👤 **Tu Wallet**: [https://suiexplorer.com/address/$wallet?network=$Red](https://suiexplorer.com/address/$wallet?network=$Red)
- 📚 **Documentación**: [https://docs.sui.io](https://docs.sui.io)
- 💰 **Precios SUI**: [https://coinmarketcap.com/currencies/sui/](https://coinmarketcap.com/currencies/sui/)

## 📄 Información del Reporte

| Campo | Valor |
|-------|-------|
| **🏷️ Versión del Script** | 2.0 (Simplificado) |
| **📅 Generado** | $fecha |
| **🌐 Red Específica** | $($Red.ToUpper()) |
| **💰 Precio SUI** | $PrecioSUI USD |
| **📊 Tipo de Cálculo** | $Tipo |

---

**Creado con ❤️ por el equipo de desarrollo de [Dc Studio]()**
"@

    $contenido | Out-File -FilePath $archivo -Encoding UTF8
    Write-Host "   📁 Reporte generado: $archivo" -ForegroundColor Green
}

# Procesar cada red individualmente
$resultadosGlobales = @()
foreach ($red in $redesACalcular) {
    $resultado = Get-CostoEnRed -Red $red
    $resultadosGlobales += $resultado
    
    # Generar reporte inmediatamente para esta red
    New-ReporteCosto -Red $red -Resultado $resultado
}

# Limpiar carpeta build después del cálculo
if (Test-Path "build") {
    Write-Host "`n🗑️ Limpiando carpeta build..." -ForegroundColor Yellow
    Remove-Item -Path "build" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "   ✅ Carpeta build eliminada" -ForegroundColor Green
}

# Restaurar red original
sui client switch --env $redOriginal | Out-Null

# Resumen final
Write-Host "`n📊 RESUMEN FINAL:" -ForegroundColor Cyan
Write-Host "   🌐 Redes calculadas: $($redesACalcular.Count)" -ForegroundColor White
Write-Host "   💰 Precio SUI usado: $PrecioSUI USD" -ForegroundColor White

foreach ($resultado in $resultadosGlobales) {
    if (-not $resultado.Error) {
        $red = $resultado.Red
        $costo = $resultado.CostoDespliegue.ToString('F4')
        $balance = $resultado.BalanceActual
        $suficiente = if ($resultado.DiferenciaBalance -le 0) { "✅" } else { "⚠️" }
        Write-Host "   └─ $red`: ~$costo SUI ($balance SUI disponible) $suficiente" -ForegroundColor Gray
    }
}

Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Magenta
Write-Host "   • Para desplegar: .\.script\deploy.ps1" -ForegroundColor White
Write-Host "   • Para verificar paquetes: .\.script\check-packages.ps1" -ForegroundColor White
Write-Host "   • Para verificar balances: .\.script\check-balance.ps1" -ForegroundColor White

Write-Host "`n✅ Cálculo completo! Reportes guardados en .\reports\calcular-costo\" -ForegroundColor Green
Write-Host "`n**Creado con ❤️ por el equipo de desarrollo de Dc Studio**" -ForegroundColor Magenta