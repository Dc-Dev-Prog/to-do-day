📚[Readme](../../README.md) \ 📚[Docs](../../docs/) \ 📜[Scripts](../script/) \ 💰**check-balance-script** \

# 💰 Verificador de Saldos Multi-Red

El script `check-balance.ps1` te permite revisar tus saldos de SUI en las tres redes principales (testnet, mainnet, devnet) de forma automática y centralizada.

## 📋 Tabla de Contenidos

- [🎯 Características Principales](#-características-principales)
- [🛠️ Parámetros del Script](#️-parámetros-del-script)
- [🚀 Uso Básico](#-uso-básico)
- [📊 Interpretando los Resultados](#-interpretando-los-resultados)
- [💡 Ejemplos Detallados](#-ejemplos-detallados)
- [🔧 Casos de Uso](#-casos-de-uso)

[🔝](#-verificador-de-saldos-multi-red)

---

## 🎯 Características Principales

### ✅ **Verificación Automática Multi-Red**
- **Testnet**: Ideal para desarrollo y pruebas
- **Mainnet**: Red principal de producción
- **Devnet**: Red de desarrollo temprano
- **Cambio automático**: Se conecta a cada red automáticamente

### 💱 **Conversión de Moneda en Tiempo Real**
- **Precio actual**: Obtiene el precio de SUI desde CoinGecko
- **Conversión USD**: Muestra el valor equivalente en dólares
- **Totales calculados**: Suma todos los saldos y valores

### 🎨 **Interfaz Visual Intuitiva**
- **Estados coloreados**: Verde (suficiente), amarillo (bajo), rojo (vacío)
- **Emojis descriptivos**: Facilita la lectura rápida
- **Tabla resumen**: Comparación clara de todas las redes
- **Recomendaciones**: Sugerencias basadas en tus saldos

### 🔄 **Gestión Inteligente de Red**
- **Preserva configuración**: Restaura tu red original al terminar
- **Manejo de errores**: Continúa si una red no está disponible
- **Detección automática**: Identifica tu wallet activo

---

## 🛠️ Parámetros del Script

| Parámetro | Tipo | Descripción | Requerido |
|-----------|------|-------------|-----------|
| `-Detallado` | Switch | Muestra información adicional y debug | No |
| `-SoloSui` | Switch | Solo muestra valores en SUI (sin USD) | No |
| `-Address` | String | Dirección específica a verificar | No |

---

## 🚀 Uso Básico

### Verificación Estándar

```powershell
.\.script\check-balance.ps1
```

**Salida esperada:**
```
💰 VERIFICADOR DE SALDOS MULTI-RED SUI
=====================================

🔄 Red original: testnet
📍 Dirección: 0x1234...abcd
🌐 Obteniendo precio actual de SUI...
💱 Precio SUI: 1.2340 USD

🔍 REVISANDO SALDOS EN TODAS LAS REDES...

🌐 Verificando testnet...
   💰 Balance: 0.500000000 SUI
   💵 Valor: 0.62 USD
   📊 Estado: ✅ Suficiente

🌐 Verificando mainnet...
   💰 Balance: 2.100000000 SUI
   💵 Valor: 2.59 USD
   📊 Estado: ✅ Suficiente

🌐 Verificando devnet...
   💰 Balance: 0.000000000 SUI
   💵 Valor: N/A
   📊 Estado: ❌ Vacío
```

### Verificación de Dirección Específica

```powershell
.\.script\check-balance.ps1 -Address 0x1234567890abcdef
```

### Verificación Solo SUI (Sin Conversión USD)

```powershell
.\.script\check-balance.ps1 -SoloSui
```

---

## 📊 Interpretando los Resultados

### Estados de Balance

| Estado | Icono | Descripción | Recomendación |
|--------|-------|-------------|---------------|
| **Suficiente** | ✅ | > 0.1 SUI | Listo para despliegues |
| **Bajo** | ⚠️ | 0.001 - 0.1 SUI | Considera fondear más |
| **Vacío** | ❌ | 0 SUI | Necesita fondeo |
| **Error** | ❌ | No se pudo verificar | Revisar conectividad |

### Tabla Resumen

```
📊 RESUMEN DE SALDOS
===================
🌐 Red     💰 SUI           💵 USD      📊 Estado
------     -----------      -------     -------------
testnet    0.500000000      0.62 USD    ✅ Suficiente
mainnet    2.100000000      2.59 USD    ✅ Suficiente  
devnet     0.000000000      N/A         ❌ Vacío
```

### Totales y Estadísticas

```
💼 TOTALES:
   🪙 Total SUI: 2.600000000
   💵 Total USD: 3.21
   🌐 Redes con saldo: 2/3
```

---

## 💡 Ejemplos Detallados

### Ejemplo 1: Desarrollador Principiante

```powershell
PS> .\.script\check-balance.ps1
```

**Resultado típico:**
- ✅ **Testnet**: 0.5 SUI (fondeado desde faucet)
- ❌ **Mainnet**: 0 SUI (sin fondear)  
- ❌ **Devnet**: 0 SUI (sin usar)

**Recomendación del script:**
```
💡 RECOMENDACIONES:
   ✅ Testnet: Listo para despliegues de prueba
   
🎯 PRÓXIMOS PASOS:
   🚀 Usar: .\deploy.ps1 para desplegar contratos
   💰 Calcular: .\calcular-costo-despliegue.ps1 para estimar costos
```

### Ejemplo 2: Desarrollador Experimentado

```powershell
PS> .\.script\check-balance.ps1
```

**Resultado típico:**
- ✅ **Testnet**: 1.2 SUI (desarrollo activo)
- ✅ **Mainnet**: 5.8 SUI (proyectos en producción)
- ⚠️ **Devnet**: 0.05 SUI (pruebas ocasionales)

**Recomendación del script:**
```
💡 RECOMENDACIONES:
   ✅ Excelente: Tienes saldo suficiente para múltiples despliegues

🎯 PRÓXIMOS PASOS:  
   🚀 Usar: .\deploy.ps1 para desplegar contratos
   💰 Calcular: .\calcular-costo-despliegue.ps1 para estimar costos
```

### Ejemplo 3: Cuenta Sin Fondear

```powershell
PS> .\.script\check-balance.ps1
```

**Resultado típico:**
- ❌ **Testnet**: 0 SUI 
- ❌ **Mainnet**: 0 SUI
- ❌ **Devnet**: 0 SUI

**Recomendación del script:**
```
💡 RECOMENDACIONES:
   🧪 Testnet: Fondea tu cuenta en https://faucet.sui.io/
   ⚠️ Sin saldos: Necesitas fondear al menos testnet para comenzar

🎯 PRÓXIMOS PASOS:
   1️⃣ Fondear testnet en https://faucet.sui.io/
   2️⃣ Ejecutar nuevamente este script para verificar
```

---

## 🔧 Casos de Uso

### 🆕 **Antes de Desplegar**

Siempre verifica tus saldos antes de iniciar un despliegue:

```powershell
# 1. Verificar saldos
.\.script\check-balance.ps1

# 2. Si hay saldo suficiente, proceder
.\.script\deploy.ps1
```

### 💰 **Planificación Financiera**

Combina con la calculadora de costos para planificar:

```powershell
# 1. Ver saldos actuales  
.\.script\check-balance.ps1

# 2. Calcular costos estimados
.\.script\calcular-costo-despliegue.ps1 ambos

# 3. Decidir en qué red desplegar
```

### 🔄 **Monitoreo Regular**

Para desarrolladores activos:

```powershell
# Verificación semanal
.\.script\check-balance.ps1

# Si necesitas fondear testnet
# Ir a: https://faucet.sui.io/
```

### 🌐 **Migración entre Redes**

Antes de mover a mainnet:

```powershell
# 1. Verificar saldos
.\.script\check-balance.ps1

# 2. Si mainnet tiene poco saldo, transferir desde exchange
# 3. Verificar nuevamente
.\.script\check-balance.ps1

# 4. Proceder con despliegue en mainnet
.\.script\deploy.ps1 -Red mainnet
```

---

## 🎯 Scripts Relacionados

- **[🚀 deploy.ps1](deploy-script.md)** - Para desplegar después de verificar saldo
- **[🔄 upgrade.ps1](upgrade-script.md)** - Para actualizar contratos existentes
- **[💰 calcular-costo-despliegue.ps1](cost-calculator-script.md)** - Para estimar costos antes de usar saldo
- **[📦 check-packages.ps1](check-packages-script.md)** - Para ver tus contratos desplegados

---

## 🛠️ Solución de Problemas

### Error: "No se pudo obtener la dirección del wallet"

```bash
# Configurar wallet si es necesario
sui client active-address

# Si no tienes wallet, crear uno
sui client new-address ed25519
```

### Error de conectividad con CoinGecko

El script continúa funcionando sin conversión USD:
- ✅ Los saldos en SUI se muestran normalmente
- ⚠️ Los valores USD aparecen como "N/A"
- 💡 Esto no afecta la funcionalidad principal

### Red no disponible

Si una red específica no responde:
- ✅ Las otras redes se verifican normalmente
- ❌ La red problemática muestra "Error"
- 🔄 El script continúa con las redes disponibles

---

¡Con este script nunca perderás el control de tus saldos SUI en todas las redes! 💰

---

Creado con ❤️ por el equipo de desarrollo de [Dc Studio]()