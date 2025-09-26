# 📂 EJEMPLOS DE USO - WALLET MANAGER

## 🎯 Casos de Uso Comunes

### 1. Ver wallets disponibles (formato elegante)
```powershell
.\wallet-manager.ps1 -Lista
```
**Salida esperada:**
```
══════════════════════════════════════════════════
                  📱 WALLETS SUI
══════════════════════════════════════════════════

📋 Tienes 4 wallets configuradas:

   1️⃣ 💼 Arc-Sui-Pro
   2️⃣ 💼 test-wallet
   3️⃣ 🎯 dc-sui-PC (activa)
   4️⃣ 💼 dev-wallet

══════════════════════════════════════════════════
```

### 2. Consultar saldos multi-red
```powershell
# Una red específica
.\wallet-manager.ps1 -Balance -Red mainnet

# Todas las redes
.\wallet-manager.ps1 -Balance -Red all
```

### 3. Exportar configuración
```powershell
.\wallet-manager.ps1 -Export
```
**Genera:** `wallet-export-20240115-143022.json`

### 4. Menú interactivo completo
```powershell
.\wallet-manager.ps1
```

## 🔍 Parámetros Disponibles

| Parámetro | Descripción | Valores |
|-----------|-------------|---------|
| `-Lista` | Muestra wallets con formato elegante | - |
| `-Balance` | Consulta saldos | Requiere -Red |
| `-Red` | Especifica red | mainnet/testnet/devnet/all |
| `-Export` | Exporta wallets a JSON | - |

## 💡 Tips de Uso

1. **Sin parámetros** = Menú interactivo
2. **-Lista** = Vista rápida de wallets
3. **-Balance -Red all** = Resumen completo de fondos
4. **-Export** = Respaldo de configuración

## 🚨 Notas Importantes

- El script detecta automáticamente la wallet activa (🎯)
- Los saldos se muestran con conversión USD aproximada
- La exportación incluye metadata del sistema
- Compatible con sui CLI v1.57.0+

---
*Ejemplos actualizados: $(Get-Date -Format "yyyy-MM-dd HH:mm")*