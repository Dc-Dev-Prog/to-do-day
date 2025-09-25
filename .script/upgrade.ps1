# Script Inteligente de Actualización Sui
# Autor: Copilot Assistant - Refactorizado
# Versión: 2.0

param(
    [Parameter(Mandatory=$false)]
    [string]$PackageId,
    
    [Parameter(Mandatory=$false)]
    [string]$UpgradeCapId,
    
    [Parameter(Mandatory=$false)]
    [string]$Red,
    
    [Parameter(Mandatory=$false)]
    [string]$GasBudget = "100000000"
)

Write-Host "🔄 SCRIPT INTELIGENTE DE ACTUALIZACIÓN SUI" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Verificar que estamos en un proyecto Sui
if (-not (Test-Path "Move.toml")) {
    Write-Host "❌ Error: No se encuentra Move.toml en el directorio actual" -ForegroundColor Red
    Write-Host "   Ejecuta este script desde el directorio del proyecto" -ForegroundColor Gray
    exit 1
}

# Detectar información del proyecto
$moveToml = Get-Content "Move.toml" -Raw
$nombreProyecto = ($moveToml | Select-String 'name\s*=\s*"([^"]+)"').Matches[0].Groups[1].Value
Write-Host "📦 Proyecto: $nombreProyecto" -ForegroundColor Green

# Detectar red actual
$redActual = sui client active-env
Write-Host "🌐 Red actual: $redActual" -ForegroundColor Yellow

# Si no se especifica red, usar la actual o preguntar
if (-not $Red) {
    Write-Host "`n🔍 ¿En qué red quieres actualizar?" -ForegroundColor Magenta
    Write-Host "   1️⃣  Usar red actual ($redActual)"
    Write-Host "   2️⃣  testnet"
    Write-Host "   3️⃣  mainnet" 
    Write-Host "   4️⃣  devnet"
    
    do {
        $opcion = Read-Host "`n   Selecciona una opción (1-4)"
        switch ($opcion) {
            "1" { $Red = $redActual; break }
            "2" { $Red = "testnet"; break }
            "3" { $Red = "mainnet"; break }
            "4" { $Red = "devnet"; break }
            default { Write-Host "   ❌ Opción inválida. Usa 1, 2, 3 o 4" -ForegroundColor Red }
        }
    } while ($opcion -notin @("1", "2", "3", "4"))
}

# Cambiar a la red seleccionada si es necesario
if ($redActual -ne $Red) {
    Write-Host "🔄 Cambiando a $Red..." -ForegroundColor Yellow
    sui client switch --env $Red
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error al cambiar a $Red" -ForegroundColor Red
        exit 1
    }
}

# Buscar UpgradeCaps disponibles si no se proporciona uno
if (-not $UpgradeCapId) {
    Write-Host "`n🔍 DETECTANDO UPGRADE CAPABILITIES..." -ForegroundColor Blue
    
    # Intentar cargar desde archivo de último despliegue
    $ultimoDespliegueFile = ".script\ultimo-despliegue.txt"
    if (Test-Path $ultimoDespliegueFile) {
        $ultimoDespliegue = Get-Content $ultimoDespliegueFile -Raw
        $ultimoUpgradeCap = ($ultimoDespliegue | Select-String 'Upgrade Cap ID: (0x[a-f0-9]+)').Matches[0].Groups[1].Value
        $ultimoPackageId = ($ultimoDespliegue | Select-String 'Package ID: (0x[a-f0-9]+)').Matches[0].Groups[1].Value
        $ultimaRed = ($ultimoDespliegue | Select-String 'Red: (\w+)').Matches[0].Groups[1].Value
        
        if ($ultimoUpgradeCap -and $ultimaRed -eq $Red) {
            Write-Host "   📄 Encontrado último despliegue:" -ForegroundColor Green
            Write-Host "      Package ID: $ultimoPackageId" -ForegroundColor Gray
            Write-Host "      Upgrade Cap: $ultimoUpgradeCap" -ForegroundColor Gray
            
            $usar = Read-Host "`n   ¿Usar este UpgradeCap? (y/n)"
            if ($usar.ToLower() -in @("y", "s", "yes", "si", "sí")) {
                $UpgradeCapId = $ultimoUpgradeCap
                if (-not $PackageId) { $PackageId = $ultimoPackageId }
            }
        }
    }
    
    # Si aún no tenemos UpgradeCap, buscar en objetos
    if (-not $UpgradeCapId) {
        Write-Host "   🔍 Buscando UpgradeCaps en tu wallet..." -ForegroundColor Yellow
        $objetos = sui client objects 2>&1
        $upgradeCaps = @()
        
        foreach ($linea in $objetos) {
            if ($linea -match '(0x[a-f0-9]+).*UpgradeCap') {
                $upgradeCaps += $matches[1]
            }
        }
        
        if ($upgradeCaps.Count -eq 0) {
            Write-Host "   ❌ No se encontraron UpgradeCaps en esta red" -ForegroundColor Red
            Write-Host "   💡 Asegúrate de haber desplegado un contrato actualizable" -ForegroundColor Yellow
            exit 1
        } elseif ($upgradeCaps.Count -eq 1) {
            $UpgradeCapId = $upgradeCaps[0]
            Write-Host "   ✅ UpgradeCap detectado: $UpgradeCapId" -ForegroundColor Green
        } else {
            Write-Host "   🔍 Múltiples UpgradeCaps encontrados:" -ForegroundColor Yellow
            for ($i = 0; $i -lt $upgradeCaps.Count; $i++) {
                Write-Host "      $($i+1)️⃣  $($upgradeCaps[$i])" -ForegroundColor Gray
            }
            
            do {
                $seleccion = Read-Host "`n   Selecciona el UpgradeCap (1-$($upgradeCaps.Count))"
                $indice = [int]$seleccion - 1
            } while ($indice -lt 0 -or $indice -ge $upgradeCaps.Count)
            
            $UpgradeCapId = $upgradeCaps[$indice]
        }
    }
}

