# 💰 Reporte de Costos SUI - DEVNET 🧪

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | 2025-09-25 21:09:54 |
| **🌐 Red** | DEVNET |
| **👤 Wallet** | `0x7c1f3953f5b1e64cb63b797a168dafdc3c996bc058322f89701f2e2672e074cd` |
| **📦 Proyecto** | Intro |
| **💰 Balance Actual** | 9.97 SUI |
| **📊 Estado Balance** | ✅ Suficiente |

## 💸 Análisis de Costos

### 🔨 Despliegue Inicial

| Concepto | SUI | USD (@ 4) |
|----------|-----|-----|
| **Cómputo** | 0.000495 | 0.0020 |
| **Almacenamiento** | 0.021432 | 0.0857 |
| **📦 Total Estimado** | **0.043854** | **0.1754** |
| **✅ Último Real** | 0.020949 | 0.0838 |

### 🔄 Actualización de Contratos

| Concepto | SUI | USD (@ 4) |
|----------|-----|-----|
| **🔄 Actualización Estimada** | **0.010086** | **0.0403** |

### 💡 Recomendaciones de Presupuesto

| Concepto | Valor | Estado |
|----------|-------|--------|
| **💡 Presupuesto Recomendado** | 0.1 SUI | - |
| **💰 Tu Balance Actual** | 9.97 SUI | - |
| **📊 Diferencia** | -9.8700 SUI | ✅ Tienes suficiente |

## ✅ Fondos Suficientes

🎉 **Tienes suficiente SUI** para el despliegue en **DEVNET**.

### 🚀 Próximos Pasos:
1. **Compilar**: `sui move build`
2. **Desplegar**: `.\.script\deploy.ps1`
3. **Verificar**: `.\.script\check-packages.ps1 -Red devnet`

## 🛠️ Herramientas Disponibles

### 💰 Cálculo de Costos
```powershell
# Calcular costos en esta red
.\.script\calcular-costo-despliegue-v2.ps1 -Red devnet

# Solo costo de despliegue
.\.script\calcular-costo-despliegue-v2.ps1 -Red devnet -Tipo solo-despliegue

# Solo costo de actualización
.\.script\calcular-costo-despliegue-v2.ps1 -Red devnet -Tipo solo-actualizacion

# Con detalles técnicos
.\.script\calcular-costo-despliegue-v2.ps1 -Red devnet -MostrarDetalle

# Precio personalizado de SUI
.\.script\calcular-costo-despliegue-v2.ps1 -Red devnet -PrecioSUI 5.0
```

### 🚀 Despliegue y Gestión
```bash
# Desplegar contrato
.\.script\deploy.ps1

# Verificar paquetes
.\.script\check-packages.ps1 -Red devnet

# Verificar balances
.\.script\check-balance.ps1 -SoloDevnet

# Actualizar contrato existente
.\.script\upgrade.ps1
```

### 🌐 Cambio de Redes
```bash
# Cambiar a esta red
sui client switch --env devnet

# Listar redes disponibles
sui client envs

# Ver red actual
sui client active-env
```

## 📊 Información Técnica

| Campo | Valor |
|-------|-------|
| **🏷️ Factor de Seguridad** | 2x |
| **📅 Datos Basados En** | Despliegue Real 25/09/2025 |
| **🔗 TX Real** | HHcAMN7czxSVJMeMkpzfoTKuDSPF9ZW2D24ETh253uSq |
| **⚡ Precisión** | Datos reales de mainnet |

## 🔗 Enlaces Útiles

- 🌐 **SUI Explorer**: [https://suiexplorer.com/?network=devnet](https://suiexplorer.com/?network=devnet)
- 👤 **Tu Wallet**: [https://suiexplorer.com/address/=devnet](https://suiexplorer.com/address/=devnet)
- 📚 **Documentación**: [https://docs.sui.io](https://docs.sui.io)
- 💰 **Precios SUI**: [https://coinmarketcap.com/currencies/sui/](https://coinmarketcap.com/currencies/sui/)

## 📄 Información del Reporte

| Campo | Valor |
|-------|-------|
| **🏷️ Versión del Script** | 2.0 (Simplificado) |
| **📅 Generado** | 2025-09-25 21:09:54 |
| **🌐 Red Específica** | DEVNET |
| **💰 Precio SUI** | 4 USD |
| **📊 Tipo de Cálculo** | ambos |

---

*Creado con ❤️ por el equipo de desarrollo de **Dc Studio***
