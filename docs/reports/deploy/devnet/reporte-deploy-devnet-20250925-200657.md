# 🚀 Reporte de Despliegue SUI - DEVNET 🔧

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | 2025-09-25 20:06:57 |
| **🌐 Red** | DEVNET |
| **👤 Wallet** | `0x7c1f3953f5b1e64cb63b797a168dafdc3c996bc058322f89701f2e2672e074cd` |
| **📦 Proyecto** | Intro |
| **📊 Estado** | ✅ REAL |
| **💰 Costo Total** | 0.021453880 SUI (~0.0676 USD) |

## 📦 Información del Contrato

### 🔗 Identificadores Críticos

| Campo | Valor | Descripción |
|-------|-------|-------------|
| **🔗 Transaction Digest** | `9J26X3iC5PTaWytbhEx9DZn726RogGJUPUEmSjaxCYis` | Hash único de la transacción |
| **📦 Package ID** | `0xad5a5742c1827f405d8d7138849f3ee66a62384e274dc1589c9e99085867e73c` | ID del contrato desplegado |
| **🔑 Upgrade Cap ID** | `0x9bd3aad81bc8c755fae386e82a013e9ccceca3cda58f7ac1cf9f33e5413b3ffd` | Capacidad de actualización |

### 💸 Análisis Financiero

| Concepto | MIST | SUI | USD (@ 3.15) |
|----------|------|-----|---------------|
| **Storage Cost** | 21432000 | 0.021432000 | 0.0675 |
| **Computation Cost** | 1000000 | 0.001000000 | 0.0032 |
| **Storage Rebate** | -978120 | -0.000978120 | -0.0031 |
| **💰 Total Pagado** | **21453880** | **0.021453880** | **0.0676** |

### 📊 Balance del Wallet

| Campo | Valor |
|-------|-------|
| **💼 Balance Antes** | 10.000000000 SUI |
| **💰 Balance Después** | 9.97 SUI |
| **💸 Diferencia** | 0.030000000 SUI |

## 🎉 Despliegue Exitoso

✅ **Contrato desplegado correctamente** en **DEVNET**.

### 🚀 Próximos Pasos:
1. **Interactuar**: Llamar funciones del contrato
2. **Verificar**: Ver estado en el explorer
3. **Actualizar**: Usar UpgradeCap para updates

## 🛠️ Herramientas Disponibles

### 🚀 Interacción con Contratos
```bash
# Llamar función del contrato
sui client call --package 0xad5a5742c1827f405d8d7138849f3ee66a62384e274dc1589c9e99085867e73c --module  --function [FUNCION] --args "[ARG1]"

# Verificar objetos del contrato  
sui client object 0xad5a5742c1827f405d8d7138849f3ee66a62384e274dc1589c9e99085867e73c

# Verificar UpgradeCap
sui client object 0x9bd3aad81bc8c755fae386e82a013e9ccceca3cda58f7ac1cf9f33e5413b3ffd

# Ver todos los objetos de la wallet
sui client objects
```

### 📊 Verificación y Monitoreo
```powershell
# Verificar balance actual
.\.script\check-balance.ps1 -Red devnet

# Verificar paquetes desplegados
.\.script\check-packages.ps1 -Red devnet

# Calcular costos de nuevos despliegues
.\.script\calcular-costo-despliegue.ps1 -Red devnet

# Actualizar contrato existente
.\.script\upgrade.ps1
```

### 🌐 Gestión de Redes
```bash
# Cambiar a esta red
sui client switch --env devnet

# Ver red actual  
sui client active-env

# Listar todas las redes
sui client envs
```

## 🔗 Enlaces Útiles

- 🌐 **SUI Explorer**: [https://suiexplorer.com/?network=devnet](https://suiexplorer.com/?network=devnet)
- 🔗 **Transaction**: [https://suiexplorer.com/txblock/9J26X3iC5PTaWytbhEx9DZn726RogGJUPUEmSjaxCYis?network=devnet](https://suiexplorer.com/txblock/9J26X3iC5PTaWytbhEx9DZn726RogGJUPUEmSjaxCYis?network=devnet)
- 📦 **Package**: [https://suiexplorer.com/object/0xad5a5742c1827f405d8d7138849f3ee66a62384e274dc1589c9e99085867e73c?network=devnet](https://suiexplorer.com/object/0xad5a5742c1827f405d8d7138849f3ee66a62384e274dc1589c9e99085867e73c?network=devnet)
- 👤 **Tu Wallet**: [https://suiexplorer.com/address/=devnet](https://suiexplorer.com/address/=devnet)
- 🔑 **UpgradeCap**: [https://suiexplorer.com/object/0x9bd3aad81bc8c755fae386e82a013e9ccceca3cda58f7ac1cf9f33e5413b3ffd?network=devnet](https://suiexplorer.com/object/0x9bd3aad81bc8c755fae386e82a013e9ccceca3cda58f7ac1cf9f33e5413b3ffd?network=devnet)

## 📄 Información del Reporte

| Campo | Valor |
|-------|-------|
| **🏷️ Versión del Script** | 4.0 (Simplificado) |
| **📅 Generado** | 2025-09-25 20:06:57 |
| **🌐 Red Específica** | DEVNET |
| **📊 Tipo** | Despliegue Real |
| **💰 Gas Budget Usado** | 100000000 MIST |

---

*Creado con ❤️ por el equipo de desarrollo de **Dc Studio***
