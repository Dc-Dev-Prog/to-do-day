param(
    [string]$Red,
    [string]$PackageId,
    [string]$UpgradeCapId,
    [switch]$Testnet,
    [switch]$Mainnet,
    [switch]$Devnet,
    [switch]$Demo,
    [switch]$Redes,
    [string]$GasBudget = "100000000"
)

Write-Host "🔄 UPGRADE SUI v3.0" -ForegroundColor Cyan
if ($Demo) { Write-Host "🎮 MODO DEMO" -ForegroundColor Magenta }

if ($Redes) {
    Write-Host "🌐 mainnet, testnet, devnet"
    exit 0
}

# Datos DEMO
$DEMO_DATA = @{
    TransactionDigest = "HHcAMN7czxSVJMeMkpzfoTKuDSPF9ZW2D24ETh253uSq"
    PackageId         = "0x9ac7c0c2dbbbea3c0a9b99cc6bb3c3b6d5a0e2f1c9a1234567890abcdef123456"
    UpgradeCapId      = "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
    GasCost           = 15000000
}

# Determinar redes
$networksToProcess = @()
if ($Testnet) { $networksToProcess = @("testnet") }
elseif ($Mainnet) { $networksToProcess = @("mainnet") }
elseif ($Devnet) { $networksToProcess = @("devnet") }
elseif ($Red) { $networksToProcess = @($Red) }
else { $networksToProcess = @("mainnet", "testnet", "devnet") }

Write-Host "🔄 Redes: $($networksToProcess -join ', ')" -ForegroundColor Yellow

# Función reporte
function New-ReporteUpgrade {
    param($NetworkName, $PackageId, $UpgradeCapId, $TransactionDigest, $Status, $ErrorMsg, $GasCost, $IsDemo)

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $reportDir = "docs\reports\upgrade\$($NetworkName.ToLower())"
    if (!(Test-Path $reportDir)) {
        New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
    }

    $reportFile = "$reportDir\reporte-upgrade-$($NetworkName.ToLower())-$timestamp.md"
    $statusIcon = if ($Status -eq "Exitoso") { "✅" } else { "❌" }
    $modeIcon = if ($IsDemo) { "🎮 DEMO" } else { "💰 REAL" }

    $walletAddress = try { (sui client active-address 2>$null).Trim() } catch { "No disponible" }

    $content = @"
# 🔄 Reporte Upgrade - $($NetworkName.ToUpper()) $statusIcon

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | $(Get-Date -Format "yyyy-MM-dd HH:mm:ss") |
| **🌐 Red** | $($NetworkName.ToUpper()) |
| **👤 Wallet** | ``$walletAddress`` |
| **📦 PackageId** | ``$PackageId`` |
| **🔑 UpgradeCapId** | ``$UpgradeCapId`` |
| **🎮 Modo** | $modeIcon |
| **📊 Estado** | $statusIcon $Status |

"@

    if ($Status -eq "Exitoso") {
        $content += "## ✅ Upgrade OK`n- **TX**: ``$TransactionDigest```n- **Gas**: $GasCost MIST`n"
    }
    else {
        $content += "## ❌ Error: $ErrorMsg`n### 🎯 Solución: Deploy primero`n```````.\.script\deploy.ps1 -Red $($NetworkName.ToLower())```````n"
    }

    $content += "---`n**📝 upgrade.ps1 v3.0**"

    try {
        $content | Out-File -FilePath $reportFile -Encoding UTF8
        Write-Host "📋 $reportFile" -ForegroundColor Green
    }
    catch {
        Write-Warning "❌ Error reporte: $($_.Exception.Message)"
    }
}

