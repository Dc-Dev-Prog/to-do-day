# ============================================================================
# 💼 GESTOR DE WALLETS SUI v2.3 - FORMATO VISUAL ELEGANTE
# ============================================================================

param(
    [switch]$Lista,
    [switch]$Balance,
    [string]$Red = "",
    [switch]$Export,
    [switch]$Ayuda
)

# Función para generar reportes organizados por tarea
function New-TaskReport {
    param(
        [string]$TaskType,  # lista, balance, export, operaciones
        [object]$Data,
        [string]$Details = ""
    )
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $reportDir = Join-Path (Split-Path $PSScriptRoot) "reports\$TaskType"
    
    if (-not (Test-Path $reportDir)) {
        New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
    }
    
    $reportFile = Join-Path $reportDir "$TaskType-report-$timestamp.md"
    
    $reportContent = @"
# 📊 REPORTE WALLET-MANAGER - $(($TaskType).ToUpper())

**Fecha:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**Tarea:** $TaskType  
**Usuario:** $env:USERNAME  
**Equipo:** $env:COMPUTERNAME  

---

## 📋 Detalles de la Operación

$Details

## 📊 Datos Generados

``````json
$($Data | ConvertTo-Json -Depth 3)
``````

---

**Creado con ❤️ por el equipo de desarrollo de [Dc Studio]()**
"@

    try {
        $reportContent | Out-File -FilePath $reportFile -Encoding UTF8
        Write-Host "📄 Reporte generado: $TaskType-report-$timestamp.md" -ForegroundColor Cyan
        return $reportFile
    } catch {
        Write-Host "⚠️ No se pudo generar reporte: $($_.Exception.Message)" -ForegroundColor Yellow
        return $null
    }
}

# Función simplificada para obtener wallets
function Get-AllWalletsInline {
    try {
        $output = & sui client addresses 2>$null
        if ($LASTEXITCODE -ne 0) {
            return @()
        }
        
        $wallets = @()
        foreach ($line in $output) {
            # Buscar líneas con direcciones 0x
            if ($line -match "0x[0-9a-f]{64}") {
                # Extraer dirección
                if ($line -match "(0x[0-9a-f]{64})") {
                    $address = $matches[1]
                    
                    # Extraer alias - buscar texto antes de la dirección y limpiar caracteres especiales
                    $beforeAddress = $line.Substring(0, $line.IndexOf($address)).Trim()
                    $cleanAlias = $beforeAddress -replace '[^\w\-\s]', '' -replace '\s+', '' -replace '^Γöé|Γöé$', ''
                    
                    # Si no se pudo extraer alias, generar uno
                    if ([string]::IsNullOrWhiteSpace($cleanAlias) -or $cleanAlias -eq "alias") {
                        $cleanAlias = "wallet-" + $address.Substring(2, 8)
                    }
                    
                    # Verificar si está activa (buscar asterisco después de la dirección)
                    $afterAddress = $line.Substring($line.IndexOf($address) + $address.Length).Trim()
                    $isActive = $afterAddress -match '\*' -and $afterAddress.Length -le 10
                    
                    if ($address.Length -eq 66) {  # Verificar longitud correcta de dirección
                        $wallets += [PSCustomObject]@{
                            Alias = $cleanAlias
                            Address = $address
                            IsActive = $isActive
                        }
                    }
                }
            }
        }
        return $wallets
    }
    catch {
        Write-Host "⚠️ Error obteniendo wallets: $($_.Exception.Message)" -ForegroundColor Yellow
        return @()
    }
}

# Función para obtener wallet activa por comando directo
function Get-ActiveWalletInline {
    try {
        $output = & sui client active-address 2>$null
        return $output.Trim()
    }
    catch {
        return $null
    }
}

Write-Host "💼 GESTOR DE WALLETS SUI v2.3" -ForegroundColor Green
Write-Host ("=" * 37) -ForegroundColor Gray

