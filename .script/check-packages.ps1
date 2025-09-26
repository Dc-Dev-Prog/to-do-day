param(
    [string]$Red,
    [string[]]$Redes = @(),
    [switch]$Testnet,
    [switch]$Mainnet,
    [switch]$Devnet,
    [switch]$Detallado,
    [switch]$SoloActualizables
)

Write-Host "📦 VERIFICADOR DE PAQUETES SUI v4.0 (Simplificado)" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

# Determinar redes a verificar
$redesAVerificar = @()
if ($Testnet) { $redesAVerificar = @("testnet") }
elseif ($Mainnet) { $redesAVerificar = @("mainnet") }
elseif ($Devnet) { $redesAVerificar = @("devnet") }
elseif ($Red) { $redesAVerificar = @($Red) }
elseif ($Redes.Count -gt 0) { $redesAVerificar = $Redes }
else { $redesAVerificar = @("testnet", "mainnet", "devnet") }

Write-Host "🌐 Verificando: $($redesAVerificar -join ', ')" -ForegroundColor Yellow

# Guardar red actual
$redOriginal = sui client active-env

# Función para verificar paquetes en una red específica
function Get-PackagesInRed {
    param([string]$Red)

    Write-Host "`n🔍 VERIFICANDO EN $($Red.ToUpper())..." -ForegroundColor Magenta

    # Cambiar a la red
    if ($Red -ne $redOriginal) {
        Write-Host "   🔄 Cambiando a $Red..." -ForegroundColor Gray
        sui client switch --env $Red | Out-Null
    }

    $paquetesEncontrados = @{}
    $upgradeCaps = @()

    try {
        # Obtener objetos en formato JSON
        $objetosJson = sui client objects --json 2>$null
        if ($objetosJson) {
            $objetos = $objetosJson | ConvertFrom-Json

            foreach ($objeto in $objetos) {
                if ($objeto.data.type -match "UpgradeCap") {
                    $upgradeCapId = $objeto.data.objectId
                    $upgradeCaps += $upgradeCapId

                    if ($objeto.data.content.fields.package) {
                        $packageId = $objeto.data.content.fields.package
                        $version = $objeto.data.content.fields.version
                        $paquetesEncontrados[$packageId] = @{
                            UpgradeCap = $upgradeCapId
                            Version    = $version
                        }
                        Write-Host "      ✅ UpgradeCap: $upgradeCapId" -ForegroundColor Green
                        Write-Host "      📦 Paquete: $packageId" -ForegroundColor Gray
                    }
                }
            }
        }

        $totalPaquetes = $paquetesEncontrados.Count
        Write-Host "   ✅ Encontrados $totalPaquetes paquete(s) actualizable(s)" -ForegroundColor Green

        return @{
            Red                 = $Red
            PaquetesEncontrados = $paquetesEncontrados
            UpgradeCaps         = $upgradeCaps
            TotalPaquetes       = $totalPaquetes
        }

    }
    catch {
        Write-Host "   ❌ Error verificando $Red`: $($_.Exception.Message)" -ForegroundColor Red
        return @{
            Red                 = $Red
            PaquetesEncontrados = @{}
            UpgradeCaps         = @()
            TotalPaquetes       = 0
        }
    }
}

