# Script para identificar tus paquetes y sus UpgradeCaps
Write-Host "=== TUS PAQUETES DESPLEGADOS ===" -ForegroundColor Cyan

# Lista de tus UpgradeCaps
$upgradeCaps = @(
    "0x039aba13ae7fae8f7ad0537f5ede79c334fbcc40055b9c14b6db737472967ab0",
    "0x5d0d6b1d4c035ef09abe4a3cd9e395673c3e3290b3f17bca5583ae3f2bb6802c",
    "0xccaf53beb7a1c9b9ff11edbaa37fac6e8d62e58fab69eb64bc9c0c7696336e56"
)

foreach ($cap in $upgradeCaps) {
    Write-Host "`n--- UpgradeCap: $cap ---" -ForegroundColor Yellow
    sui client object $cap --json | ConvertFrom-Json | Select-Object -ExpandProperty content | Select-Object -ExpandProperty fields
}