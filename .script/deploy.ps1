# Script de despliegue para testnet
# Asegurarse de estar en testnet
sui client switch --env testnet

# Compilar el proyecto
Write-Host "Compilando el proyecto..." -ForegroundColor Yellow
sui move build

# Desplegar con capacidad de actualización
Write-Host "Desplegando en testnet..." -ForegroundColor Yellow
sui client publish --gas-budget 100000000

Write-Host "¡Despliegue completado!" -ForegroundColor Green
Write-Host "Guarda el Package ID y el Upgrade Capability ID para futuras actualizaciones" -ForegroundColor Cyan