# Comando: Lista con formato visual elegante
if ($Lista) {
    Write-Host "`n📋 WALLETS CONFIGURADAS" -ForegroundColor Cyan
    Write-Host ("=" * 80) -ForegroundColor Gray
    
    $wallets = Get-AllWalletsInline
    $activeWallet = Get-ActiveWalletInline
    
    if ($wallets.Count -eq 0) {
        Write-Host "❌ No se encontraron wallets" -ForegroundColor Red
        exit 1
    } 
    
    # Crear tabla de wallets usando Format-Table
    $tableData = @()
    
    for ($i = 0; $i -lt $wallets.Count; $i++) {
        $wallet = $wallets[$i]
        $number = $i + 1
        
        # Determinar si es activa por dirección o por flag interno
        $isActive = ($wallet.Address -eq $activeWallet) -or $wallet.IsActive
        
        if ($isActive) {
            $estado = "🎯 ACTIVA"
        } else {
            $estado = "💼 Normal"
        }
        
        $tableData += [PSCustomObject]@{
            '#' = $number
            'Estado' = $estado
            'Nombre' = $wallet.Alias
            'Dirección' = $wallet.Address
        }
    }
    
    # Mostrar tabla formateada
    Write-Host ""
    $tableData | Format-Table -AutoSize -Property '#', 'Estado', 'Nombre', 'Dirección'
    
    Write-Host ""
    
    Write-Host ("═" * 60) -ForegroundColor Gray
    Write-Host "💡 Total configuradas: $($wallets.Count) wallet(s)" -ForegroundColor Yellow
    
    # Generar reporte de la operación Lista
    $reportData = @{
        TotalWallets = $wallets.Count
        ActiveWallet = $activeWallet
        Wallets = $wallets | ForEach-Object {
            @{
                Alias = $_.Alias
                Address = $_.Address
                IsActive = ($_.Address -eq $activeWallet)
            }
        }
        Operation = "Lista de wallets"
    }
    
    $details = @"
**Operación:** Listado de wallets configuradas  
**Total encontradas:** $($wallets.Count) wallets  
**Wallet activa:** $activeWallet  
**Formato:** Visual elegante con numeración  

### Wallets Detectadas:

| # | Estado | Nombre | Dirección |
|---|--------|--------|-----------|
$(for ($i = 0; $i -lt $wallets.Count; $i++) {
    $w = $wallets[$i]
    $num = $i + 1
    $estado = if ($w.Address -eq $activeWallet) { "🎯 ACTIVA" } else { "💼 Normal" }
    "| $num | $estado | **$($w.Alias)** | ``$($w.Address)`` |`r`n"
})
"@
    
    New-TaskReport -TaskType "lista" -Data $reportData -Details $details
    exit 0
}