# Obtener Package ID si no se proporciona
if (-not $PackageId) {
    Write-Host "`n🔍 Obteniendo Package ID del UpgradeCap..." -ForegroundColor Yellow
    try {
        $capInfo = sui client object $UpgradeCapId --json | ConvertFrom-Json
        $PackageId = $capInfo.content.fields.package
        Write-Host "   ✅ Package ID: $PackageId" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ Error al obtener Package ID del UpgradeCap" -ForegroundColor Red
        exit 1
    }
}

# Verificar balance
Write-Host "`n💰 VERIFICANDO BALANCE..." -ForegroundColor Blue
$balance = sui client balance 2>&1 | Out-String

if ($balance -match "(\d+\.?\d*)\s+SUI") {
    $balanceActual = [decimal]$Matches[1]
    Write-Host "   💼 Balance actual: $balanceActual SUI" -ForegroundColor Green
    
    $costoEstimado = if ($Red -eq "mainnet") { 0.3 } else { 0.01 }
    
    if ($balanceActual -lt $costoEstimado) {
        Write-Host "   ⚠️  Balance insuficiente para actualización (~$costoEstimado SUI)" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "   ❌ Sin SUI en esta red" -ForegroundColor Red
    exit 1
}

# Compilar proyecto
Write-Host "`n🔨 COMPILANDO PROYECTO ACTUALIZADO..." -ForegroundColor Yellow
sui move build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error en la compilación. Revisa los cambios." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Compilación exitosa" -ForegroundColor Green

# Mostrar resumen antes de actualizar
Write-Host "`n📋 RESUMEN DE ACTUALIZACIÓN:" -ForegroundColor Magenta
Write-Host "   📦 Proyecto: $nombreProyecto"
Write-Host "   🌐 Red: $Red"
Write-Host "   🆔 Package ID: $PackageId"
Write-Host "   🔑 Upgrade Cap: $UpgradeCapId"
Write-Host "   ⛽ Gas Budget: $GasBudget"

$confirmar = Read-Host "`n❓ ¿Proceder con la actualización? (y/n)"

if ($confirmar.ToLower() -notin @("y", "s", "yes", "si", "sí")) {
    Write-Host "❌ Actualización cancelada" -ForegroundColor Yellow
    exit 0
}

# Ejecutar actualización
Write-Host "`n🚀 EJECUTANDO ACTUALIZACIÓN..." -ForegroundColor Cyan
$comando = "sui client upgrade --package-id $PackageId --upgrade-capability $UpgradeCapId --gas-budget $GasBudget"
Write-Host "Comando: $comando" -ForegroundColor Gray

$resultado = Invoke-Expression $comando 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ ¡ACTUALIZACIÓN EXITOSA!" -ForegroundColor Green
    Write-Host "   📦 El paquete $PackageId ha sido actualizado" -ForegroundColor White
    Write-Host "   🔄 Se mantiene el mismo Package ID (no se creó uno nuevo)" -ForegroundColor Green
    
    # Actualizar archivo de último despliegue
    $infoArchivo = ".script\ultimo-despliegue.txt"
    @"
Package ID: $PackageId
Upgrade Cap ID: $UpgradeCapId
Red: $Red
Fecha: $(Get-Date)
Proyecto: $nombreProyecto
Último update: $(Get-Date)
"@ | Out-File -FilePath $infoArchivo -Encoding UTF8
    
    Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Magenta
    Write-Host "   • Para otra actualización: .\.script\upgrade.ps1"
    Write-Host "   • Para interactuar: sui client call --package $PackageId"
    Write-Host "   • Para ver cambios: sui client object $PackageId"
    
} else {
    Write-Host "`n❌ ERROR EN LA ACTUALIZACIÓN" -ForegroundColor Red
    Write-Host $resultado -ForegroundColor Red
    exit 1
}

Write-Host "`n🎉 ¡Script completado!" -ForegroundColor Green

# ============================
# EJEMPLOS DE USO:
# ============================
# .\upgrade.ps1                               # Detecta automáticamente todo
# .\upgrade.ps1 -Red testnet                  # Especifica la red
# .\upgrade.ps1 -UpgradeCapId "0x456..."      # Usa UpgradeCap específico
# .\upgrade.ps1 -PackageId "0x123..." -UpgradeCapId "0x456..."  # Ambos específicos