# Función para generar reporte individual por red
function New-ReporteRed {
    param(
        [string]$Red,
        [hashtable]$Resultado
    )

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Crear carpeta específica de la red
    $carpetaRed = "docs\reports\check-packages\$Red"
    if (-not (Test-Path $carpetaRed)) {
        New-Item -Path $carpetaRed -ItemType Directory -Force | Out-Null
    }

    $archivo = "$carpetaRed\reporte-$Red-$timestamp.md"

    # Obtener wallet
    $walletOutput = sui client active-address 2>$null
    $wallet = $walletOutput.Trim()

    $paquetes = $Resultado.PaquetesEncontrados
    $totalPaquetes = $Resultado.TotalPaquetes

    $contenido = @"
# 📦 Reporte de Paquetes SUI - $($Red.ToUpper())

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | $fecha |
| **🌐 Red** | $($Red.ToUpper()) |
| **👤 Wallet** | ``$wallet`` |
| **📊 Total Paquetes** | $totalPaquetes |

"@

    if ($totalPaquetes -gt 0) {
        $contenido += @"

## 📋 Paquetes Encontrados

| Package ID | UpgradeCap | Versión | Explorer |
|------------|------------|---------|----------|
"@
        foreach ($paquete in $paquetes.GetEnumerator()) {
            $contenido += "|``$($paquete.Key)`` | ``$($paquete.Value.UpgradeCap)`` | $($paquete.Value.Version) | [🔗](https://suiexplorer.com/object/$($paquete.Key)?network=$Red) |`n"
        }
    }
    else {
        $contenido += @"

## 🚫 Sin Paquetes

❌ **No se encontraron paquetes actualizables** en **$($Red.ToUpper())**.

### 💡 Posibles Razones:
- No tienes contratos desplegados en esta red
- Los contratos son inmutables (sin UpgradeCap)
- Los contratos están en otra wallet
- Problemas de conectividad

### 🎯 Próximos Pasos:
1. **Verificar Wallet**: [Ver en Explorer](https://suiexplorer.com/address/$wallet?network=$Red)
2. **Desplegar Contrato**: ``.\.script\deploy.ps1``
3. **Cambiar Red**: ``sui client switch --env $Red``

"@
    }

    $contenido += @"

## 🛠️ Herramientas Disponibles

### 📋 Verificación
``````powershell
# Verificar esta red
.\.script\check-packages.ps1 -Red $Red

# Verificar múltiples redes
.\.script\check-packages.ps1 -Redes @("mainnet", "testnet")

# Solo en testnet
.\.script\check-packages.ps1 -SoloTestnet

# Solo en mainnet
.\.script\check-packages.ps1 -SoloMainnet

# Solo en devnet
.\.script\check-packages.ps1 -SoloDevnet
``````

### 🚀 Despliegue y Actualización
``````bash
# Nuevo despliegue
.\.script\deploy.ps1

# Actualizar paquete existente
.\.script\upgrade.ps1

# Estimar costos
.\.script\calcular-costo-despliegue.ps1
``````

### 💰 Gestión de Fondos
``````bash
# Verificar saldos SUI
.\.script\check-balance.ps1

# Solo verificar $Red
.\.script\check-balance.ps1 -Solo$($Red.Substring(0,1).ToUpper() + $Red.Substring(1))
``````

## 🔗 Enlaces Útiles

- 🌐 **SUI Explorer**: [https://suiexplorer.com/?network=$Red](https://suiexplorer.com/?network=$Red)
- 👤 **Tu Wallet**: [https://suiexplorer.com/address/$wallet?network=$Red](https://suiexplorer.com/address/$wallet?network=$Red)
- 📚 **Documentación**: [https://docs.sui.io](https://docs.sui.io)
- 🏗️ **Move Book**: [https://move-book.com](https://move-book.com)

## 📄 Información del Reporte

| Campo | Valor |
|-------|-------|
| **🏷️ Versión del Script** | 4.0 (Simplificado) |
| **📅 Generado** | $fecha |
| **🌐 Red Específica** | $($Red.ToUpper()) |
| **⚡ Análisis** | Individual por Red |

---

*Creado con ❤️ por el equipo de desarrollo de **Dc Studio***
"@

    $contenido | Out-File -FilePath $archivo -Encoding UTF8
    Write-Host "   📁 Reporte generado: $archivo" -ForegroundColor Green
}

# Procesar cada red individualmente
$resultadosGlobales = @()
foreach ($red in $redesAVerificar) {
    $resultado = Get-PackagesInRed -Red $red
    $resultadosGlobales += $resultado

    # Generar reporte inmediatamente para esta red
    New-ReporteRed -Red $red -Resultado $resultado
}

# Restaurar red original
sui client switch --env $redOriginal | Out-Null

# Resumen final
$totalGlobal = ($resultadosGlobales | Measure-Object TotalPaquetes -Sum).Sum
Write-Host "`n📊 RESUMEN FINAL:" -ForegroundColor Cyan
Write-Host "   📦 Total paquetes encontrados: $totalGlobal" -ForegroundColor White
Write-Host "   🌐 Redes verificadas: $($redesAVerificar.Count)" -ForegroundColor White

foreach ($resultado in $resultadosGlobales) {
    $red = $resultado.Red
    $total = $resultado.TotalPaquetes
    $icono = if ($total -gt 0) { "✅" } else { "❌" }
    Write-Host "   └─ $red`: $total paquetes $icono" -ForegroundColor Gray
}

Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Magenta
if ($totalGlobal -gt 0) {
    Write-Host "   • Para actualizar: .\.script\upgrade.ps1" -ForegroundColor White
    Write-Host "   • Para calcular costos: .\.script\calcular-costo-despliegue.ps1" -ForegroundColor White
    Write-Host "   • Para nuevo despliegue: .\.script\deploy.ps1" -ForegroundColor White
}
else {
    Write-Host "   • Para desplegar: .\.script\deploy.ps1" -ForegroundColor White
    Write-Host "   • Para cambiar red: sui client switch --env <red>" -ForegroundColor White
}

Write-Host "`n✅ Verificación completa! Reportes guardados en docs\reports\check-packages\" -ForegroundColor Green