# Script para calcular el costo de despliegue en Sui
# Autor: Copilot Assistant
# Fecha: 2025-09-24

param(
    [Parameter(Mandatory=$false)]
    [string]$Red = "mainnet",
    
    [Parameter(Mandatory=$false)]
    [decimal]$PrecioSUI = 4.0,
    
    [Parameter(Mandatory=$false)]
    [switch]$MostrarDetalle,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("ambos", "solo-despliegue", "solo-actualizacion")]
    [string]$Tipo = "ambos"
)

Write-Host "🔍 CALCULADORA DE COSTOS DE DESPLIEGUE SUI" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Verificar si estamos en el directorio correcto
if (-not (Test-Path "Move.toml")) {
    Write-Host "❌ Error: No se encuentra Move.toml. Ejecuta desde el directorio del proyecto." -ForegroundColor Red
    exit 1
}

# Verificar red activa
$redActiva = sui client active-env
Write-Host "🌐 Red activa: $redActiva" -ForegroundColor Yellow

if ($redActiva -ne $Red) {
    Write-Host "⚠️  Advertencia: Red activa ($redActiva) diferente a la solicitada ($Red)" -ForegroundColor Yellow
    Write-Host "   Usa: sui client switch --env $Red" -ForegroundColor Gray
}

# Compilar proyecto para obtener información
Write-Host "🔨 Compilando proyecto..." -ForegroundColor Yellow
$compilacion = sui move build 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error en la compilación:" -ForegroundColor Red
    Write-Host $compilacion -ForegroundColor Red
    exit 1
}

Write-Host "✅ Compilación exitosa" -ForegroundColor Green

# Precios de gas actualizados para Sui (aproximados)
$COMPUTATION_PRICE = 1000      # MIST por unidad de cómputo
$STORAGE_PRICE = 76000         # MIST por byte de almacenamiento
$MIST_TO_SUI = 0.000000001    # Conversión MIST a SUI (1 SUI = 1B MIST)

Write-Host "`n📊 ESTIMACIÓN DE COSTOS" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan

# Estimaciones basadas en el tipo de contrato
Write-Host "🔍 Analizando tu contrato 'empresa'..." -ForegroundColor Yellow

# Leer el archivo Move.toml para obtener información del proyecto
$moveToml = Get-Content "Move.toml" -Raw
$nombreProyecto = ($moveToml | Select-String 'name\s*=\s*"([^"]+)"').Matches[0].Groups[1].Value

Write-Host "📦 Proyecto: $nombreProyecto" -ForegroundColor Gray

# Estimaciones de unidades de cómputo basadas en complejidad
$COMPUTE_UNITS = @{
    "Básico" = 30000      # Contratos simples
    "Mediano" = 75000     # Tu contrato empresa
    "Complejo" = 150000   # Contratos muy complejos
}

$STORAGE_BYTES = @{
    "Básico" = 2048       # 2KB
    "Mediano" = 4096      # 4KB - Tu contrato
    "Complejo" = 8192     # 8KB
}

# Tu contrato es mediano
$tipoContrato = "Mediano"
$computeUnits = $COMPUTE_UNITS[$tipoContrato]
$storageBytes = $STORAGE_BYTES[$tipoContrato]

if ($MostrarDetalle) {
    Write-Host "`n🔧 DETALLES TÉCNICOS:" -ForegroundColor Magenta
    Write-Host "   • Tipo de contrato: $tipoContrato"
    Write-Host "   • Unidades de cómputo estimadas: $($computeUnits.ToString('N0'))"
    Write-Host "   • Bytes de almacenamiento: $($storageBytes.ToString('N0'))"
    Write-Host "   • Precio cómputo: $COMPUTATION_PRICE MIST/unidad"
    Write-Host "   • Precio almacenamiento: $STORAGE_PRICE MIST/byte"
}

# Calcular costos base
$costoComputacion = $computeUnits * $COMPUTATION_PRICE * $MIST_TO_SUI
$costoAlmacenamiento = $storageBytes * $STORAGE_PRICE * $MIST_TO_SUI
$costoDespliegue = $costoComputacion + $costoAlmacenamiento

# Estimación para actualización (solo cómputo, menos almacenamiento)
$costoActualizacion = $costoComputacion + ($storageBytes * 0.3 * $STORAGE_PRICE * $MIST_TO_SUI)

Write-Host "`n💰 COSTOS EN SUI:" -ForegroundColor Green

