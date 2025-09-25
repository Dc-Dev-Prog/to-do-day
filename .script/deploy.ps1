# Script Inteligente de Despliegue Sui
# Autor: Copilot Assistant - Refactorizado
# Versión: 2.0

param(
    [Parameter(Mandatory=$false)]
    [string]$Red,
    
    [Parameter(Mandatory=$false)]
    [switch]$ConActualizacion,
    
    [Parameter(Mandatory=$false)]
    [switch]$SinActualizacion,
    
    [Parameter(Mandatory=$false)]
    [string]$GasBudget = "100000000"
)

Write-Host "🚀 SCRIPT INTELIGENTE DE DESPLIEGUE SUI" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# Detectar red actual
$redActual = sui client active-env
Write-Host "🌐 Red actual: $redActual" -ForegroundColor Yellow

# Si no se especifica red, preguntar
if (-not $Red) {
    Write-Host "`n🔍 SELECCIONA LA RED PARA DESPLEGAR:" -ForegroundColor Magenta
    Write-Host "   1️⃣  testnet   (recomendado para pruebas)"
    Write-Host "   2️⃣  mainnet   (producción - cuesta SUI real)"
    Write-Host "   3️⃣  devnet    (desarrollo)"
    Write-Host "   4️⃣  Usar red actual ($redActual)"
    
    do {
        $opcion = Read-Host "`n   Selecciona una opción (1-4)"
        switch ($opcion) {
            "1" { $Red = "testnet"; break }
            "2" { $Red = "mainnet"; break }
            "3" { $Red = "devnet"; break }
            "4" { $Red = $redActual; break }
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

# Detectar proyecto actual
if (-not (Test-Path "Move.toml")) {
    Write-Host "❌ Error: No se encuentra Move.toml en el directorio actual" -ForegroundColor Red
    Write-Host "   Ejecuta este script desde el directorio del proyecto" -ForegroundColor Gray
    exit 1
}

# Leer información del proyecto
$moveToml = Get-Content "Move.toml" -Raw
$nombreProyecto = ($moveToml | Select-String 'name\s*=\s*"([^"]+)"').Matches[0].Groups[1].Value
Write-Host "📦 Proyecto detectado: $nombreProyecto" -ForegroundColor Green

# Verificar balance
Write-Host "`n💰 VERIFICANDO BALANCE..." -ForegroundColor Blue
$balance = sui client balance 2>&1 | Out-String

if ($balance -match "(\d+\.?\d*)\s+SUI") {
    $balanceActual = [decimal]$Matches[1]
    Write-Host "   💼 Balance actual: $balanceActual SUI" -ForegroundColor Green
    
    # Estimar costo rápido
    $costoEstimado = if ($Red -eq "mainnet") { 0.6 } else { 0.01 }
    
    if ($balanceActual -lt $costoEstimado) {
        Write-Host "   ⚠️  Balance insuficiente. Necesitas ~$costoEstimado SUI" -ForegroundColor Red
        if ($Red -eq "mainnet") {
            Write-Host "   💡 Transfiere SUI desde otra wallet o compra en un exchange" -ForegroundColor Yellow
            exit 1
        } else {
            Write-Host "   💡 Usa el faucet: sui client faucet" -ForegroundColor Yellow
            $usarFaucet = Read-Host "   ¿Quieres usar el faucet ahora? (y/n)"
            if ($usarFaucet -eq "y") {
                sui client faucet
            }
        }
    }
} else {
    Write-Host "   ❌ Sin SUI en esta red" -ForegroundColor Red
    if ($Red -ne "mainnet") {
        Write-Host "   💡 Obteniendo SUI del faucet..." -ForegroundColor Yellow
        sui client faucet
    } else {
        Write-Host "   💡 Transfiere SUI desde otra wallet" -ForegroundColor Yellow
        exit 1
    }
}

# Preguntar sobre capacidad de actualización si no se especificó
if (-not $ConActualizacion -and -not $SinActualizacion) {
    Write-Host "`n🔧 CONFIGURACIÓN DE DESPLIEGUE:" -ForegroundColor Magenta
    Write-Host "   ¿Quieres que el contrato sea actualizable?"
    Write-Host "   ✅ SÍ  - Podrás hacer upgrades posteriores"
    Write-Host "   ❌ NO  - Contrato inmutable (más seguro, menor costo)"
    
    do {
        $respuesta = Read-Host "`n   Respuesta (s/n)"
        $respuesta = $respuesta.ToLower()
    } while ($respuesta -notin @("s", "n", "y", "yes", "si", "sí"))
    
    $ConActualizacion = $respuesta -in @("s", "y", "yes", "si", "sí")
}

# Compilar proyecto
Write-Host "`n🔨 COMPILANDO PROYECTO..." -ForegroundColor Yellow
sui move build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error en la compilación. Revisa el código." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Compilación exitosa" -ForegroundColor Green

# Preparar comando de despliegue
$comando = "sui client publish --gas-budget $GasBudget"

if ($ConActualizacion) {
    Write-Host "`n🔄 Desplegando con capacidad de ACTUALIZACIÓN..." -ForegroundColor Yellow
    Write-Host "   📝 Nota: Guarda el Package ID y Upgrade Capability" -ForegroundColor Gray
} else {
    Write-Host "`n🔒 Desplegando como contrato INMUTABLE..." -ForegroundColor Yellow
    Write-Host "   📝 Nota: No se podrá actualizar después" -ForegroundColor Gray
}

# Ejecutar despliegue
Write-Host "`n🚀 EJECUTANDO DESPLIEGUE..." -ForegroundColor Cyan
Write-Host "Comando: $comando" -ForegroundColor Gray

$resultado = Invoke-Expression $comando 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ ¡DESPLIEGUE EXITOSO!" -ForegroundColor Green
    
    # Extraer Package ID del resultado
    $packageId = ($resultado | Select-String 'Package ID: (0x[a-f0-9]+)').Matches[0].Groups[1].Value
    
    if ($packageId) {
        Write-Host "`n📦 INFORMACIÓN IMPORTANTE:" -ForegroundColor Cyan
        Write-Host "   🆔 Package ID: $packageId" -ForegroundColor White
        
        if ($ConActualizacion) {
            # Buscar Upgrade Capability en los objetos
            Write-Host "   🔍 Buscando Upgrade Capability..." -ForegroundColor Yellow
            $objetos = sui client objects 2>&1
            $upgradeCap = ($objetos | Select-String '0x[a-f0-9]+.*UpgradeCap').Matches[0].Value
            
            if ($upgradeCap) {
                $upgradeCapId = ($upgradeCap | Select-String '(0x[a-f0-9]+)').Matches[0].Groups[1].Value
                Write-Host "   🔑 Upgrade Cap ID: $upgradeCapId" -ForegroundColor White
                
                # Guardar información para futuros upgrades
                $infoArchivo = ".script\ultimo-despliegue.txt"
                @"
Package ID: $packageId
Upgrade Cap ID: $upgradeCapId
Red: $Red
Fecha: $(Get-Date)
Proyecto: $nombreProyecto
"@ | Out-File -FilePath $infoArchivo -Encoding UTF8
                
                Write-Host "   💾 Info guardada en: $infoArchivo" -ForegroundColor Gray
            }
        }
    }
    
    Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Magenta
    if ($ConActualizacion) {
        Write-Host "   • Para actualizar: .\.script\upgrade.ps1"
        Write-Host "   • Para ver costos: .\.script\calcular-costo-despliegue.ps1 -Tipo solo-actualizacion"
    }
    Write-Host "   • Para interactuar: sui client call --package $packageId"
    Write-Host "   • Para ver objetos: sui client objects"
    
} else {
    Write-Host "`n❌ ERROR EN EL DESPLIEGUE" -ForegroundColor Red
    Write-Host $resultado -ForegroundColor Red
    exit 1
}

Write-Host "`n🎉 ¡Script completado!" -ForegroundColor Green