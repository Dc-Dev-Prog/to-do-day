# 💰 Calculadora de Costos de Despliegue

El script `calcular-costo-despliegue.ps1` proporciona estimaciones precisas de costos para operaciones en la blockchain Sui, incluyendo despliegues y actualizaciones.

## 📋 Tabla de Contenidos

- [Características Principales](#características-principales)
- [Modos de Cálculo](#modos-de-cálculo)
- [Uso Básico](#uso-básico)
- [Ejemplos Detallados](#ejemplos-detallados)
- [Interpretando los Resultados](#interpretando-los-resultados)
- [Casos de Uso](#casos-de-uso)

---

## Características Principales

### Cálculos Precisos Multi-Red
- **Testnet**: Costos de desarrollo y pruebas
- **Mainnet**: Costos reales de producción  
- **Devnet**: Verificación de gas (gratuito)

### Conversión Automática a USD
- Obtiene precio actual de SUI desde CoinGecko
- Convierte automáticamente todos los costos
- Muestra tanto SUI como USD para planificación financiera

### Verificación de Balance
- Compara costos estimados con balance actual
- Advierte si el balance es insuficiente
- Proporciona recomendaciones específicas por red

### Múltiples Modos de Análisis
- **Ambos**: Despliegue + actualización
- **Solo Despliegue**: Costo de contrato nuevo
- **Solo Actualización**: Costo de upgrade existente

---

## Modos de Cálculo

| Modo | Descripción | Uso Recomendado |
|------|-------------|-----------------|
| `ambos` | Calcula despliegue y actualización | Planificación completa de proyecto |
| `solo-despliegue` | Solo costo de nuevo contrato | Primer despliegue o contrato inmutable |
| `solo-actualizacion` | Solo costo de upgrade | Actualizar contrato existente |

---

## Uso Básico

### Cálculo Completo (Recomendado)
```powershell
.\.script\calcular-costo-despliegue.ps1 ambos
```

### Cálculos Específicos
```powershell
# Solo despliegue nuevo
.\.script\calcular-costo-despliegue.ps1 solo-despliegue

# Solo actualización
.\.script\calcular-costo-despliegue.ps1 solo-actualizacion
```

---

## Ejemplos Detallados

### Ejemplo 1: Cálculo Completo en Testnet

```powershell
PS> .\.script\calcular-costo-despliegue.ps1 ambos

💰 CALCULADORA DE COSTOS SUI
============================

🌐 Red actual: testnet
📦 Proyecto: to_do_day

💱 PRECIO ACTUAL DE SUI
🔍 Obteniendo precio desde CoinGecko...
💰 Precio SUI: $1.65 USD

📊 ESTIMACIONES DE COSTO - TESTNET:

🚀 DESPLIEGUE INICIAL:
   ⛽ Gas estimado: ~10,000,000 unidades
   💰 Costo en SUI: ~0.01 SUI
   💵 Costo en USD: ~$0.017

🔄 ACTUALIZACIÓN:
   ⛽ Gas estimado: ~8,000,000 unidades  
   💰 Costo en SUI: ~0.008 SUI
   💵 Costo en USD: ~$0.013

📈 TOTALES:
   💰 Total SUI: ~0.018 SUI
   💵 Total USD: ~$0.030

💼 BALANCE ACTUAL:
   💰 Tu balance: 1.77 SUI
   ✅ Balance suficiente para ambas operaciones

💡 RECOMENDACIONES:
   ✅ Tienes suficiente SUI en testnet
   💡 Los costos en testnet son muy bajos
   🔄 Usa el faucet si necesitas más: https://faucet.sui.io/
```

### Ejemplo 2: Cálculo de Despliegue en Mainnet

```powershell
PS> .\.script\calcular-costo-despliegue.ps1 solo-despliegue

💰 CALCULADORA DE COSTOS SUI
============================

🌐 Red actual: mainnet
📦 Proyecto: empresa_system

💱 PRECIO ACTUAL DE SUI
💰 Precio SUI: $1.65 USD

📊 ESTIMACIONES DE COSTO - MAINNET:

🚀 DESPLIEGUE INICIAL:
   ⛽ Gas estimado: ~250,000,000 unidades
   💰 Costo en SUI: ~0.39 SUI
   💵 Costo en USD: ~$0.64

💼 BALANCE ACTUAL:
   💰 Tu balance: 2.50 SUI
   ✅ Balance suficiente para despliegue

💡 RECOMENDACIONES:
   ✅ Balance suficiente para mainnet
   💰 Los costos en mainnet son significativos
   🎯 Considera probar en testnet primero
   
⚠️ IMPORTANTE - MAINNET:
   💸 Usarás SUI real ($0.64 USD aproximadamente)
   🔒 Asegúrate de haber probado en testnet
   💡 Ten margen extra por variaciones de gas
```

### Ejemplo 3: Balance Insuficiente

```powershell
PS> .\.script\calcular-costo-despliegue.ps1 ambos

💰 CALCULADORA DE COSTOS SUI
============================

🌐 Red actual: mainnet
📦 Proyecto: mi_proyecto

💱 PRECIO ACTUAL DE SUI
💰 Precio SUI: $1.65 USD

📊 ESTIMACIONES DE COSTO - MAINNET:

🚀 DESPLIEGUE INICIAL:
   💰 Costo en SUI: ~0.39 SUI
   💵 Costo en USD: ~$0.64

🔄 ACTUALIZACIÓN:
   💰 Costo en SUI: ~0.30 SUI
   💵 Costo en USD: ~$0.50

📈 TOTALES:
   💰 Total SUI: ~0.69 SUI
   💵 Total USD: ~$1.14

💼 BALANCE ACTUAL:
   💰 Tu balance: 0.50 SUI
   ❌ Balance insuficiente

⚠️ BALANCE INSUFICIENTE:
   💰 Necesitas al menos: 0.69 SUI
   📉 Te faltan: 0.19 SUI (~$0.31 USD)
   
🔧 OPCIONES:
   💰 Compra más SUI en un exchange
   🔄 Transfiere desde otra wallet
   🧪 Usa testnet para desarrollo (casi gratuito)
```

---

## Interpretando los Resultados

### Sección de Precios
- **Precio SUI**: Precio actual obtenido de CoinGecko API
- **Actualización**: Se actualiza en cada ejecución del script

### Estimaciones de Gas

#### Testnet/Devnet
- **Despliegue**: ~10,000,000 unidades de gas
- **Actualización**: ~8,000,000 unidades de gas
- **Costo**: Muy bajo, ideal para desarrollo

#### Mainnet  
- **Despliegue**: ~250,000,000 unidades de gas
- **Actualización**: ~200,000,000 unidades de gas
- **Costo**: Significativo, requiere planificación

### Verificación de Balance
- ✅ **Suficiente**: Puedes proceder con las operaciones
- ❌ **Insuficiente**: Necesitas más SUI antes de continuar
- ⚠️ **Justo**: Tienes suficiente pero sin mucho margen

---

## Casos de Uso Específicos

### Planificación de Proyecto Nuevo
```powershell
# Calcular costo total del proyecto
.\.script\calcular-costo-despliegue.ps1 ambos
```
> Para presupuestar un proyecto completo con actualizaciones

### Preparación para Mainnet
```powershell
# Verificar si tienes suficiente SUI para producción
sui client switch --env mainnet
.\.script\calcular-costo-despliegue.ps1 solo-despliegue
```
> Antes de desplegar en producción

### Desarrollo Iterativo
```powershell
# Calcular costo de actualizaciones durante desarrollo
.\.script\calcular-costo-despliegue.ps1 solo-actualizacion
```
> Para estimar costos de desarrollo continuo

### Comparación Entre Redes
```powershell
# Comparar costos entre testnet y mainnet
sui client switch --env testnet
.\.script\calcular-costo-despliegue.ps1 ambos

sui client switch --env mainnet  
.\.script\calcular-costo-despliegue.ps1 ambos
```
> Para entender diferencias de costo

---

## Integración con Otros Scripts

### Flujo Completo de Desarrollo

```powershell
# 1. Verificar paquetes existentes
.\.script\check-packages.ps1

# 2. Calcular costos según situación
.\.script\calcular-costo-despliegue.ps1 ambos

# 3a. Si es primer despliegue
.\.script\deploy.ps1

# 3b. Si es actualización
.\.script\upgrade.ps1
```

### Antes de Operaciones Costosas

```powershell
# Antes de desplegar en mainnet
sui client switch --env mainnet
.\.script\calcular-costo-despliegue.ps1 solo-despliegue
# Si hay suficiente SUI:
.\.script\deploy.ps1 -Red mainnet
```

### Planificación Financiera

```powershell
# Calcular presupuesto para múltiples actualizaciones
.\.script\calcular-costo-despliegue.ps1 solo-actualizacion
# Multiplicar resultado por número de actualizaciones planeadas
```

---

## Factores que Afectan los Costos

### Complejidad del Contrato
- **Contratos Simples**: Costos base estimados
- **Contratos Complejos**: Pueden requerir 20-50% más gas
- **Múltiples Módulos**: Incrementan significativamente el costo

### Condiciones de Red
- **Congestión**: Puede aumentar costos en mainnet
- **Horarios**: Costos pueden variar según uso de la red
- **Época**: Los precios de SUI fluctúan

### Tipo de Operación
- **Primer Despliegue**: Más costoso (crear objetos nuevos)
- **Actualización**: Menos costoso (reutiliza estructuras)
- **Despliegue Inmutable**: Ligeramente menos costoso

---

## Configuraciones Avanzadas

### Personalizar Estimaciones de Gas

El script usa valores conservadores. Para contratos específicos:

```powershell
# Para contratos muy complejos, considera:
# - Mainnet despliegue: hasta 400,000,000 unidades
# - Mainnet actualización: hasta 350,000,000 unidades

# Para contratos simples:  
# - Mainnet despliegue: desde 150,000,000 unidades
# - Mainnet actualización: desde 100,000,000 unidades
```

### Monitoreo de Precios

```powershell
# Ejecutar regularmente para trackear cambios de precio
.\.script\calcular-costo-despliegue.ps1 ambos > costo-$(Get-Date -Format "yyyy-MM-dd").txt
```

---

## Solución de Problemas

### Error: "No se puede obtener precio de SUI"

**Causa**: Problema de conectividad con CoinGecko API

**Soluciones**:
- Verificar conexión a internet
- Intentar más tarde si la API está sobrecargada
- El script continuará con cálculos sin conversión USD

### Error: "No se encuentra Move.toml"

**Causa**: Script no ejecutado desde directorio del proyecto

**Solución**:
```powershell
# Navegar al directorio del proyecto
cd C:\ruta\a\tu\proyecto
.\.script\calcular-costo-despliegue.ps1 ambos
```

### Balance Mostrado Incorrectamente

**Causa**: Red incorrecta o problemas de sincronización

**Soluciones**:
- Verificar red activa: `sui client active-env`
- Actualizar balance: `sui client balance`
- Cambiar de red si es necesario: `sui client switch --env <red>`

---

## Mejores Prácticas

### Para Desarrollo
1. **Usa Testnet**: Costos mínimos para experimentación
2. **Calcula Regularmente**: Los precios de SUI cambian
3. **Planifica Margen**: Siempre ten 20% extra de SUI

### Para Producción
1. **Calcula Antes**: Nunca despliegues sin verificar costos
2. **Testnet Primero**: Prueba completamente antes de mainnet
3. **Balance Generoso**: Ten más SUI del estimado

### Gestión Financiera
1. **Trackea Costos**: Guarda logs de estimaciones
2. **Presupuesta**: Planifica costos por proyecto
3. **Monitorea Precios**: SUI puede fluctuar significativamente

---

## Scripts Relacionados

- **[🚀 deploy.ps1](deploy-script.md)** - Para ejecutar despliegues calculados
- **[🔄 upgrade.ps1](upgrade-script.md)** - Para ejecutar actualizaciones calculadas
- **[📦 check-packages.ps1](check-packages-script.md)** - Para verificar paquetes existentes

---

¡Con esta calculadora siempre sabrás exactamente cuánto costará tu próximo despliegue! 💰