# 🚀 Reporte de Despliegue SUI - MAINNET 💎

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | 2025-09-25 21:07:30 |
| **🌐 Red** | MAINNET |
| **👤 Wallet** | `0x7c1f3953f5b1e64cb63b797a168dafdc3c996bc058322f89701f2e2672e074cd` |
| **📦 Proyecto** | Intro |
| **📊 Estado** | 📋 DEMO |
| **💰 Costo Total** | 0.020948880 SUI (~0.0660 USD) |

## 📦 Información del Contrato

### 🔗 Identificadores Críticos

| Campo | Valor | Descripción |
|-------|-------|-------------|
| **🔗 Transaction Digest** | `HHcAMN7czxSVJMeMkpzfoTKuDSPF9ZW2D24ETh253uSq` | Hash único de la transacción |
| **📦 Package ID** | `0x56899bfa963c427d3d3e7a884ac0236afc1886251f8e15275264c07af47cc3ec` | ID del contrato desplegado |
| **🔑 Upgrade Cap ID** | `0xaab054e1f0393cfc79a44de7583e81807e91ee45fd10762d79ca01dd6feb200e` | Capacidad de actualización |

### 💸 Análisis Financiero

| Concepto | MIST | SUI | USD (@ 3.15) |
|----------|------|-----|---------------|
| **Storage Cost** | 21432000 | 0.021432000 | 0.0675 |
| **Computation Cost** | 495000 | 0.000495000 | 0.0016 |
| **Storage Rebate** | -978120 | -0.000978120 | -0.0031 |
| **💰 Total Pagado** | **20948880** | **0.020948880** | **0.0660** |

### 📊 Balance del Wallet

| Campo | Valor |
|-------|-------|
| **💼 Balance Antes** | 0.050000000 SUI |
| **💰 Balance Después** | 0.029051120 SUI |
| **💸 Diferencia** | 0.020948880 SUI |

## 📋 Modo DEMO - Información Importante

⚠️ **Este reporte usa datos de demostración** basados en un despliegue real.

### 💡 ¿Por qué modo DEMO?
- Balance insuficiente en mainnet para despliegue real
- Los datos mostrados son de un despliegue exitoso del 25/09/2025
- Útil para planificación y estimaciones

### 🎯 Para Despliegue Real:
1. **Fondear Cuenta**: Añade al menos 0.1 SUI a mainnet
2. **Ejecutar Real**: `.\.script\deploy.ps1 -Red mainnet`
3. **Verificar Costos**: `.\.script\calcular-costo-despliegue.ps1 -Red mainnet`

## 🛠️ Herramientas Disponibles

### 🚀 Interacción con Contratos
```bash
# Llamar función del contrato
sui client call --package 0x56899bfa963c427d3d3e7a884ac0236afc1886251f8e15275264c07af47cc3ec --module  --function [FUNCION] --args "[ARG1]"

# Verificar objetos del contrato  
sui client object 0x56899bfa963c427d3d3e7a884ac0236afc1886251f8e15275264c07af47cc3ec

# Verificar UpgradeCap
sui client object 0xaab054e1f0393cfc79a44de7583e81807e91ee45fd10762d79ca01dd6feb200e

# Ver todos los objetos de la wallet
sui client objects
```

### 📊 Verificación y Monitoreo
```powershell
# Verificar balance actual
.\.script\check-balance.ps1 -Red mainnet

# Verificar paquetes desplegados
.\.script\check-packages.ps1 -Red mainnet

# Calcular costos de nuevos despliegues
.\.script\calcular-costo-despliegue.ps1 -Red mainnet

# Actualizar contrato existente
.\.script\upgrade.ps1
```

### 🌐 Gestión de Redes
```bash
# Cambiar a esta red
sui client switch --env mainnet

# Ver red actual  
sui client active-env

# Listar todas las redes
sui client envs
```

## 🔗 Enlaces Útiles

- 🌐 **SUI Explorer**: [https://suiexplorer.com/?network=mainnet](https://suiexplorer.com/?network=mainnet)
- 🔗 **Transaction**: [https://suiexplorer.com/txblock/HHcAMN7czxSVJMeMkpzfoTKuDSPF9ZW2D24ETh253uSq?network=mainnet](https://suiexplorer.com/txblock/HHcAMN7czxSVJMeMkpzfoTKuDSPF9ZW2D24ETh253uSq?network=mainnet)
- 📦 **Package**: [https://suiexplorer.com/object/0x56899bfa963c427d3d3e7a884ac0236afc1886251f8e15275264c07af47cc3ec?network=mainnet](https://suiexplorer.com/object/0x56899bfa963c427d3d3e7a884ac0236afc1886251f8e15275264c07af47cc3ec?network=mainnet)
- 👤 **Tu Wallet**: [https://suiexplorer.com/address/=mainnet](https://suiexplorer.com/address/=mainnet)
- 🔑 **UpgradeCap**: [https://suiexplorer.com/object/0xaab054e1f0393cfc79a44de7583e81807e91ee45fd10762d79ca01dd6feb200e?network=mainnet](https://suiexplorer.com/object/0xaab054e1f0393cfc79a44de7583e81807e91ee45fd10762d79ca01dd6feb200e?network=mainnet)

## 📄 Información del Reporte

| Campo | Valor |
|-------|-------|
| **🏷️ Versión del Script** | 4.0 (Simplificado) |
| **📅 Generado** | 2025-09-25 21:07:30 |
| **🌐 Red Específica** | MAINNET |
| **📊 Tipo** | Datos Demo |
| **💰 Gas Budget Usado** | 100000000 MIST |

---

*Creado con ❤️ por el equipo de desarrollo de **Dc Studio***
