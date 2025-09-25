# Script de actualización para testnet
param(
    [Parameter(Mandatory = $false)]
    [string]$PackageId,
    
    [Parameter(Mandatory = $false)]
    [string]$UpgradeCapId
)

# Tus UpgradeCaps disponibles (del más reciente al más antiguo)
$availableCaps = @(
    "0x039aba13ae7fae8f7ad0537f5ede79c334fbcc40055b9c14b6db737472967ab0",
    "0x5d0d6b1d4c035ef09abe4a3cd9e395673c3e3290b3f17bca5583ae3f2bb6802c",
    "0xccaf53beb7a1c9b9ff11edbaa37fac6e8d62e58fab69eb64bc9c0c7696336e56"
)

# Si no se proporciona UpgradeCap, usar el más reciente
if (-not $UpgradeCapId) {
    $UpgradeCapId = $availableCaps[0]
    Write-Host "Usando UpgradeCap más reciente: $UpgradeCapId" -ForegroundColor Cyan
}

# Asegurarse de estar en testnet
sui client switch --env testnet

# Compilar el proyecto actualizado
Write-Host "Compilando proyecto actualizado..." -ForegroundColor Yellow
sui move build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error en la compilación. Abortando." -ForegroundColor Red
    exit 1
}

# Si no se proporciona PackageId, obtenerlo del UpgradeCap
if (-not $PackageId) {
    Write-Host "Obteniendo Package ID del UpgradeCap..." -ForegroundColor Yellow
    $capInfo = sui client object $UpgradeCapId --json | ConvertFrom-Json
    $PackageId = $capInfo.content.fields.package
    Write-Host "Package ID encontrado: $PackageId" -ForegroundColor Cyan
}

# Actualizar el contrato (NO crear uno nuevo)
Write-Host "Actualizando contrato existente en testnet..." -ForegroundColor Yellow
Write-Host "Package ID: $PackageId" -ForegroundColor Gray
Write-Host "Upgrade Cap: $UpgradeCapId" -ForegroundColor Gray

sui client upgrade --package-id $PackageId --upgrade-capability $UpgradeCapId --gas-budget 100000000

if ($LASTEXITCODE -eq 0) {
    Write-Host "¡Actualización completada exitosamente!" -ForegroundColor Green
    Write-Host "El paquete $PackageId ha sido actualizado (no se creó un nuevo paquete)" -ForegroundColor Green
}
else {
    Write-Host "Error durante la actualización" -ForegroundColor Red
}

# Ejemplo de uso:
# .\upgrade.ps1                                    # Usa el UpgradeCap más reciente automáticamente
# .\upgrade.ps1 -UpgradeCapId "0x456..."          # Especifica un UpgradeCap específico
# .\upgrade.ps1 -PackageId "0x123..." -UpgradeCapId "0x456..."  # Especifica ambos manualmente