# Procesar redes
foreach ($currentNetwork in $networksToProcess) {
    Write-Host "`n🌐 PROCESANDO: $($currentNetwork.ToUpper())" -ForegroundColor Cyan

    # DEMO MAINNET
    if ($Demo -and $currentNetwork -eq "mainnet") {
        Write-Host "🎮 DEMO MAINNET" -ForegroundColor Magenta
        Start-Sleep 1
        New-ReporteUpgrade -NetworkName $currentNetwork -PackageId $DEMO_DATA.PackageId -UpgradeCapId $DEMO_DATA.UpgradeCapId -TransactionDigest $DEMO_DATA.TransactionDigest -Status "Exitoso" -GasCost $DEMO_DATA.GasCost -IsDemo $true
        Write-Host "✅ DEMO OK - $($DEMO_DATA.GasCost) MIST" -ForegroundColor Green
        continue
    }

    # Conectar red
    Write-Host "🔧 Conectando..." -ForegroundColor Yellow
    try {
        sui client switch --env $currentNetwork | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Error conexión" -ForegroundColor Red
            New-ReporteUpgrade -NetworkName $currentNetwork -PackageId "N/A" -UpgradeCapId "N/A" -Status "Error" -ErrorMsg "Conexión fallida" -IsDemo $false
            continue
        }
    }
    catch {
        New-ReporteUpgrade -NetworkName $currentNetwork -PackageId "N/A" -UpgradeCapId "N/A" -Status "Error" -ErrorMsg $_.Exception.Message -IsDemo $false
        continue
    }

    # Buscar UpgradeCap
    $upgradeCapToUse = $UpgradeCapId
    if (-not $upgradeCapToUse) {
        Write-Host "🔍 Buscando UpgradeCap..." -ForegroundColor Yellow
        try {
            $objects = sui client objects --json 2>$null | ConvertFrom-Json
            $upgradeCaps = $objects | Where-Object { $_.data.type -like "*UpgradeCap*" }

            if ($upgradeCaps) {
                $upgradeCapToUse = $upgradeCaps[0].data.objectId
                Write-Host "✅ UpgradeCap: $upgradeCapToUse" -ForegroundColor Green
            }
            else {
                Write-Host "⚠️ No UpgradeCaps" -ForegroundColor Yellow
                New-ReporteUpgrade -NetworkName $currentNetwork -PackageId ($PackageId ?? "N/A") -UpgradeCapId "N/A" -Status "Error" -ErrorMsg "No UpgradeCaps - Deploy primero" -IsDemo $false
                continue
            }
        }
        catch {
            New-ReporteUpgrade -NetworkName $currentNetwork -PackageId ($PackageId ?? "N/A") -UpgradeCapId "N/A" -Status "Error" -ErrorMsg "Error objetos" -IsDemo $false
            continue
        }
    }

    # UPGRADE
    Write-Host "🔄 Upgrading..." -ForegroundColor Green
    Write-Host "🔑 $upgradeCapToUse" -ForegroundColor Cyan

    try {
        $result = sui client upgrade . --upgrade-capability $upgradeCapToUse --gas-budget $GasBudget --json 2>&1

        if ($LASTEXITCODE -eq 0) {
            try {
                $json = $result | ConvertFrom-Json
                $txDigest = $json.digest
                $gasCost = if ($json.effects.gasUsed) { 
                    $json.effects.gasUsed.computationCost + $json.effects.gasUsed.storageCost 
                }
                else { 0 }

                Write-Host "✅ OK!" -ForegroundColor Green
                Write-Host "🔗 $txDigest" -ForegroundColor Cyan
                New-ReporteUpgrade -NetworkName $currentNetwork -PackageId ($PackageId ?? "Auto") -UpgradeCapId $upgradeCapToUse -TransactionDigest $txDigest -Status "Exitoso" -GasCost $gasCost -IsDemo $false
            }
            catch {
                Write-Host "✅ Completado" -ForegroundColor Green
                New-ReporteUpgrade -NetworkName $currentNetwork -PackageId ($PackageId ?? "Auto") -UpgradeCapId $upgradeCapToUse -TransactionDigest "Ver output" -Status "Exitoso" -IsDemo $false
            }
        }
        else {
            $errorMsg = $result -join " "
            Write-Host "❌ $errorMsg" -ForegroundColor Red
            New-ReporteUpgrade -NetworkName $currentNetwork -PackageId ($PackageId ?? "Auto") -UpgradeCapId $upgradeCapToUse -Status "Error" -ErrorMsg $errorMsg -IsDemo $false
        }
    }
    catch {
        Write-Host "❌ $($_.Exception.Message)" -ForegroundColor Red
        New-ReporteUpgrade -NetworkName $currentNetwork -PackageId ($PackageId ?? "Auto") -UpgradeCapId $upgradeCapToUse -Status "Error" -ErrorMsg $_.Exception.Message -IsDemo $false
    }
}

Write-Host "`n🎉 Completado! docs\reports\upgrade\" -ForegroundColor Green
