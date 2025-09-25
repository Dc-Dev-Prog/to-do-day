# Script Inteligente de Verificación de Paquetes Sui
# Autor: Copilot Assistant - Refactorizado
# Versión: 2.0

param(
    [Parameter(Mandatory=$false)]
    [string]$Red,
    
    [Parameter(Mandatory=$false)]
    [switch]$Detallado,
    
    [Parameter(Mandatory=$false)]
    [switch]$SoloActualizables
)

Write-Host "📦 VERIFICADOR INTELIGENTE DE PAQUETES SUI" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Detectar red actual
$redActual = sui client active-env
Write-Host "🌐 Red actual: $redActual" -ForegroundColor Yellow

# Si se especifica una red diferente, cambiar
if ($Red -and $Red -ne $redActual) {
    Write-Host "🔄 Cambiando a $Red..." -ForegroundColor Yellow
    sui client switch --env $Red
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error al cambiar a $Red" -ForegroundColor Red
        exit 1
    }
    $redActual = $Red
}

# Función para formatear información de paquete
function Format-PackageInfo {
    param($packageId, $upgradeCapId = $null, $version = "N/A")
    
    Write-Host "`n📋 PAQUETE: $packageId" -ForegroundColor Green
    Write-Host "   🏷️  Versión: $version" -ForegroundColor Gray
    
    if ($upgradeCapId) {
        Write-Host "   🔑 UpgradeCap: $upgradeCapId" -ForegroundColor Blue
        Write-Host "   ✅ Actualizable: SÍ" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Actualizable: NO (inmutable)" -ForegroundColor Red
    }
    
    if ($Detallado) {
        Write-Host "   🔍 Obteniendo detalles..." -ForegroundColor Yellow
        try {
            $packageInfo = sui client object $packageId --json 2>$null | ConvertFrom-Json
            if ($packageInfo) {
                Write-Host "   📅 Creado: $($packageInfo.content.fields.version)" -ForegroundColor Gray
            }
        } catch {
            Write-Host "   ⚠️  No se pudieron obtener detalles" -ForegroundColor Yellow
        }
    }
}

# Buscar todos los UpgradeCaps en el wallet
Write-Host "`n🔍 BUSCANDO UPGRADE CAPABILITIES..." -ForegroundColor Blue
$objetos = sui client objects 2>&1
$upgradeCaps = @()
$paquetesEncontrados = @{}

foreach ($linea in $objetos) {
    if ($linea -match '(0x[a-f0-9]+).*UpgradeCap') {
        $upgradeCapId = $matches[1]
        $upgradeCaps += $upgradeCapId
        
        # Obtener información del paquete asociado
        try {
            $capInfo = sui client object $upgradeCapId --json 2>$null | ConvertFrom-Json
            if ($capInfo -and $capInfo.content.fields.package) {
                $packageId = $capInfo.content.fields.package
                $version = $capInfo.content.fields.version
                $paquetesEncontrados[$packageId] = @{
                    UpgradeCap = $upgradeCapId
                    Version = $version
                }
            }
        } catch {
            Write-Host "   ⚠️  Error al obtener info de UpgradeCap: $upgradeCapId" -ForegroundColor Yellow
        }
    }
}

# Cargar información de último despliegue si existe
$ultimoDespliegueFile = ".script\ultimo-despliegue.txt"
$ultimoDespliegue = $null
if (Test-Path $ultimoDespliegueFile) {
    $ultimoDespliegueContent = Get-Content $ultimoDespliegueFile -Raw
    $ultimoPackageId = ($ultimoDespliegueContent | Select-String 'Package ID: (0x[a-f0-9]+)').Matches[0].Groups[1].Value
    $ultimoUpgradeCap = ($ultimoDespliegueContent | Select-String 'Upgrade Cap ID: (0x[a-f0-9]+)').Matches[0].Groups[1].Value
    $ultimaRed = ($ultimoDespliegueContent | Select-String 'Red: (\w+)').Matches[0].Groups[1].Value
    
    if ($ultimaRed -eq $redActual -and $ultimoPackageId) {
        $ultimoDespliegue = @{
            PackageId = $ultimoPackageId
            UpgradeCap = $ultimoUpgradeCap
        }
    }
}

