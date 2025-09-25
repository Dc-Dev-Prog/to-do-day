# 🚀 Script de Despliegue Inteligente

El script `deploy.ps1` es una herramienta completa para desplegar contratos inteligentes en la blockchain Sui de manera automatizada e inteligente.

## 📋 Tabla de Contenidos

- [🎯 Características Principales](#características-principales)
- [🛠️ Parámetros del Script](#parámetros-del-script)
- [🚀 Uso Básico](#uso-básico)
- [🔧 Uso Avanzado](#uso-avanzado)
- [📖 Ejemplos Detallados](#ejemplos-detallados)
- [🐛 Solución de Problemas](#solución-de-problemas)

---

## 🎯 Características Principales

### ✅ **Detección Automática**
- **Proyecto**: Detecta automáticamente el nombre del proyecto desde `Move.toml`
- **Red Actual**: Identifica la red Sui activa (testnet, mainnet, devnet)
- **Balance**: Verifica automáticamente el balance disponible
- **Compilación**: Valida que el proyecto compile correctamente

### 🎨 **Interfaz Interactiva**
- **Selección de Red**: Menú interactivo para elegir la red de despliegue
- **Opciones de Despliegue**: Permite elegir entre contrato actualizable o inmutable
- **Confirmaciones**: Solicita confirmación antes de operaciones críticas
- **Feedback Visual**: Usa emojis y colores para mejor experiencia

### 📁 **Sistema de Archivos**
- **Tracking de Despliegues**: Guarda información del último despliegue en `ultimo-despliegue.txt`
- **Integración**: Los otros scripts pueden usar esta información automáticamente

---

## 🛠️ Parámetros del Script

| Parámetro | Tipo | Descripción | Requerido |
|-----------|------|-------------|-----------|
| `-Red` | String | Red específica (testnet, mainnet, devnet) | No |
| `-Actualizable` | Switch | Fuerza despliegue actualizable | No |
| `-Inmutable` | Switch | Fuerza despliegue inmutable | No |
| `-GasBudget` | String | Presupuesto de gas personalizado | No |

---

## 🚀 Uso Básico

### **Despliegue Automático Completo**
```powershell
.\.script\deploy.ps1
```

**¿Qué hace?**
1. 🔍 Detecta tu proyecto y red actual
2. 🎨 Te muestra un menú para seleccionar red
3. 💰 Verifica tu balance
4. 🏗️ Te pregunta si quieres despliegue actualizable
5. 🚀 Despliega el contrato
6. 📄 Guarda la información en `ultimo-despliegue.txt`

### **Salida Típica:**
```
🚀 SCRIPT INTELIGENTE DE DESPLIEGUE SUI
=====================================

📦 Proyecto: to_do_day
🌐 Red actual: testnet

🔍 ¿En qué red quieres desplegar?
   1️⃣  Usar red actual (testnet)
   2️⃣  testnet
   3️⃣  mainnet
   4️⃣  devnet

   Selecciona una opción (1-4): 1

💰 VERIFICANDO BALANCE...
   💼 Balance actual: 1.77 SUI

🏗️ ¿Quieres que el contrato sea actualizable?
   ✅ SÍ - Podrás actualizar el código manteniendo el Package ID
   ❌ NO - El contrato será inmutable (más seguro pero no actualizable)

   ¿Desplegar como actualizable? (y/n): y

🔨 COMPILANDO PROYECTO...
✅ Compilación exitosa

📋 RESUMEN DE DESPLIEGUE:
   📦 Proyecto: to_do_day
   🌐 Red: testnet
   🔄 Tipo: Actualizable (con UpgradeCap)
   ⛽ Gas Budget: 100000000

❓ ¿Proceder con el despliegue? (y/n): y

🚀 DESPLEGANDO CONTRATO...
✅ ¡DESPLIEGUE EXITOSO!
```

---

## 🔧 Uso Avanzado

### **Especificar Red Directamente**
```powershell
# Desplegar directamente en mainnet
.\.script\deploy.ps1 -Red mainnet

# Desplegar en testnet
.\.script\deploy.ps1 -Red testnet
```

### **Forzar Tipo de Despliegue**
```powershell
# Forzar despliegue actualizable
.\.script\deploy.ps1 -Actualizable

# Forzar despliegue inmutable
.\.script\deploy.ps1 -Inmutable

# Combinar con red específica
.\.script\deploy.ps1 -Red mainnet -Actualizable
```

### **Gas Budget Personalizado**
```powershell
# Usar más gas para contratos complejos
.\.script\deploy.ps1 -GasBudget "200000000"

# Para mainnet con más margen
.\.script\deploy.ps1 -Red mainnet -GasBudget "500000000"
```

---

## 📖 Ejemplos Detallados

### **Ejemplo 1: Primer Despliegue en Testnet**
```powershell
PS> .\.script\deploy.ps1

🚀 SCRIPT INTELIGENTE DE DESPLIEGUE SUI
=====================================

📦 Proyecto: mi_proyecto
🌐 Red actual: testnet

🔍 ¿En qué red quieres desplegar?
   1️⃣  Usar red actual (testnet)
   2️⃣  testnet  
   3️⃣  mainnet
   4️⃣  devnet

   Selecciona una opción (1-4): 1

💰 VERIFICANDO BALANCE...
   💼 Balance actual: 10.00 SUI

🏗️ ¿Quieres que el contrato sea actualizable?
   ✅ SÍ - Podrás actualizar el código manteniendo el Package ID
   ❌ NO - El contrato será inmutable

   ¿Desplegar como actualizable? (y/n): y

🚀 DESPLEGANDO CONTRATO...
✅ ¡DESPLIEGUE EXITOSO!
   📦 Package ID: 0xabc123...
   🔑 Upgrade Cap: 0xdef456...
```

### **Ejemplo 2: Despliegue en Mainnet con Configuración**
```powershell
PS> .\.script\deploy.ps1 -Red mainnet -Actualizable -GasBudget "300000000"

🚀 SCRIPT INTELIGENTE DE DESPLIEGUE SUI
=====================================

📦 Proyecto: empresa_system  
🌐 Red actual: testnet
🔄 Cambiando a mainnet...

💰 VERIFICANDO BALANCE...
   💼 Balance actual: 2.50 SUI

⚠️  DESPLIEGUE EN MAINNET
   💰 Costo estimado: ~0.39 SUI
   🔒 Esta operación usa SUI real

❓ ¿Estás seguro de desplegar en mainnet? (y/n): y

🚀 DESPLEGANDO CONTRATO...
✅ ¡DESPLIEGUE EXITOSO EN MAINNET!
```

---

## 🎯 Casos de Uso Específicos

### **🆕 Desarrollador Principiante**
```powershell
# Simplemente ejecutar sin parámetros
.\.script\deploy.ps1
```
> El script te guiará paso a paso con preguntas interactivas

### **👨‍💻 Desarrollador Experimentado**
```powershell
# Despliegue rápido con parámetros
.\.script\deploy.ps1 -Red testnet -Actualizable
```
> Usa parámetros para acelerar el proceso

### **🏭 Producción en Mainnet**
```powershell
# Despliegue seguro en producción
.\.script\deploy.ps1 -Red mainnet -GasBudget "500000000"
```
> Usa más gas para garantizar éxito en mainnet

### **🧪 Pruebas Rápidas**
```powershell
# Contratos inmutables para pruebas
.\.script\deploy.ps1 -Red devnet -Inmutable
```
> Para pruebas que no requieren actualizaciones

---

## 📊 Información del Archivo `ultimo-despliegue.txt`

El script guarda automáticamente información del despliegue:

```
Package ID: 0xabc123def456...
Upgrade Cap ID: 0x789xyz012...
Red: testnet
Fecha: 9/24/2025 10:30:15 AM
Proyecto: mi_proyecto
Tipo: actualizable
Gas usado: 85432100
```

**Esta información es utilizada por:**
- ✅ `upgrade.ps1` - Para detectar automáticamente qué actualizar
- ✅ `check-packages.ps1` - Para mostrar el último despliegue  
- ✅ `calcular-costo-despliegue.ps1` - Para comparar costos

---

## 🐛 Solución de Problemas

### **❌ Error: "No se encuentra Move.toml"**
```
Solución: Ejecuta el script desde el directorio del proyecto Move
```

### **❌ Error: "Balance insuficiente"**
```
Soluciones:
- Testnet: Usa el faucet https://faucet.sui.io/
- Mainnet: Transfiere más SUI a tu wallet
- Devnet: Usa el faucet de devnet
```

### **❌ Error: "Compilación fallida"**
```
Soluciones:
1. Revisa los errores en el código Move
2. Ejecuta: sui move build
3. Corrige errores de sintaxis
4. Verifica dependencias en Move.toml
```

### **❌ Error: "No se puede cambiar de red"**
```
Soluciones:
1. Verifica que la red existe: sui client envs
2. Agrega la red si no existe:
   sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443
```

### **🔧 Comandos de Diagnóstico:**
```powershell
# Verificar configuración
sui client active-env
sui client active-**address**
sui client balance

# Ver redes disponibles
sui client envs

# Probar compilación manual
sui move build
```

---

## 🎯 Mejores Prácticas

### **🏗️ Para Desarrollo:**
1. ✅ Usa **testnet** para desarrollo y pruebas
2. ✅ Despliega como **actualizable** durante desarrollo
3. ✅ Verifica el balance antes de desplegar
4. ✅ Guarda el Package ID y UpgradeCap

### **🚀 Para Producción:**
1. ✅ Prueba completamente en **testnet** primero
2. ✅ Considera si necesitas **actualizaciones** futuras
3. ✅ Usa **gas budget** generoso en mainnet
4. ✅ Documenta el Package ID desplegado

### **💡 Consejos de Eficiencia:**
1. ⚡ Usa parámetros para deployments repetitivos
2. 📱 Mantén el archivo `ultimo-despliegue.txt` para integración
3. 🔄 Combina con otros scripts para flujo completo
4. 📊 Revisa costos con `calcular-costo-despliegue.ps1` antes de mainnet

---

## 🔗 Scripts Relacionados

- **[🔄 upgrade.ps1](upgrade-script.md)** - Para actualizar contratos desplegados
- **[📦 check-packages.ps1](check-packages-script.md)** - Para verificar paquetes existentes  
- **[💰 calcular-costo-despliegue.ps1](cost-calculator-script.md)** - Para estimar costos

---

## 🎉 ¡Listo para Desarrollar!

Con este script puedes desplegar contratos en Sui de manera profesional y automatizada. El script se encarga de todos los detalles técnicos para que te concentres en desarrollar tu lógica de negocio.

**¡Feliz desarrollo en Sui! 🚀******