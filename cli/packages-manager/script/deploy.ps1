param(
    [string]$Red,
    [string[]]$Redes = @(),
    [switch]$Testnet,
    [switch]$Mainnet,
    [switch]$Devnet,
    [switch]$ConActualizacion,
    [switch]$SinActualizacion,
    [switch]$Demo,
    [string]$GasBudget = "100000000"
)

Write-Host "🚀 DEPLOY SUI v4.0 (Simplificado)" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Determinar redes para desplegar
$redesADesplegar = @()
if ($Testnet) { $redesADesplegar = @("testnet") }
elseif ($Mainnet) { $redesADesplegar = @("mainnet") }
elseif ($Devnet) { $redesADesplegar = @("devnet") }
elseif ($Red) { $redesADesplegar = @($Red) }
elseif ($Redes.Count -gt 0) { $redesADesplegar = $Redes }
else { 
    # Por defecto usar la red activa
    $redActiva = sui client active-env
    $redesADesplegar = @($redActiva)
}

Write-Host "🌐 Desplegando en: $($redesADesplegar -join ', ')" -ForegroundColor Yellow

# Guardar red original
$redOriginal = sui client active-env

# Verificar Move.toml
if (-not (Test-Path "Move.toml")) {
    Write-Host "❌ Error: No se encuentra Move.toml en el directorio actual" -ForegroundColor Red
    exit 1
}

# Leer información del proyecto
$moveToml = Get-Content "Move.toml" -Raw
$nombreProyecto = ($moveToml | Select-String 'name\s*=\s*"([^"]+)"').Matches[0].Groups[1].Value
Write-Host "📦 Proyecto: $nombreProyecto" -ForegroundColor Green

# Datos demo para mainnet (despliegue real del 25/09/2025)
$DEMO_DATA_MAINNET = @{
    TransactionDigest = "HHcAMN7czxSVJMeMkpzfoTKuDSPF9ZW2D24ETh253uSq"
    PackageId         = "0x56899bfa963c427d3d3e7a884ac0236afc1886251f8e15275264c07af47cc3ec"
    UpgradeCapId      = "0xaab054e1f0393cfc79a44de7583e81807e91ee45fd10762d79ca01dd6feb200e"
    StorageCost       = 21432000
    ComputationCost   = 495000
    StorageRebate     = 978120
    GasUsed           = 495000
    TotalPaidMist     = 20948880
    TotalPaidSui      = "0.020948880"
    BalanceAntes      = "0.050000000"
    BalanceDespues    = "0.029051120"
}