# Mostrar resumen
if ($paquetesEncontrados.Count -eq 0 -and -not $ultimoDespliegue) {
    Write-Host "`n❌ NO SE ENCONTRARON PAQUETES DESPLEGADOS" -ForegroundColor Red
    Write-Host "   💡 Consejos:" -ForegroundColor Yellow
    Write-Host "      • Verifica que estés en la red correcta" -ForegroundColor Gray
    Write-Host "      • Usa .\.script\deploy.ps1 para desplegar contratos" -ForegroundColor Gray
    Write-Host "      • Revisa si tienes paquetes en otras redes" -ForegroundColor Gray
    exit 0
}

Write-Host "`n📊 RESUMEN DE PAQUETES EN $redActual" -ForegroundColor Magenta
Write-Host "================================" -ForegroundColor Magenta

$totalPaquetes = 0

# Mostrar paquete del último despliegue primero
if ($ultimoDespliegue) {
    Write-Host "`n⭐ ÚLTIMO DESPLIEGUE REGISTRADO:" -ForegroundColor Yellow
    Format-PackageInfo -packageId $ultimoDespliegue.PackageId -upgradeCapId $ultimoDespliegue.UpgradeCap
    $totalPaquetes++
}

# Mostrar otros paquetes encontrados
if ($paquetesEncontrados.Count -gt 0) {
    Write-Host "`n🔍 OTROS PAQUETES ACTUALIZABLES:" -ForegroundColor Blue
    
    foreach ($package in $paquetesEncontrados.GetEnumerator()) {
        # Evitar duplicar el último despliegue
        if ($ultimoDespliegue -and $package.Key -eq $ultimoDespliegue.PackageId) {
            continue
        }
        
        Format-PackageInfo -packageId $package.Key -upgradeCapId $package.Value.UpgradeCap -version $package.Value.Version
        $totalPaquetes++
    }
}

# Buscar paquetes inmutables (sin UpgradeCap) si no es solo actualizables
if (-not $SoloActualizables) {
    Write-Host "`n🔒 BUSCANDO PAQUETES INMUTABLES..." -ForegroundColor Yellow
    
    # Aquí podrías implementar lógica para encontrar paquetes sin UpgradeCap
    # Esto es más complejo porque requiere revisar transacciones históricas
    Write-Host "   💡 Los paquetes inmutables requieren análisis de transacciones" -ForegroundColor Gray
    Write-Host "   🔍 Para encontrarlos, revisa tus transacciones de publish en:" -ForegroundColor Gray
    Write-Host "      https://suiexplorer.com" -ForegroundColor Blue
}

# Estadísticas finales
Write-Host "`n📈 ESTADÍSTICAS:" -ForegroundColor Cyan
Write-Host "   📦 Total paquetes actualizables: $totalPaquetes"
Write-Host "   🔑 UpgradeCaps disponibles: $($upgradeCaps.Count)"
Write-Host "   🌐 Red actual: $redActual"

# Sugerencias de próximos pasos
Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Magenta
if ($totalPaquetes -gt 0) {
    Write-Host "   • Para actualizar: .\.script\upgrade.ps1"
    Write-Host "   • Para calcular costos: .\.script\calcular-costo-despliegue.ps1"
    Write-Host "   • Para nuevo despliegue: .\.script\deploy.ps1"
} else {
    Write-Host "   • Para desplegar: .\.script\deploy.ps1"
    Write-Host "   • Para cambiar red: sui client switch --env <red>"
}

Write-Host "`n🔧 OPCIONES DEL SCRIPT:" -ForegroundColor Gray
Write-Host "   .\.script\check-packages.ps1 -Red testnet    # Verificar en testnet"
Write-Host "   .\.script\check-packages.ps1 -Detallado     # Información detallada"
Write-Host "   .\.script\check-packages.ps1 -SoloActualizables  # Solo paquetes actualizables"

Write-Host "`n✅ Verificación completa!" -ForegroundColor Green