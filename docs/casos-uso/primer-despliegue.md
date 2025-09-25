# 🆕 Guía de Primer Despliegue

Esta guía te llevará paso a paso a través de tu primer despliegue en Sui, desde la configuración inicial hasta tener tu contrato funcionando.

## 📋 Antes de Comenzar

### ✅ Checklist de Preparación

- [ ] **Sui CLI instalado** (v1.57.0+)
- [ ] **PowerShell 7.0+** disponible
- [ ] **Proyecto Move** con `Move.toml` configurado
- [ ] **Código compilando** sin errores
- [ ] **Wallet configurado** en Sui

### 🔧 Verificación Rápida

```powershell
# Verificar instalación
sui --version

# Verificar que estás en un proyecto Move
Test-Path "Move.toml"

# Verificar que el código compila
sui move build
```

---

## 🚀 Flujo de Primer Despliegue

### Paso 1: Verificar Estado Actual

```powershell
.\.script\check-packages.ps1
```

**Si es tu primer despliegue, verás:**
```
❌ NO SE ENCONTRARON PAQUETES DESPLEGADOS
   💡 Consejos:
      • Verifica que estés en la red correcta
      • Usa .\.script\deploy.ps1 para desplegar contratos
      • Revisa si tienes paquetes en otras redes
```

### Paso 2: Calcular Costos

```powershell
.\.script\calcular-costo-despliegue.ps1 solo-despliegue
```

**Para testnet (recomendado para primer despliegue):**
```
💰 Costo en SUI: ~0.01 SUI
💵 Costo en USD: ~$0.017
✅ Balance suficiente para despliegue
```

### Paso 3: Ejecutar Primer Despliegue

```powershell
.\.script\deploy.ps1
```

**El script te guiará interactivamente:**

1. **Selección de Red** (elige testnet para empezar)
2. **Tipo de Contrato** (recomendado: actualizable)
3. **Confirmación** antes de desplegar

---

## 📱 Ejemplo Completo: Primer Despliegue

### Sesión Típica de Primer Despliegue

```powershell
PS C:\mi-proyecto> .\.script\check-packages.ps1

📦 VERIFICADOR INTELIGENTE DE PAQUETES SUI
=========================================

🌐 Red actual: testnet

❌ NO SE ENCONTRARON PAQUETES DESPLEGADOS
   💡 Consejos:
      • Usa .\.script\deploy.ps1 para desplegar contratos

PS C:\mi-proyecto> .\.script\calcular-costo-despliegue.ps1 solo-despliegue

💰 CALCULADORA DE COSTOS SUI
============================

🌐 Red actual: testnet
📦 Proyecto: mi_proyecto

🚀 DESPLIEGUE INICIAL:
   💰 Costo en SUI: ~0.01 SUI
   ✅ Balance suficiente para despliegue

PS C:\mi-proyecto> .\.script\deploy.ps1

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

🔨 COMPILANDO PROYECTO...
✅ Compilación exitosa

📋 RESUMEN DE DESPLIEGUE:
   📦 Proyecto: mi_proyecto
   🌐 Red: testnet
   🔄 Tipo: Actualizable (con UpgradeCap)
   ⛽ Gas Budget: 100000000

❓ ¿Proceder con el despliegue? (y/n): y

🚀 DESPLEGANDO CONTRATO...
✅ ¡DESPLIEGUE EXITOSO!
   📦 Package ID: 0x8ddace66e376f03067016c51820d512fa1a8fa9e2e518ed0c842086cdb27ae91
   🔑 Upgrade Cap: 0x039aba13ae7fae8f7ad0537f5ede79c334fbcc40055b9c14b6db737472967ab0

🎯 PRÓXIMOS PASOS:
   • Para actualizar: .\.script\upgrade.ps1
   • Para verificar: .\.script\check-packages.ps1
   • Para interactuar: sui client call --package 0x8ddace66...

🎉 ¡Script completado!
```

---

## 🎯 Decisiones Importantes en el Primer Despliegue

### Red de Despliegue