# Función para desplegar en una red específica
function Invoke-DeployEnRed {
    param([string]$Red)
    
    Write-Host "`n🚀 DESPLEGANDO EN $($Red.ToUpper())..." -ForegroundColor Magenta
    
    # Cambiar a la red si es necesario
    if ($Red -ne $redOriginal) {
        Write-Host "   🔄 Cambiando a $Red..." -ForegroundColor Gray
        sui client switch --env $Red | Out-Null
    }
    
    try {
        # Verificar si es demo mode o mainnet sin fondos
        $esDemo = $Demo -or ($Red -eq "mainnet" -and (Test-BalanceInsuficiente $Red))
        
        if ($esDemo -and $Red -eq "mainnet") {
            Write-Host "   📋 Usando datos DEMO para mainnet (despliegue real 25/09/2025)" -ForegroundColor Yellow
            return New-DemoResult -Red $Red
        }
        
        # Verificar balance real
        Write-Host "   💰 Verificando balance..." -ForegroundColor Yellow
        $balance = sui client balance 2>&1 | Out-String
        $balanceActual = if ($balance -match "(\d+\.?\d*)\s+SUI") { [decimal]$Matches[1] } else { 0 }
        
        Write-Host "   💼 Balance: $balanceActual SUI" -ForegroundColor Green
        
        # Verificar si hay suficiente balance
        $costoEstimado = if ($Red -eq "mainnet") { 0.1 } else { 0.05 }
        if ($balanceActual -lt $costoEstimado) {
            Write-Host "   ⚠️ Balance insuficiente (necesitas ~$costoEstimado SUI)" -ForegroundColor Red
            if ($Red -eq "mainnet") {
                Write-Host "   📋 Usando modo DEMO para mainnet..." -ForegroundColor Yellow
                return New-DemoResult -Red $Red
            }
            else {
                return @{
                    Red     = $Red
                    Error   = $true
                    Mensaje = "Balance insuficiente. Usa: sui client faucet"
                }
            }
        }
        
        # Compilar proyecto
        Write-Host "   🔨 Compilando proyecto..." -ForegroundColor Yellow
        $compilacion = sui move build 2>&1
        if ($LASTEXITCODE -ne 0) {
            return @{
                Red     = $Red
                Error   = $true
                Mensaje = "Error en compilación: $compilacion"
            }
        }
        
        # Ejecutar despliegue real
        Write-Host "   🚀 Ejecutando despliegue..." -ForegroundColor Cyan
        $balanceAntes = $balanceActual.ToString("F9")
        
        $comando = "sui client publish --gas-budget $GasBudget"
        $resultado = Invoke-Expression $comando 2>&1
        $resultadoCompleto = $resultado -join "`n"
        
        if ($LASTEXITCODE -eq 0) {
            # Extraer información del despliegue exitoso
            $transactionDigest = ($resultadoCompleto | Select-String 'Transaction Digest: ([A-Za-z0-9]+)').Matches[0].Groups[1].Value
            $packageId = ($resultadoCompleto | Select-String 'PackageID: (0x[a-f0-9]+)').Matches[0].Groups[1].Value
            
            # Obtener balance después
            Start-Sleep -Seconds 2
            $balanceOutput = sui client balance 2>&1 | Out-String
            $balanceDespues = if ($balanceOutput -match "(\d+\.?\d*)\s+SUI") { $Matches[1] } else { $balanceAntes }
            
            # Extraer costos
            $storageCost = if ($resultadoCompleto -match 'Storage Cost: (\d+) MIST') { $Matches[1] } else { "0" }
            $computationCost = if ($resultadoCompleto -match 'Computation Cost: (\d+) MIST') { $Matches[1] } else { "0" }
            $storageRebate = if ($resultadoCompleto -match 'Storage Rebate: (\d+) MIST') { $Matches[1] } else { "0" }
            
            $totalCostMist = [int64]$storageCost + [int64]$computationCost - [int64]$storageRebate
            $totalCostSui = ($totalCostMist * 0.000000001).ToString("F9")
            
            # Buscar UpgradeCap si es actualizable
            $upgradeCapId = $null
            if ($ConActualizacion -and $resultadoCompleto -match 'ObjectID: (0x[a-f0-9]+)[\s\S]*?UpgradeCap') {
                $upgradeCapId = $Matches[1]
            }
            
            Write-Host "   ✅ Despliegue exitoso en $Red" -ForegroundColor Green
            
            return @{
                Red               = $Red
                Error             = $false
                Demo              = $false
                TransactionDigest = $transactionDigest
                PackageId         = $packageId
                UpgradeCapId      = $upgradeCapId
                BalanceAntes      = $balanceAntes
                BalanceDespues    = $balanceDespues
                TotalCostSui      = $totalCostSui
                StorageCost       = $storageCost
                ComputationCost   = $computationCost
                StorageRebate     = $storageRebate
            }
            
        }
        else {
            return @{
                Red     = $Red
                Error   = $true
                Mensaje = "Error en despliegue: $resultadoCompleto"
            }
        }
        
    }
    catch {
        return @{
            Red     = $Red
            Error   = $true
            Mensaje = $_.Exception.Message
        }
    }
}

# Función para verificar balance insuficiente
function Test-BalanceInsuficiente {
    param([string]$Red)
    
    $balance = sui client balance 2>&1 | Out-String
    $balanceActual = if ($balance -match "(\d+\.?\d*)\s+SUI") { [decimal]$Matches[1] } else { 0 }
    $costoMinimo = if ($Red -eq "mainnet") { 0.1 } else { 0.05 }
    
    return $balanceActual -lt $costoMinimo
}

