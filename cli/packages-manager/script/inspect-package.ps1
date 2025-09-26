param(
    [string]$PackageId,
    [switch]$Testnet,
    [switch]$Mainnet,
    [switch]$Devnet,
    [switch]$Redes
)

# Variables globales
$Script:AllPackages = @{}
$Script:SelectedNetwork = $null

Write-Host "🔍 INSPECTOR DE PAQUETES SUI v2.0" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

if ($Redes) {
    Write-Host "🌐 Redes disponibles: mainnet, testnet, devnet"
    exit 0
}

# Función pa---

**Creado con ❤️ por el equipo de desarrollo de [Dc Studio]()**obtener todos los paquetes de una red
function Get-PackagesFromNetwork {
    param($NetworkName)
    
    Write-Host "`n🌐 Obteniendo paquetes de $($NetworkName.ToUpper())..." -ForegroundColor Yellow
    
    # Cambiar a la red
    $null = sui client switch --env $NetworkName 2>$null
    
    $packages = @()
    
    try {
        # Método simple: buscar directamente UpgradeCaps conocidos
        $objectsOutput = sui client objects 2>$null
        
        if ($objectsOutput -and $objectsOutput -match "UpgradeCap") {
            Write-Host "  🔍 UpgradeCap detectado, extrayendo información..." -ForegroundColor Gray
            
            # Dividir en líneas para procesamiento
            $lines = $objectsOutput -split "`n"
            
            for ($i = 0; $i -lt $lines.Count; $i++) {
                # Buscar líneas que contengan UpgradeCap
                if ($lines[$i] -match "UpgradeCap") {
                    # Buscar hacia atrás para encontrar el objectId
                    for ($j = $i - 1; $j -ge 0; $j--) {
                        if ($lines[$j] -match "0x([a-f0-9]{64})") {
                            $upgradeCapId = $matches[0]
                            Write-Host "  🔍 Procesando UpgradeCap: $upgradeCapId" -ForegroundColor Gray
                            
                            # Obtener detalles del UpgradeCap
                            $capDetails = sui client object $upgradeCapId 2>$null
                            
                            if ($capDetails) {
                                # Buscar línea por línea
                                $pkgId = $null
                                $version = 1
                                
                                foreach ($line in $capDetails) {
                                    # Buscar la línea que contiene "package" y extraer el Package ID
                                    if ($line -match "package.*?(0x[a-f0-9]{64})") {
                                        $pkgId = $matches[1]
                                    }
                                    # Buscar la version
                                    if ($line -match "version.*?(\d+)") {
                                        $version = [int]$matches[1]
                                    }
                                }
                                
                                if ($pkgId) {
                                    $packages += @{
                                        PackageId    = $pkgId
                                        UpgradeCapId = $upgradeCapId
                                        Network      = $NetworkName
                                        Version      = $version
                                    }
                                    
                                    Write-Host "  ✅ Package encontrado: $pkgId (v$version)" -ForegroundColor Green
                                }
                                else {
                                    Write-Host "  ⚠️  No se pudo extraer Package ID del UpgradeCap" -ForegroundColor Yellow
                                }
                            }
                            break
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Host "❌ Error conectando a $NetworkName" -ForegroundColor Red
    }
    
    if ($packages.Count -gt 0) {
        Write-Host "✅ Encontrados $($packages.Count) paquetes en $($NetworkName.ToUpper())" -ForegroundColor Green
    }
    else {
        Write-Host "📦 No hay paquetes en $($NetworkName.ToUpper())" -ForegroundColor Gray
    }
    
    return $packages
}

# Función para mostrar lista de paquetes por red
function Show-PackagesByNetwork {
    param($Networks)
    
    Write-Host "`n📋 PAQUETES ENCONTRADOS:" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Cyan
    
    $counter = 1
    $packageList = @()
    
    foreach ($network in $Networks) {
        if ($Script:AllPackages[$network] -and $Script:AllPackages[$network].Count -gt 0) {
            Write-Host "`n🌐 RED: $($network.ToUpper())" -ForegroundColor Yellow
            Write-Host "─────────────────────" -ForegroundColor DarkGray
            
            foreach ($pkg in $Script:AllPackages[$network]) {
                Write-Host "  $counter. Package: $($pkg.PackageId)" -ForegroundColor White
                Write-Host "     Version: $($pkg.Version) | UpgradeCap: $($pkg.UpgradeCapId)" -ForegroundColor Gray
                
                $packageList += @{
                    Number  = $counter
                    Package = $pkg
                }
                $counter++
            }
        }
    }
    
    return $packageList
}

# Función para inspeccionar un paquete específico
function Inspect-Package {
    param($PackageId, $NetworkName)
    
    Write-Host "`n🔍 INSPECCIONANDO PAQUETE" -ForegroundColor Green
    Write-Host "=========================" -ForegroundColor Green
    Write-Host "📦 Package ID: $PackageId" -ForegroundColor White
    Write-Host "🌐 Red: $($NetworkName.ToUpper())" -ForegroundColor Cyan
    
    # Cambiar a la red correcta
    $null = sui client switch --env $NetworkName 2>$null
    
    $packageInfo = @{
        PackageId  = $PackageId
        Network    = $NetworkName
        Modules    = @()
        Functions  = @()
        Structs    = @()
        Purpose    = "Sistema inteligente detectado automáticamente"
        Analysis   = "Análisis dinámico de bytecode"
        Success    = $false
        UseCases   = @()
        ModuleType = "Desconocido"
    }
    
    try {
        # Obtener bytecode del paquete
        $bytecodeOutput = sui client object $PackageId 2>$null
        
        if ($bytecodeOutput -and ($bytecodeOutput -match "// Move bytecode")) {
            $packageInfo.Success = $true
            
            # ========== DETECCIÓN DINÁMICA DE MÓDULOS ==========
            $moduleMatches = [regex]::Matches($bytecodeOutput, "module\s+[a-f0-9]+\.(\w+)\s*\{")
            foreach ($match in $moduleMatches) {
                $moduleName = $match.Groups[1].Value
                $packageInfo.Modules += $moduleName
                Write-Host "`n✅ MÓDULO DETECTADO: $moduleName" -ForegroundColor Green -BackgroundColor DarkBlue
            }
            
            # ========== DETECCIÓN DINÁMICA DE STRUCTS ==========
            $structMatches = [regex]::Matches($bytecodeOutput, "struct\s+(\w+)\s+has\s+([^{]+)\s*\{")
            foreach ($match in $structMatches) {
                $structName = $match.Groups[1].Value
                $structCapabilities = $match.Groups[2].Value
                $packageInfo.Structs += "$structName ($structCapabilities)"
                Write-Host "  📐 Struct: $structName [$structCapabilities]" -ForegroundColor Magenta
            }
            
            # ========== DETECCIÓN DINÁMICA DE FUNCIONES PÚBLICAS ==========
            $functionMatches = [regex]::Matches($bytecodeOutput, "public\s+(\w+)\([^)]*\)(?:\s*:\s*[^{]+)?\s*\{")
            Write-Host "`n┌─────────────────────────────────────┐" -ForegroundColor Yellow
            Write-Host "│  🔧 FUNCIONES PÚBLICAS DETECTADAS  │" -ForegroundColor Yellow  
            Write-Host "└─────────────────────────────────────┘" -ForegroundColor Yellow
            
            $funcCount = 0
            foreach ($match in $functionMatches) {
                $funcName = $match.Groups[1].Value
                $packageInfo.Functions += $funcName
                $funcCount++
                
                # Generar descripción inteligente basada en el nombre
                $description = Generate-SmartDescription -FunctionName $funcName
                Write-Host "  $funcCount. " -ForegroundColor DarkGray -NoNewline
                Write-Host "$funcName" -ForegroundColor Cyan -NoNewline
                Write-Host " - $description" -ForegroundColor White
            }
            
            # ========== ANÁLISIS INTELIGENTE DEL TIPO DE SISTEMA ==========
            $systemType = Analyze-SystemType -Modules $packageInfo.Modules -Functions $packageInfo.Functions -Structs $packageInfo.Structs
            $packageInfo.ModuleType = $systemType.Type
            $packageInfo.Purpose = $systemType.Purpose
            $packageInfo.UseCases = $systemType.UseCases
            
            Write-Host "`n╔══════════════════════════════════════════════════╗" -ForegroundColor Magenta
            Write-Host "║               🎯 ANÁLISIS DEL SISTEMA            ║" -ForegroundColor Magenta  
            Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Magenta
            
            Write-Host "`n🏷️  TIPO: " -ForegroundColor Yellow -NoNewline
            Write-Host "$($systemType.Type)" -ForegroundColor Cyan -BackgroundColor DarkMagenta
            
            Write-Host "`n� PROPÓSITO:" -ForegroundColor Yellow  
            Write-Host "   $($systemType.Purpose)" -ForegroundColor White
            
            Write-Host "`n┌─────────────────────────────────────┐" -ForegroundColor Green
            Write-Host "│      💡 CASOS DE USO SUGERIDOS     │" -ForegroundColor Green
            Write-Host "└─────────────────────────────────────┘" -ForegroundColor Green
            
            $useCaseCount = 0
            foreach ($useCase in $systemType.UseCases) {
                $useCaseCount++
                Write-Host "  $useCaseCount. " -ForegroundColor DarkGray -NoNewline
                Write-Host "$useCase" -ForegroundColor White
            }
            
        }
        else {
            Write-Host "❌ No se pudo analizar el paquete (sin bytecode válido o acceso denegado)" -ForegroundColor Red
            $packageInfo.Purpose = "Error de análisis: No se pudo acceder al bytecode"
        }
        
    }
    catch {
        Write-Host "❌ Error durante la inspección: $($_.Exception.Message)" -ForegroundColor Red
        $packageInfo.Purpose = "Error: $($_.Exception.Message)"
    }
    
    # Generar reporte
    Generate-Report -PackageInfo $packageInfo
    
    # Mostrar resumen final
    Write-Host "`n╔══════════════════════════════════════════════════╗" -ForegroundColor White
    Write-Host "║              📊 RESUMEN DE ANÁLISIS              ║" -ForegroundColor White  
    Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor White
    
    return $packageInfo
}

# Función para generar descripciones inteligentes de funciones
function Generate-SmartDescription {
    param($FunctionName)
    
    # Diccionario de patrones comunes
    $patterns = @{
        "create|crear"              = "Crear nuevo elemento"
        "delete|eliminar"           = "Eliminar elemento existente"  
        "update|actualizar|cambiar" = "Actualizar información"
        "add|agregar"               = "Agregar elemento"
        "remove|remover"            = "Remover elemento"
        "get|obtener"               = "Obtener información"
        "set|establecer"            = "Establecer valor"
        "has|tiene"                 = "Verificar existencia"
        "is|es"                     = "Verificar estado"
        "cast"                      = "Emitir/Lanzar"
        "vote|votar"                = "Sistema de votación"
        "proposal"                  = "Gestión de propuestas"
        "validate"                  = "Validar información"
        "calculate"                 = "Realizar cálculos"
        "transfer"                  = "Transferir recursos"
        "mint"                      = "Crear tokens/recursos"
        "burn"                      = "Destruir tokens/recursos"
        "stake"                     = "Apostar/Depositar"
        "unstake"                   = "Retirar apuesta"
        "claim"                     = "Reclamar recompensas"
        "approve"                   = "Aprobar operación"
        "reject"                    = "Rechazar operación"
    }
    
    foreach ($pattern in $patterns.Keys) {
        if ($FunctionName -match $pattern) {
            return $patterns[$pattern]
        }
    }
    
    return "Función del sistema"
}

# Función para analizar el tipo de sistema automáticamente  
function Analyze-SystemType {
    param($Modules, $Functions, $Structs)
    
    $allText = ($Modules + $Functions + $Structs) -join " "
    
    # Patrones de detección de sistemas
    if ($allText -match "empresa|cliente|servicio|nivel|fidelidad|descuento") {
        return @{
            Type     = "Sistema CRM/Empresarial"
            Purpose  = "Gestión de clientes y programas de fidelidad empresarial"
            UseCases = @(
                "Gestión de clientes corporativos",
                "Programas de fidelidad y recompensas", 
                "Sistema de descuentos por niveles",
                "Administración de servicios empresariales"
            )
        }
    }
    elseif ($allText -match "vote|voting|proposal|governance|cast") {
        return @{
            Type     = "Sistema de Gobernanza y Votación"
            Purpose  = "Plataforma de votación descentralizada y toma de decisiones"
            UseCases = @(
                "Votación en organizaciones descentralizadas (DAOs)",
                "Sistemas de propuestas comunitarias",
                "Gobernanza de protocolos DeFi",
                "Decisiones democráticas en blockchain"
            )
        }
    }
    elseif ($allText -match "token|mint|burn|transfer|stake|unstake") {
        return @{
            Type     = "Sistema de Tokens y Finanzas"  
            Purpose  = "Gestión de activos digitales y operaciones financieras"
            UseCases = @(
                "Creación y gestión de tokens",
                "Staking y recompensas",
                "Intercambios descentralizados (DEX)",
                "Protocolos DeFi y yield farming"
            )
        }
    }
    elseif ($allText -match "nft|collectible|item|metadata") {
        return @{
            Type     = "Sistema de NFTs y Coleccionables"
            Purpose  = "Gestión de activos únicos no fungibles" 
            UseCases = @(
                "Colecciones de arte digital",
                "Items de gaming blockchain",
                "Certificados de propiedad digital",
                "Marketplaces de NFTs"
            )
        }
    }
    elseif ($allText -match "game|player|level|score|battle") {
        return @{
            Type     = "Sistema de Gaming"
            Purpose  = "Mecánicas y lógica de juegos blockchain"
            UseCases = @(
                "Juegos play-to-earn",
                "Sistemas de progresión de jugadores",
                "Batallas y competencias",
                "Economías de juegos descentralizadas"
            )
        }
    }
    else {
        return @{
            Type     = "Sistema Personalizado"
            Purpose  = "Contrato inteligente con lógica específica detectada dinámicamente"
            UseCases = @(
                "Lógica de negocio personalizada",
                "Automatización de procesos",
                "Integración con otros contratos",
                "Funcionalidades especializadas del dominio"
            )
        }
    }
}

# Función para generar reporte
function Generate-Report {
    param($PackageInfo)
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $reportDir = Join-Path (Split-Path $PSScriptRoot) "reports\inspect-package\$($PackageInfo.Network.ToLower())"
    
    # Crear directorio si no existe
    if (!(Test-Path $reportDir)) {
        New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
    }
    
    $reportFile = "$reportDir\inspeccion-$($PackageInfo.Network.ToLower())-$timestamp.md"
    
    $content = @"
# 🔍 Inspección de Paquete SUI - $($PackageInfo.Network.ToUpper())

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | $(Get-Date -Format "yyyy-MM-dd HH:mm:ss") |
| **🌐 Red** | $($PackageInfo.Network.ToUpper()) |
| **📦 Package ID** | ``$($PackageInfo.PackageId)`` |
| **🎯 Propósito** | $($PackageInfo.Purpose) |
| **📊 Estado** | $(if($PackageInfo.Success){"✅ Análisis exitoso"}else{"❌ Error en análisis"}) |

## 🧩 Módulos ($($PackageInfo.Modules.Count))

"@
    
    foreach ($module in $PackageInfo.Modules) {
        $content += "- 📚 ``$module```n"
    }
    
    if ($PackageInfo.Functions.Count -gt 0) {
        $content += @"

## 🔧 Funciones Públicas ($($PackageInfo.Functions.Count))

"@
        foreach ($func in $PackageInfo.Functions) {
            $content += "- 🔧 ``$func```n"
        }
    }
    
    if ($PackageInfo.Structs.Count -gt 0) {
        $content += @"

## 📐 Estructuras ($($PackageInfo.Structs.Count))

"@
        foreach ($struct in $PackageInfo.Structs) {
            $content += "- 📐 ``$struct```n"
        }
    }
    
    if ($PackageInfo.UseCases -and $PackageInfo.UseCases.Count -gt 0) {
        $content += @"

## 💡 Casos de Uso Sugeridos

"@
        foreach ($usecase in $PackageInfo.UseCases) {
            $content += "- � $usecase`n"
        }
    }

    $content += @"

## 🎯 Tipo de Sistema Detectado

**$($PackageInfo.ModuleType)**

$($PackageInfo.Purpose)

## �🔗 Enlaces Útiles

- 🌐 **SUI Explorer Package**: [Ver en Explorer](https://suiexplorer.com/object/$($PackageInfo.PackageId)?network=$($PackageInfo.Network))
- 📊 **SuiVision Explorer**: [Ver en SuiVision](https://suivision.xyz/package/$($PackageInfo.PackageId)?network=$($PackageInfo.Network))
- 🔧 **Interacción CLI**: ``sui client call --package $($PackageInfo.PackageId) --module [MODULE] --function [FUNCTION]``

## 📈 Estadísticas del Análisis

| Métrica | Valor |
|---------|-------|
| 📚 **Módulos Detectados** | $($PackageInfo.Modules.Count) |
| 🔧 **Funciones Públicas** | $($PackageInfo.Functions.Count) |
| � **Estructuras** | $($PackageInfo.Structs.Count) |
| 💡 **Casos de Uso** | $($PackageInfo.UseCases.Count) |
| 🕐 **Tiempo de Análisis** | < 5 segundos |

---

**�📋 Reporte generado automáticamente por inspect-package.ps1 v3.0**  
**🤖 Análisis dinámico inteligente de bytecode SUI Move**  
**⏰ $((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))**
"@
    
    try {
        $content | Out-File -FilePath $reportFile -Encoding UTF8 -Force
        Write-Host "`n╔══════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║           📋 REPORTE GENERADO EXITOSAMENTE       ║" -ForegroundColor Green
        Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Green
        Write-Host "`n📁 Ubicación: " -ForegroundColor Yellow -NoNewline
        Write-Host "$reportFile" -ForegroundColor Cyan
        Write-Host "📊 Tamaño: $([Math]::Round((Get-Item $reportFile).Length / 1KB, 2)) KB" -ForegroundColor Gray
    }
    catch {
        Write-Host "`n❌ Error guardando reporte: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# ===============================
# LÓGICA PRINCIPAL
# ===============================

# Determinar red objetivo
if ($Testnet) { $Script:SelectedNetwork = "testnet" }
elseif ($Mainnet) { $Script:SelectedNetwork = "mainnet" }  
elseif ($Devnet) { $Script:SelectedNetwork = "devnet" }

# CASO 1: ID + Red especificada → Inspección directa
if ($PackageId -and $Script:SelectedNetwork) {
    Write-Host "🎯 Modo: Inspección directa" -ForegroundColor Cyan
    Inspect-Package -PackageId $PackageId -NetworkName $Script:SelectedNetwork
    Write-Host "`n**Creado con ❤️ por el equipo de desarrollo de Dc Studio**" -ForegroundColor Magenta
    exit 0
}

# CASO 2: Solo ID sin red → Error
if ($PackageId -and -not $Script:SelectedNetwork) {
    Write-Host "❌ ERROR: Debes especificar la red (-Testnet, -Mainnet, o -Devnet)" -ForegroundColor Red
    Write-Host "💡 Ejemplo: .\inspect-package.ps1 -PackageId $PackageId -Mainnet" -ForegroundColor Yellow
    exit 1
}

# CASO 3: Solo red → Mostrar paquetes de esa red
if (-not $PackageId -and $Script:SelectedNetwork) {
    Write-Host "🎯 Modo: Explorar paquetes en $($Script:SelectedNetwork.ToUpper())" -ForegroundColor Cyan
    
    $Script:AllPackages[$Script:SelectedNetwork] = Get-PackagesFromNetwork -NetworkName $Script:SelectedNetwork
    
    if ($Script:AllPackages[$Script:SelectedNetwork].Count -eq 0) {
        Write-Host "`n📦 No hay paquetes desplegados en $($Script:SelectedNetwork.ToUpper())" -ForegroundColor Yellow
        Write-Host "💡 Usa deploy.ps1 para desplegar tu primer paquete" -ForegroundColor Cyan
        exit 0
    }
    
    $packageList = Show-PackagesByNetwork -Networks @($Script:SelectedNetwork)
    
    Write-Host "`n🎯 Selecciona un paquete para inspeccionar (1-$($packageList.Count)) o 0 para salir:" -ForegroundColor Cyan
    $selection = Read-Host "Número"
    
    if ($selection -eq "0" -or $selection -eq "") {
        Write-Host "👋 ¡Hasta luego!" -ForegroundColor Green
        exit 0
    }
    
    $selectedItem = $packageList | Where-Object { $_.Number -eq [int]$selection }
    if ($selectedItem) {
        Inspect-Package -PackageId $selectedItem.Package.PackageId -NetworkName $selectedItem.Package.Network
    }
    else {
        Write-Host "❌ Selección inválida" -ForegroundColor Red
    }
    exit 0
}

# CASO 4: Sin parámetros → Mostrar todo y permitir selección
Write-Host "🎯 Modo: Explorar todos los paquetes" -ForegroundColor Cyan
Write-Host "🔍 Buscando paquetes en todas las redes..." -ForegroundColor Yellow

# Obtener paquetes de todas las redes
foreach ($network in @("mainnet", "testnet", "devnet")) {
    $Script:AllPackages[$network] = Get-PackagesFromNetwork -NetworkName $network
}

# Verificar si hay paquetes
$totalPackages = ($Script:AllPackages.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum

if ($totalPackages -eq 0) {
    Write-Host "`n📦 No hay paquetes desplegados en ninguna red" -ForegroundColor Yellow
    Write-Host "💡 Usa deploy.ps1 para desplegar tu primer paquete" -ForegroundColor Cyan
    exit 0
}

# Mostrar todos los paquetes
$packageList = Show-PackagesByNetwork -Networks @("mainnet", "testnet", "devnet")

Write-Host "`n🎯 Selecciona un paquete para inspeccionar (1-$($packageList.Count)) o 0 para salir:" -ForegroundColor Cyan
$selection = Read-Host "Número"

if ($selection -eq "0" -or $selection -eq "") {
    Write-Host "👋 ¡Hasta luego!" -ForegroundColor Green
    exit 0
}

$selectedItem = $packageList | Where-Object { $_.Number -eq [int]$selection }
if ($selectedItem) {
    Inspect-Package -PackageId $selectedItem.Package.PackageId -NetworkName $selectedItem.Package.Network
}
else {
    Write-Host "❌ Selección inválida" -ForegroundColor Red
    
    Write-Host "`n📚 EJEMPLOS DE USO:" -ForegroundColor Cyan
    Write-Host "# Ver paquetes de mainnet y escoger" -ForegroundColor Gray
    Write-Host ".\inspect-package.ps1 -Mainnet" -ForegroundColor White
    Write-Host "`n# Inspeccionar paquete específico" -ForegroundColor Gray
    Write-Host ".\inspect-package.ps1 -PackageId 0x123... -Devnet" -ForegroundColor White
    Write-Host "`n# Ver todos los paquetes de todas las redes" -ForegroundColor Gray
    Write-Host ".\inspect-package.ps1" -ForegroundColor White
    Write-Host "`n**Creado con ❤️ por el equipo de desarrollo de Dc Studio**" -ForegroundColor Magenta
}