# Mostrar según el tipo seleccionado
switch ($Tipo) {
    "solo-despliegue" {
        Write-Host "   🔨 Cómputo: $($costoComputacion.ToString('F6')) SUI"
        Write-Host "   💾 Almacenamiento: $($costoAlmacenamiento.ToString('F6')) SUI"
        Write-Host "   📦 DESPLIEGUE INICIAL: $($costoDespliegue.ToString('F4')) SUI" -ForegroundColor Yellow
        
        $costoTotalUSD = $costoDespliegue * $PrecioSUI
        $presupuestoRecomendado = [math]::Ceiling($costoDespliegue * 1.5 * 10) / 10
        
        Write-Host "`n💵 COSTO EN USD (SUI = $PrecioSUI):" -ForegroundColor Green
        Write-Host "   📦 Despliegue inicial: $($costoTotalUSD.ToString('F2')) USD"
        
        Write-Host "`n🎯 RECOMENDACIÓN:" -ForegroundColor Magenta
        Write-Host "   💡 Presupuesto para despliegue: $presupuestoRecomendado SUI"
    }
    
    "solo-actualizacion" {
        Write-Host "   🔨 Cómputo: $($costoComputacion.ToString('F6')) SUI"
        Write-Host "   💾 Almacenamiento reducido: $(($storageBytes * 0.3 * $STORAGE_PRICE * $MIST_TO_SUI).ToString('F6')) SUI"
        Write-Host "   🔄 ACTUALIZACIÓN: $($costoActualizacion.ToString('F4')) SUI" -ForegroundColor Cyan
        
        $costoActualizacionUSD = $costoActualizacion * $PrecioSUI
        $presupuestoRecomendado = [math]::Ceiling($costoActualizacion * 1.5 * 10) / 10
        
        Write-Host "`n💵 COSTO EN USD (SUI = $PrecioSUI):" -ForegroundColor Green
        Write-Host "   � Actualización: $($costoActualizacionUSD.ToString('F2')) USD"
        
        Write-Host "`n🎯 RECOMENDACIÓN:" -ForegroundColor Magenta
        Write-Host "   💡 Presupuesto para actualización: $presupuestoRecomendado SUI"
    }
    
    default {  # "ambos"
        Write-Host "   🔨 Cómputo: $($costoComputacion.ToString('F6')) SUI"
        Write-Host "   💾 Almacenamiento: $($costoAlmacenamiento.ToString('F6')) SUI"
        Write-Host "   📦 DESPLIEGUE INICIAL: $($costoDespliegue.ToString('F4')) SUI" -ForegroundColor Yellow
        Write-Host "   🔄 Actualización futura: $($costoActualizacion.ToString('F4')) SUI" -ForegroundColor Cyan
        
        $costoDespliegueUSD = $costoDespliegue * $PrecioSUI
        $costoActualizacionUSD = $costoActualizacion * $PrecioSUI
        $presupuestoRecomendado = [math]::Ceiling($costoDespliegue * 1.5 * 10) / 10
        
        Write-Host "`n💵 COSTOS EN USD (SUI = $PrecioSUI):" -ForegroundColor Green
        Write-Host "   📦 Despliegue inicial: $($costoDespliegueUSD.ToString('F2')) USD"
        Write-Host "   🔄 Actualización futura: $($costoActualizacionUSD.ToString('F2')) USD"
        
        Write-Host "`n🎯 RECOMENDACIONES:" -ForegroundColor Magenta
        Write-Host "   💡 Presupuesto para despliegue: $presupuestoRecomendado SUI"
        Write-Host "   📊 Margen de seguridad: 50% extra incluido"
    }
}

# Verificar balance actual si estamos en la red correcta
if ($redActiva -eq $Red) {
    Write-Host "`n💼 BALANCE ACTUAL:" -ForegroundColor Blue
    $balance = sui client balance 2>&1 | Out-String
    
    if ($balance -match "(\d+\.?\d*)\s+SUI") {
        $balanceActual = [decimal]$Matches[1]
        Write-Host "   💰 Tienes: $balanceActual SUI"
        
        $diferencia = $presupuestoRecomendado - $balanceActual
        if ($diferencia -gt 0) {
            Write-Host "   ⚠️  Necesitas: $($diferencia.ToString('F4')) SUI adicionales" -ForegroundColor Red
        } else {
            Write-Host "   ✅ Tienes suficiente para el despliegue" -ForegroundColor Green
        }
    } else {
        Write-Host "   ❌ No tienes SUI en esta red" -ForegroundColor Red
        Write-Host "   💡 Necesitas al menos: $presupuestoRecomendado SUI"
    }
}

Write-Host "`n📝 NOTAS IMPORTANTES:" -ForegroundColor Yellow
Write-Host "   • Los costos son estimaciones basadas en promedios de red"
Write-Host "   • Los precios de gas pueden variar según la congestión"
Write-Host "   • En testnet/devnet los costos son similares pero con SUI gratis"
Write-Host "   • Siempre ten un margen extra para transacciones adicionales"

Write-Host "`n🚀 ¡Listo para desplegar!" -ForegroundColor Green

# Ejemplos de uso
Write-Host "`n📚 EJEMPLOS DE USO:" -ForegroundColor Cyan
Write-Host "   .\calcular-costo-despliegue.ps1                              # Ambos costos (por defecto)"
Write-Host "   .\calcular-costo-despliegue.ps1 -Tipo solo-despliegue       # Solo costo inicial"
Write-Host "   .\calcular-costo-despliegue.ps1 -Tipo solo-actualizacion    # Solo costo de updates"
Write-Host "   .\calcular-costo-despliegue.ps1 -Red testnet                # En testnet"
Write-Host "   .\calcular-costo-despliegue.ps1 -PrecioSUI 5.0              # SUI a $5"
Write-Host "   .\calcular-costo-despliegue.ps1 -MostrarDetalle             # Más información técnica"