# Función para crear resultado demo
function New-DemoResult {
    param([string]$Red)
    
    if ($Red -eq "mainnet") {
        return @{
            Red               = $Red
            Error             = $false
            Demo              = $true
            TransactionDigest = $DEMO_DATA_MAINNET.TransactionDigest
            PackageId         = $DEMO_DATA_MAINNET.PackageId
            UpgradeCapId      = $DEMO_DATA_MAINNET.UpgradeCapId
            BalanceAntes      = $DEMO_DATA_MAINNET.BalanceAntes
            BalanceDespues    = $DEMO_DATA_MAINNET.BalanceDespues
            TotalCostSui      = $DEMO_DATA_MAINNET.TotalPaidSui
            StorageCost       = $DEMO_DATA_MAINNET.StorageCost
            ComputationCost   = $DEMO_DATA_MAINNET.ComputationCost
            StorageRebate     = $DEMO_DATA_MAINNET.StorageRebate
        }
    }
    else {
        # Demo genérico para otras redes
        return @{
            Red               = $Red
            Error             = $false
            Demo              = $true
            TransactionDigest = "DEMO$(Get-Random -Minimum 1000 -Maximum 9999)DemoTransaction$Red"
            PackageId         = "0xdemo$(Get-Random -Minimum 100000 -Maximum 999999)package$Red"
            UpgradeCapId      = "0xdemo$(Get-Random -Minimum 100000 -Maximum 999999)upgradecap$Red"
            BalanceAntes      = "5.000000000"
            BalanceDespues    = "4.950000000"
            TotalCostSui      = "0.050000000"
            StorageCost       = "25000000"
            ComputationCost   = "500000"
            StorageRebate     = "500000"
        }
    }
}