# Comando: Balance
if ($Balance) {
    Write-Host "`n💰 Consulta de saldos" -ForegroundColor Green
    Write-Host ("─" * 30) -ForegroundColor Gray
    
    $wallets = Get-AllWalletsInline
    if ($wallets.Count -eq 0) {
        Write-Host "❌ No se encontraron wallets" -ForegroundColor Red
        exit 1
    }
    
    $networks = if ($Red -eq "all") { @("mainnet", "testnet", "devnet") } 
                elseif ($Red) { @($Red) } 
                else { @("mainnet", "testnet", "devnet") }
    
    $originalNetwork = & sui client active-env 2>$null
    $originalWallet = Get-ActiveWalletInline
    $totalSui = 0.0
    
    foreach ($network in $networks) {
        Write-Host "`n🌐 Red: $network" -ForegroundColor Yellow
        & sui client switch --env $network 2>$null | Out-Null
        
        foreach ($wallet in $wallets) {
            Write-Host "   📍 $($wallet.Alias)" -ForegroundColor Gray
            
            & sui client switch --address $wallet.Address 2>$null | Out-Null
            $balanceOutput = & sui client balance 2>$null
            
            $suiAmount = 0.0
            foreach ($line in $balanceOutput) {
                if ($line -match 'Sui\s+\d+\s+(\d+(?:\.\d+)?)\s*SUI') {
                    $suiAmount = [double]$matches[1]
                    break
                }
            }
            
            if ($suiAmount -gt 0) {
                $usdAmount = ($suiAmount * 3.16).ToString("F2")
                Write-Host "      💰 $suiAmount SUI (~`$$usdAmount USD)" -ForegroundColor Green
                $totalSui += $suiAmount
            } else {
                Write-Host "      💰 Sin saldo" -ForegroundColor Gray
            }
        }
    }
    
    # Restaurar estado
    if ($originalNetwork) {
        & sui client switch --env $originalNetwork 2>$null | Out-Null
    }
    if ($originalWallet) {
        & sui client switch --address $originalWallet 2>$null | Out-Null
    }
    
    $totalUsd = ($totalSui * 3.16).ToString("F2")
    Write-Host "`n💎 TOTAL: $($totalSui.ToString("F4")) SUI (~`$$totalUsd USD)" -ForegroundColor Green
    Write-Host "`n**Creado con ❤️ por el equipo de desarrollo de Dc Studio**" -ForegroundColor Magenta
    
    # Obtener wallet activa para el reporte
    $activeWallet = Get-ActiveWallet
    
    # Generar reporte de la operación Balance
    $reportData = @{
        NetworksQueried = $networks
        TotalWallets = $wallets.Count
        TotalSUI = $totalSui
        TotalUSD = [double]$totalUsd
        BalancesByNetwork = @{}
        Operation = "Consulta de saldos multi-red"
        SuiPrice = 3.16
    }
    
    # Agregar detalles de cada red consultada
    foreach ($net in $networks) {
        $reportData.BalancesByNetwork[$net] = @{
            WalletsWithBalance = 0
            NetworkTotal = 0.0
        }
    }
    
    $details = @"
**Operación:** Consulta de saldos en blockchain SUI  
**Redes consultadas:** $($networks -join ", ")  
**Total de wallets:** $($wallets.Count)  
**Saldo total:** $($totalSui.ToString("F4")) SUI (~`$$totalUsd USD)  
**Precio SUI:** `$3.16 USD (aproximado)  

### Resumen por Red:
$(foreach ($net in $networks) {
    "- **$net**: Consultada exitosamente"
})

### Wallets Analizadas:

| # | Nombre | Dirección | Estado |
|---|--------|-----------|--------|
"@

    # Agregar filas de la tabla
    for ($i = 0; $i -lt $wallets.Count; $i++) {
        $w = $wallets[$i]
        $estado = if ($w.Address -eq $activeWallet) { "🎯 ACTIVA" } else { "💼 Normal" }
        $details += "`n| $($i + 1) | **$($w.Alias)** | ``$($w.Address)`` | $estado |"
    }
    
    New-TaskReport -TaskType "balance" -Data $reportData -Details $details
    exit 0
}

# Comando: Export
if ($Export) {
    Write-Host "`n📤 Exportar wallets" -ForegroundColor Green
    $wallets = Get-AllWalletsInline
    
    if ($wallets.Count -eq 0) {
        Write-Host "❌ No hay wallets para exportar" -ForegroundColor Red
        exit 1
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $exportDir = Join-Path (Split-Path $PSScriptRoot) "reports\export"
    
    if (-not (Test-Path $exportDir)) {
        New-Item -ItemType Directory -Path $exportDir -Force | Out-Null
    }
    
    $exportFile = Join-Path $exportDir "wallets-export-$timestamp.json"
    $activeWallet = Get-ActiveWalletInline
    
    $exportData = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Version = "2.3"
        User = $env:USERNAME
        Computer = $env:COMPUTERNAME
        TotalWallets = $wallets.Count
        ActiveWallet = $activeWallet
        Wallets = $wallets | ForEach-Object {
            @{
                Alias = $_.Alias
                Address = $_.Address
                IsActive = ($_.Address -eq $activeWallet)
            }
        }
    }
    
    try {
        $exportData | ConvertTo-Json -Depth 3 | Out-File -FilePath $exportFile -Encoding UTF8
        Write-Host "✅ Exportadas $($wallets.Count) wallets" -ForegroundColor Green
        Write-Host "📁 $exportFile" -ForegroundColor White
        
        # Generar reporte de la operación Export
        $reportData = @{
            ExportFile = $exportFile
            TotalWallets = $wallets.Count
            ActiveWallet = $activeWallet
            Wallets = $wallets
            Operation = "Exportación de wallets"
            ExportFormat = "JSON"
        }
        
        $details = @"
**Operación:** Exportación de configuración de wallets  
**Archivo generado:** wallets-export-$timestamp.json  
**Total exportadas:** $($wallets.Count) wallets  
**Wallet activa:** $activeWallet  
**Formato:** JSON estructurado con metadata  

### Contenido del Export:
- Timestamp de generación
- Información del sistema (usuario/equipo)
- Lista completa de wallets con sus direcciones
- Identificación de wallet activa
- Metadata de versión

### Wallets Exportadas:
$(foreach ($w in $wallets) {
    $active = if ($w.Address -eq $activeWallet) { " 🎯 (ACTIVA)" } else { " 💼" }
    "- $active **$($w.Alias)**: $($w.Address)"
})
"@
        
        New-TaskReport -TaskType "export" -Data $reportData -Details $details
        
    } catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
    
    exit 0
}

# Comando: Ayuda
if ($Ayuda) {
    Write-Host "`n🎯 AYUDA - GESTOR DE WALLETS SUI v2.3" -ForegroundColor Cyan
    Write-Host ("═" * 45) -ForegroundColor Gray
    Write-Host ""
    Write-Host "📋 COMANDOS:" -ForegroundColor White
    Write-Host "  -Lista           Ver wallets con formato elegante" -ForegroundColor Gray
    Write-Host "  -Balance         Consultar saldos multi-red" -ForegroundColor Gray  
    Write-Host "  -Red <red>       Red específica (mainnet|testnet|devnet|all)" -ForegroundColor Gray
    Write-Host "  -Export          Exportar wallets a JSON" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🎯 EJEMPLOS:" -ForegroundColor White
    Write-Host "  .\wallet-manager-v2.3.ps1 -Lista" -ForegroundColor Gray
    Write-Host "  .\wallet-manager-v2.3.ps1 -Balance -Red all" -ForegroundColor Gray
    Write-Host "  .\wallet-manager-v2.3.ps1 -Export" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🌐 REDES: mainnet 🔴 | testnet 🟡 | devnet 🟢 | all 🌈" -ForegroundColor White
    Write-Host ("═" * 45) -ForegroundColor Gray
    exit 0
}

# Menú interactivo por defecto
Write-Host "`n📊 Estado del sistema:" -ForegroundColor Yellow
$wallets = Get-AllWalletsInline
Write-Host "   💼 Wallets configuradas: $($wallets.Count)" -ForegroundColor White

if ($wallets.Count -gt 0) {
    $activeWallet = Get-ActiveWalletInline
    $activeAlias = ($wallets | Where-Object Address -eq $activeWallet).Alias
    if ($activeAlias) {
        Write-Host "   🎯 Wallet activa: $activeAlias" -ForegroundColor Green
    }
}

Write-Host "`n🎯 Opciones disponibles:" -ForegroundColor Cyan
Write-Host "[1] 📋 Ver wallets (formato elegante)" -ForegroundColor White
Write-Host "[2] 💰 Consultar saldos multi-red" -ForegroundColor White  
Write-Host "[3] 📤 Exportar wallets" -ForegroundColor White
Write-Host "[4] 📖 Mostrar ayuda" -ForegroundColor White
Write-Host "[0] ❌ Salir" -ForegroundColor Yellow

Write-Host -NoNewline "`nIngresa opción (0-4): " -ForegroundColor Cyan
$choice = $Host.UI.ReadLine()

switch ($choice.Trim()) {
    "1" { 
        # Generar reporte de operación interactiva
        $operationData = @{
            MenuChoice = "1 - Ver wallets"
            Action = "Lista formato elegante"
            TotalWallets = $wallets.Count
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Operation = "Menú interactivo - Opción 1"
        }
        
        $operationDetails = @"
**Operación:** Menú interactivo - Ver wallets  
**Opción seleccionada:** [1] 📋 Ver wallets (formato elegante)  
**Total de wallets:** $($wallets.Count)  
**Acción ejecutada:** Llamada a -Lista  

### Contexto del Menú:
- Usuario accedió al menú interactivo
- Sistema detectó $($wallets.Count) wallets configuradas
- Selección manual de opción 1
- Redirección a comando Lista con formato elegante
"@
        
        New-TaskReport -TaskType "operaciones" -Data $operationData -Details $operationDetails
        & $PSCommandPath -Lista 
    }
    "2" { 
        # Generar reporte de operación interactiva
        $operationData = @{
            MenuChoice = "2 - Consultar saldos"
            Action = "Balance multi-red (all)"
            TotalWallets = $wallets.Count
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Operation = "Menú interactivo - Opción 2"
        }
        
        $operationDetails = @"
**Operación:** Menú interactivo - Consultar saldos  
**Opción seleccionada:** [2] 💰 Consultar saldos multi-red  
**Total de wallets:** $($wallets.Count)  
**Acción ejecutada:** Llamada a -Balance -Red all  

### Contexto del Menú:
- Usuario accedió al menú interactivo
- Sistema detectó $($wallets.Count) wallets configuradas
- Selección manual de opción 2
- Consulta automática en todas las redes (mainnet/testnet/devnet)
"@
        
        New-TaskReport -TaskType "operaciones" -Data $operationData -Details $operationDetails
        & $PSCommandPath -Balance -Red all 
    }
    "3" { 
        # Generar reporte de operación interactiva
        $operationData = @{
            MenuChoice = "3 - Exportar wallets"
            Action = "Export JSON"
            TotalWallets = $wallets.Count
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Operation = "Menú interactivo - Opción 3"
        }
        
        $operationDetails = @"
**Operación:** Menú interactivo - Exportar wallets  
**Opción seleccionada:** [3] 📤 Exportar wallets  
**Total de wallets:** $($wallets.Count)  
**Acción ejecutada:** Llamada a -Export  

### Contexto del Menú:
- Usuario accedió al menú interactivo
- Sistema detectó $($wallets.Count) wallets configuradas
- Selección manual de opción 3
- Exportación completa en formato JSON estructurado
"@
        
        New-TaskReport -TaskType "operaciones" -Data $operationData -Details $operationDetails
        & $PSCommandPath -Export 
    }
    "4" { & $PSCommandPath -Ayuda }
    "0" { Write-Host "`n👋 ¡Hasta luego!" -ForegroundColor Green; Write-Host "`n**Creado con ❤️ por el equipo de desarrollo de Dc Studio**" -ForegroundColor Magenta; exit 0 }
    default { Write-Host "`n❌ Opción inválida" -ForegroundColor Red; exit 1 }
}