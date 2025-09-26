# 🚀 Reporte de Despliegue SUI - TESTNET ❌

## ℹ️ Información General

| Campo | Valor |
|-------|-------|
| **📅 Fecha** | 2025-09-25 21:12:15 |
| **🌐 Red** | TESTNET |
| **👤 Wallet** | `0x7c1f3953f5b1e64cb63b797a168dafdc3c996bc058322f89701f2e2672e074cd` |
| **📦 Proyecto** | Intro |
| **📊 Estado** | ❌ Error |

## 🚫 Error en Despliegue

❌ **No se pudo completar el despliegue** en **TESTNET**.

### 💡 Mensaje de Error:
```
Error en despliegue: Committing lock file

Caused by:
    0: failed to persist temporary file: Access is denied. (os error 5)
    1: Access is denied. (os error 5)
```

### 🎯 Posibles Soluciones:
1. **Verificar Balance**: `.\.script\check-balance.ps1 -Red testnet`
2. **Calcular Costos**: `.\.script\calcular-costo-despliegue.ps1 -Red testnet`
3. **Fondear Cuenta**: `sui client faucet`
4. **Revisar Código**: Verificar errores de compilación

## 🛠️ Herramientas Disponibles

### 🚀 Interacción con Contratos
```bash
# Llamar función del contrato
sui client call --package  --module  --function [FUNCION] --args "[ARG1]"

# Verificar objetos del contrato  
sui client object 



# Ver todos los objetos de la wallet
sui client objects
```

### 📊 Verificación y Monitoreo
```powershell
# Verificar balance actual
.\.script\check-balance.ps1 -Red testnet

# Verificar paquetes desplegados
.\.script\check-packages.ps1 -Red testnet

# Calcular costos de nuevos despliegues
.\.script\calcular-costo-despliegue.ps1 -Red testnet


```

### 🌐 Gestión de Redes
```bash
# Cambiar a esta red
sui client switch --env testnet

# Ver red actual  
sui client active-env

# Listar todas las redes
sui client envs
```

## 🔗 Enlaces Útiles

- 🌐 **SUI Explorer**: [https://suiexplorer.com/?network=testnet](https://suiexplorer.com/?network=testnet)
- 🔗 **Transaction**: [https://suiexplorer.com/txblock/?network=testnet](https://suiexplorer.com/txblock/?network=testnet)
- 📦 **Package**: [https://suiexplorer.com/object/?network=testnet](https://suiexplorer.com/object/?network=testnet)
- 👤 **Tu Wallet**: [https://suiexplorer.com/address/=testnet](https://suiexplorer.com/address/=testnet)


## 📄 Información del Reporte

| Campo | Valor |
|-------|-------|
| **🏷️ Versión del Script** | 4.0 (Simplificado) |
| **📅 Generado** | 2025-09-25 21:12:15 |
| **🌐 Red Específica** | TESTNET |
| **📊 Tipo** | Despliegue Real |
| **💰 Gas Budget Usado** | 100000000 MIST |

---

*Creado con ❤️ por el equipo de desarrollo de **Dc Studio***