#### 🧪 Testnet (Recomendado para principiantes)
- ✅ **Costos mínimos** (~$0.02 USD)
- ✅ **SUI gratuito** desde faucet
- ✅ **Perfecto para aprender**
- ✅ **Sin riesgo financiero**

#### 🌐 Mainnet (Solo cuando estés listo)
- ⚠️ **Costos reales** (~$0.64 USD)
- ⚠️ **Requiere SUI real**
- ⚠️ **Para producción**
- ✅ **Red final para usuarios**

### Tipo de Contrato

#### 🔄 Actualizable (Recomendado)
- ✅ **Permite actualizaciones** futuras
- ✅ **Mantiene el Package ID** constante
- ✅ **Flexible** para desarrollo iterativo
- ⚠️ **Ligeramente más costoso**

#### 🔒 Inmutable
- ✅ **Más seguro** (no se puede cambiar)
- ✅ **Ligeramente más barato**
- ❌ **No se puede actualizar** nunca
- ❌ **Menos flexible**

---

## 💡 Consejos para Principiantes

### Antes del Despliegue

1. **Compila Localmente**
   ```powershell
   sui move build
   ```
   > Asegúrate de que no hay errores

2. **Verifica tu Wallet**
   ```powershell
   sui client active-address
   sui client balance
   ```
   > Confirma que tienes SUI suficiente

3. **Usa Testnet Primero**
   ```powershell
   sui client switch --env testnet
   ```
   > Siempre prueba en testnet antes de mainnet

### Durante el Despliegue

1. **Lee los Mensajes** del script cuidadosamente
2. **Guarda los IDs** importantes (Package ID, UpgradeCap)
3. **No te preocupes** si algo sale mal en testnet

### Después del Despliegue

1. **Verifica el Resultado**
   ```powershell
   .\.script\check-packages.ps1
   ```

2. **Prueba una Función**
   ```powershell
   sui client call --package <TU-PACKAGE-ID> --module <MODULO> --function <FUNCION>
   ```

3. **Explora en Suiscan**
   > Ve a https://suiscan.xyz/testnet/home y busca tu Package ID

---

## 🐛 Problemas Comunes y Soluciones

### "No se encuentra Move.toml"
```powershell
# Asegúrate de estar en el directorio del proyecto
cd C:\ruta\a\tu\proyecto
```

### "Balance insuficiente"
```powershell
# Para testnet, usa el faucet
sui client faucet
# O ve a https://faucet.sui.io/
```

### "Error de compilación"
```powershell
# Revisa los errores específicos
sui move build
# Corrige errores en tu código Move
```

### "Red incorrecta"
```powershell
# Cambia a testnet
sui client switch --env testnet
```

---

## 📚 Recursos Adicionales

### Documentación
- [📖 Script de Despliegue](../deploy-script.md) - Guía completa del script
- [💰 Calculadora de Costos](../cost-calculator-script.md) - Entender los costos
- [🔧 Configuración](../configuracion.md) - Setup inicial completo

### Enlaces Útiles
- **Faucet Testnet**: https://faucet.sui.io/
- **Sui Explorer**: https://suiscan.xyz/
- **Documentación Sui**: https://docs.sui.io/

---

## 🎯 Próximos Pasos

Una vez completado tu primer despliegue:

1. **📦 Explora tus paquetes** con `check-packages.ps1`
2. **🔄 Aprende a actualizar** con `upgrade.ps1`
3. **💰 Entiende los costos** con `calcular-costo-despliegue.ps1`
4. **🌐 Considera mainnet** cuando estés listo para producción

---

## ✅ Checklist de Primer Despliegue Exitoso

- [ ] Proyecto compilando sin errores
- [ ] Script ejecutado en testnet
- [ ] Package ID obtenido y guardado
- [ ] UpgradeCap guardado (si elegiste actualizable)
- [ ] Contrato verificado en Suiscan
- [ ] Función de prueba ejecutada exitosamente

**🎉 ¡Felicitaciones por tu primer despliegue en Sui!**

Ahora eres oficialmente un desarrollador de Sui. El próximo paso es explorar las funcionalidades avanzadas y considerar el despliegue en mainnet cuando tu proyecto esté listo para usuarios reales.