# Función para generar reporte individual por red
function New-ReporteDespliegue {
    param(
        [string]$Red,
        [hashtable]$Resultado
    )
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Crear carpeta específica de la red
    $carpetaRed = Join-Path (Split-Path $PSScriptRoot) "reports\deploy\$Red"
    if (-not (Test-Path $carpetaRed)) {
        New-Item -Path $carpetaRed -ItemType Directory -Force | Out-Null
    }
    
    $archivo = "$carpetaRed\reporte-deploy-$Red-$timestamp.md"
    
    # Obtener wallet
    $walletOutput = sui client active-address 2>$null
    $wallet = $walletOutput.Trim()
    
    if ($Resultado.Error) {
        # Reporte de error
        $contenido = @"
# 🚀 Reporte de Despliegue SUI - $($Red.ToUpper()) ❌

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | $fecha |
| **🌐 Red** | $($Red.ToUpper()) |
| **👤 Wallet** | ``$wallet`` |
| **📦 Proyecto** | $nombreProyecto |
| **📊 Estado** | ❌ Error |

## 🚫 Error en Despliegue

❌ **No se pudo completar el despliegue** en **$($Red.ToUpper())**.

### 💡 Mensaje de Error:
``````
$($Resultado.Mensaje)
``````

### 🎯 Posibles Soluciones:
1. **Verificar Balance**: ``.\.script\check-balance.ps1 -Red $Red``
2. **Calcular Costos**: ``.\.script\calcular-costo-despliegue.ps1 -Red $Red``
3. **Fondear Cuenta**: $(if ($Red -eq "mainnet") { "Comprar SUI en exchanges" } else { "``sui client faucet``" })
4. **Revisar Código**: Verificar errores de compilación

"@
    }
    else {
        # Reporte exitoso
        $iconoRed = if ($Red -eq "mainnet") { "💎" } elseif ($Red -eq "testnet") { "🧪" } else { "🔧" }
        $iconoDemo = if ($Resultado.Demo) { "📋 DEMO" } else { "✅ REAL" }
        $costoUsd = ([decimal]$Resultado.TotalCostSui * 3.15).ToString('F4')
        
        $contenido = @"
# 🚀 Reporte de Despliegue SUI - $($Red.ToUpper()) $iconoRed

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | $fecha |
| **🌐 Red** | $($Red.ToUpper()) |
| **👤 Wallet** | ``$wallet`` |
| **📦 Proyecto** | $nombreProyecto |
| **📊 Estado** | $iconoDemo |
| **💰 Costo Total** | $($Resultado.TotalCostSui) SUI (~$costoUsd USD) |

## 📦 Información del Contrato

### 🔗 Identificadores Críticos

| Campo | Valor | Descripción |
|-------|-------|-------------|
| **🔗 Transaction Digest** | ``$($Resultado.TransactionDigest)`` | Hash único de la transacción |
| **📦 Package ID** | ``$($Resultado.PackageId)`` | ID del contrato desplegado |
$(if ($Resultado.UpgradeCapId) { "| **🔑 Upgrade Cap ID** | ``$($Resultado.UpgradeCapId)`` | Capacidad de actualización |" } else { "| **🔒 Upgrade Cap** | No disponible | Contrato inmutable |" })

### 💸 Análisis Financiero

| Concepto | MIST | SUI | USD (@ 3.15) |
|----------|------|-----|---------------|
| **Storage Cost** | $($Resultado.StorageCost) | $(([decimal]$Resultado.StorageCost * 0.000000001).ToString('F9')) | $(([decimal]$Resultado.StorageCost * 0.000000001 * 3.15).ToString('F4')) |
| **Computation Cost** | $($Resultado.ComputationCost) | $(([decimal]$Resultado.ComputationCost * 0.000000001).ToString('F9')) | $(([decimal]$Resultado.ComputationCost * 0.000000001 * 3.15).ToString('F4')) |
| **Storage Rebate** | -$($Resultado.StorageRebate) | -$(([decimal]$Resultado.StorageRebate * 0.000000001).ToString('F9')) | -$(([decimal]$Resultado.StorageRebate * 0.000000001 * 3.15).ToString('F4')) |
| **💰 Total Pagado** | **$(([decimal]$Resultado.StorageCost + [decimal]$Resultado.ComputationCost - [decimal]$Resultado.StorageRebate))** | **$($Resultado.TotalCostSui)** | **$costoUsd** |

### 📊 Balance del Wallet

| Campo | Valor |
|-------|-------|
| **💼 Balance Antes** | $($Resultado.BalanceAntes) SUI |
| **💰 Balance Después** | $($Resultado.BalanceDespues) SUI |
| **💸 Diferencia** | $(([decimal]$Resultado.BalanceAntes - [decimal]$Resultado.BalanceDespues).ToString('F9')) SUI |

"@

        if ($Resultado.Demo) {
            $contenido += @"

## 📋 Modo DEMO - Información Importante

⚠️ **Este reporte usa datos de demostración** basados en un despliegue real.

### 💡 ¿Por qué modo DEMO?
- Balance insuficiente en mainnet para despliegue real
- Los datos mostrados son de un despliegue exitoso del 25/09/2025
- Útil para planificación y estimaciones

### 🎯 Para Despliegue Real:
1. **Fondear Cuenta**: Añade al menos 0.1 SUI a mainnet
2. **Ejecutar Real**: ``.\.script\deploy.ps1 -Red mainnet``
3. **Verificar Costos**: ``.\.script\calcular-costo-despliegue.ps1 -Red mainnet``

"@
        }
        else {
            $contenido += @"

## 🎉 Despliegue Exitoso

✅ **Contrato desplegado correctamente** en **$($Red.ToUpper())**.

### 🚀 Próximos Pasos:
1. **Interactuar**: Llamar funciones del contrato
2. **Verificar**: Ver estado en el explorer
3. **Actualizar**: $(if ($Resultado.UpgradeCapId) { "Usar UpgradeCap para updates" } else { "Contrato inmutable" })

"@
        }
    }
    
    $contenido += @"

## 🛠️ Herramientas Disponibles

### 🚀 Interacción con Contratos
``````bash
# Llamar función del contrato
sui client call --package $($Resultado.PackageId) --module $nombreProyeto --function [FUNCION] --args "[ARG1]"

# Verificar objetos del contrato  
sui client object $($Resultado.PackageId)

$(if ($Resultado.UpgradeCapId) {
"# Verificar UpgradeCap
sui client object $($Resultado.UpgradeCapId)"
})

# Ver todos los objetos de la wallet
sui client objects
``````

### 📊 Verificación y Monitoreo
``````powershell
# Verificar balance actual
.\.script\check-balance.ps1 -Red $Red

# Verificar paquetes desplegados
.\.script\check-packages.ps1 -Red $Red

# Calcular costos de nuevos despliegues
.\.script\calcular-costo-despliegue.ps1 -Red $Red

$(if ($Resultado.UpgradeCapId) {
"# Actualizar contrato existente
.\.script\upgrade.ps1"
})
``````

### 🌐 Gestión de Redes
``````bash
# Cambiar a esta red
sui client switch --env $Red

# Ver red actual  
sui client active-env

# Listar todas las redes
sui client envs
``````

## 🔗 Enlaces Útiles

- 🌐 **SUI Explorer**: [https://suiexplorer.com/?network=$Red](https://suiexplorer.com/?network=$Red)
- 🔗 **Transaction**: [https://suiexplorer.com/txblock/$($Resultado.TransactionDigest)?network=$Red](https://suiexplorer.com/txblock/$($Resultado.TransactionDigest)?network=$Red)
- 📦 **Package**: [https://suiexplorer.com/object/$($Resultado.PackageId)?network=$Red](https://suiexplorer.com/object/$($Resultado.PackageId)?network=$Red)
- 👤 **Tu Wallet**: [https://suiexplorer.com/address/$wallet?network=$Red](https://suiexplorer.com/address/$wallet?network=$Red)
$(if ($Resultado.UpgradeCapId) {
"- 🔑 **UpgradeCap**: [https://suiexplorer.com/object/$($Resultado.UpgradeCapId)?network=$Red](https://suiexplorer.com/object/$($Resultado.UpgradeCapId)?network=$Red)"
})

## 📄 Información del Reporte

| Campo | Valor |
|-------|-------|
| **🏷️ Versión del Script** | 4.0 (Simplificado) |
| **📅 Generado** | $fecha |
| **🌐 Red Específica** | $($Red.ToUpper()) |
| **📊 Tipo** | $(if ($Resultado.Demo) { "Datos Demo" } else { "Despliegue Real" }) |
| **💰 Gas Budget Usado** | $GasBudget MIST |

---

**Creado con ❤️ por el equipo de desarrollo de [Dc Studio]()**
"@

    $contenido | Out-File -FilePath $archivo -Encoding UTF8
    Write-Host "   📁 Reporte generado: $archivo" -ForegroundColor Green
}

# Procesar cada red individualmente
$resultadosGlobales = @()
foreach ($red in $redesADesplegar) {
    $resultado = Invoke-DeployEnRed -Red $red
    $resultadosGlobales += $resultado
    
    # Generar reporte inmediatamente para esta red
    New-ReporteDespliegue -Red $red -Resultado $resultado
}

# Restaurar red original
sui client switch --env $redOriginal | Out-Null

# Resumen final
$exitososReales = ($resultadosGlobales | Where-Object { -not $_.Error -and -not $_.Demo }).Count
$exitososDemo = ($resultadosGlobales | Where-Object { -not $_.Error -and $_.Demo }).Count
$errores = ($resultadosGlobales | Where-Object { $_.Error }).Count

Write-Host "`n📊 RESUMEN FINAL:" -ForegroundColor Cyan
Write-Host "   🌐 Redes procesadas: $($redesADesplegar.Count)" -ForegroundColor White
Write-Host "   ✅ Despliegues reales exitosos: $exitososReales" -ForegroundColor Green
Write-Host "   📋 Despliegues demo: $exitososDemo" -ForegroundColor Yellow
Write-Host "   ❌ Errores: $errores" -ForegroundColor Red

foreach ($resultado in $resultadosGlobales) {
    if (-not $resultado.Error) {
        $red = $resultado.Red
        $costo = $resultado.TotalCostSui
        $tipo = if ($resultado.Demo) { "📋 DEMO" } else { "✅ REAL" }
        Write-Host "   └─ $red`: $costo SUI $tipo" -ForegroundColor Gray
    }
}

Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Magenta
if ($exitososReales -gt 0 -or $exitososDemo -gt 0) {
    Write-Host "   • Para interactuar: sui client call --package [PACKAGE_ID] --module $nombreProyecto --function [FUNCION]" -ForegroundColor White
    Write-Host "   • Para verificar paquetes: .\.script\check-packages.ps1" -ForegroundColor White
    Write-Host "   • Para verificar balances: .\.script\check-balance.ps1" -ForegroundColor White
    if ($exitososDemo -gt 0) {
        Write-Host "   • Para despliegue real: Fondear cuenta y ejecutar sin modo demo" -ForegroundColor Yellow
    }
}

if ($errores -gt 0) {
    Write-Host "   • Para resolver errores: Revisar balances y códigos de error" -ForegroundColor Red
}

Write-Host "`n✅ Deploy completo! Reportes guardados en .\reports\deploy\" -ForegroundColor Green
Write-Host "`n**Creado con ❤️ por el equipo de desarrollo de Dc Studio**" -ForegroundColor Magenta