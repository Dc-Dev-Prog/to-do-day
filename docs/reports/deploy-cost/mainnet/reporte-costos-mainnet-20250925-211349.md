# 💰 Reporte de Costos SUI - MAINNET 💎

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | 2025-09-25 21:13:49 |
| **🌐 Red** | MAINNET |
| **👤 Wallet** | `0x7c1f3953f5b1e64cb63b797a168dafdc3c996bc058322f89701f2e2672e074cd` |
| **📦 Proyecto** | Intro |
| **💰 Balance Actual** | 0.02 SUI |
| **📊 Estado Balance** | ⚠️ Insuficiente |

## 💸 Análisis de Costos

### 🔨 Despliegue Inicial

| Concepto | SUI | USD (@ 4) |
|----------|-----|-----|
| **Cómputo** | 0.000495 | 0.0020 |
| **Almacenamiento** | 0.021432 | 0.0857 |
| **📦 Total Estimado** | **0.054818** | **0.2193** |
| **✅ Último Real** | 0.020949 | 0.0838 |

### 🔄 Actualización de Contratos

| Concepto | SUI | USD (@ 4) |
|----------|-----|-----|
| **🔄 Actualización Estimada** | **0.012608** | **0.0504** |

### 💡 Recomendaciones de Presupuesto

| Concepto | Valor | Estado |
|----------|-------|--------|
| **💡 Presupuesto Recomendado** | 0.1 SUI | - |
| **💰 Tu Balance Actual** | 0.02 SUI | - |
| **📊 Diferencia** | 0.0800 SUI | ⚠️ Necesitas más |

## ⚠️ Fondos Insuficientes

❌ **Necesitas más SUI** para el despliegue en **MAINNET**.

### 💳 Cómo Obtener SUI:1. **🏪 Exchanges**: Binance, Coinbase, KuCoin, etc.
2. **🔄 Bridge**: Desde otras blockchains
3. **💱 DEX**: SuiSwap, Turbos Finance
4. **💰 Mínimo necesario**: 0.0800 SUI adicionales

## 🛠️ Herramientas Disponibles

### 💰 Cálculo de Costos
```powershell
# Calcular costos en esta red
.\.script\calcular-costo-despliegue-v2.ps1 -Red mainnet

# Solo costo de despliegue
.\.script\calcular-costo-despliegue-v2.ps1 -Red mainnet -Tipo solo-despliegue

# Solo costo de actualización
.\.script\calcular-costo-despliegue-v2.ps1 -Red mainnet -Tipo solo-actualizacion

# Con detalles técnicos
.\.script\calcular-costo-despliegue-v2.ps1 -Red mainnet -MostrarDetalle

# Precio personalizado de SUI
.\.script\calcular-costo-despliegue-v2.ps1 -Red mainnet -PrecioSUI 5.0
```

### 🚀 Despliegue y Gestión
```bash
# Desplegar contrato
.\.script\deploy.ps1

# Verificar paquetes
.\.script\check-packages.ps1 -Red mainnet

# Verificar balances
.\.script\check-balance.ps1 -SoloMainnet

# Actualizar contrato existente
.\.script\upgrade.ps1
```

### 🌐 Cambio de Redes
```bash
# Cambiar a esta red
sui client switch --env mainnet

# Listar redes disponibles
sui client envs

# Ver red actual
sui client active-env
```

## 📊 Información Técnica

| Campo | Valor |
|-------|-------|
| **🏷️ Factor de Seguridad** | 2.5x |
| **📅 Datos Basados En** | Despliegue Real 25/09/2025 |
| **🔗 TX Real** | HHcAMN7czxSVJMeMkpzfoTKuDSPF9ZW2D24ETh253uSq |
| **⚡ Precisión** | Datos reales de mainnet |

## 🔗 Enlaces Útiles

- 🌐 **SUI Explorer**: [https://suiexplorer.com/?network=mainnet](https://suiexplorer.com/?network=mainnet)
- 👤 **Tu Wallet**: [https://suiexplorer.com/address/=mainnet](https://suiexplorer.com/address/=mainnet)
- 📚 **Documentación**: [https://docs.sui.io](https://docs.sui.io)
- 💰 **Precios SUI**: [https://coinmarketcap.com/currencies/sui/](https://coinmarketcap.com/currencies/sui/)

## 📄 Información del Reporte

| Campo | Valor |
|-------|-------|
| **🏷️ Versión del Script** | 2.0 (Simplificado) |
| **📅 Generado** | 2025-09-25 21:13:49 |
| **🌐 Red Específica** | MAINNET |
| **💰 Precio SUI** | 4 USD |
| **📊 Tipo de Cálculo** | ambos |

---

*Creado con ❤️ por el equipo de desarrollo de **Dc Studio***
