# 🔄 Script de Actualización Inteligente

El script `upgrade.ps1` permite actualizar contratos inteligentes existentes en Sui manteniendo el mismo Package ID y estado.

## 📋 Tabla de Contenidos

- [Características Principales](#características-principales)
- [Parámetros del Script](#parámetros-del-script)
- [Uso Básico](#uso-básico)
- [Uso Avanzado](#uso-avanzado)
- [Ejemplos Detallados](#ejemplos-detallados)
- [Solución de Problemas](#solución-de-problemas)

---

## Características Principales

### Detección Automática de UpgradeCaps
- Busca automáticamente UpgradeCaps en tu wallet
- Lee información del último despliegue desde `ultimo-despliegue.txt`
- Permite selección interactiva cuando hay múltiples opciones

### Gestión Inteligente de Paquetes
- Obtiene automáticamente el Package ID desde el UpgradeCap
- Verifica que el paquete sea actualizable
- Mantiene el mismo Package ID después de la actualización

### Validaciones de Seguridad
- Verifica balance suficiente antes de actualizar
- Compila el proyecto antes de proceder
- Solicita confirmación antes de ejecutar la actualización

---

## Parámetros del Script

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `-PackageId` | String | ID del paquete a actualizar |
| `-UpgradeCapId` | String | ID del UpgradeCap específico a usar |
| `-Red` | String | Red donde actualizar (testnet, mainnet, devnet) |
| `-GasBudget` | String | Presupuesto de gas (default: 100000000) |

---

## Uso Básico

### Actualización Automática
```powershell
.\.script\upgrade.ps1
```

**Proceso automático:**
1. Detecta UpgradeCaps disponibles
2. Lee información del último despliegue
3. Verifica balance y compila código
4. Ejecuta la actualización

### Salida Típica
```
🔄 SCRIPT INTELIGENTE DE ACTUALIZACIÓN SUI
==========================================

📦 Proyecto: to_do_day
🌐 Red actual: testnet

🔍 DETECTANDO UPGRADE CAPABILITIES...
   📄 Encontrado último despliegue:
      Package ID: 0xabc123...
      Upgrade Cap: 0xdef456...

   ¿Usar este UpgradeCap? (y/n): y

💰 VERIFICANDO BALANCE...
   💼 Balance actual: 1.77 SUI

🔨 COMPILANDO PROYECTO ACTUALIZADO...
✅ Compilación exitosa

📋 RESUMEN DE ACTUALIZACIÓN:
   📦 Proyecto: to_do_day
   🌐 Red: testnet
   🆔 Package ID: 0xabc123...
   🔑 Upgrade Cap: 0xdef456...
   ⛽ Gas Budget: 100000000

❓ ¿Proceder con la actualización? (y/n): y

🚀 EJECUTANDO ACTUALIZACIÓN...
✅ ¡ACTUALIZACIÓN EXITOSA!
```

---

## Uso Avanzado

### Especificar Red
```powershell
.\.script\upgrade.ps1 -Red mainnet
```

### Usar UpgradeCap Específico
```powershell
.\.script\upgrade.ps1 -UpgradeCapId "0x456789..."
```

### Actualización Completa Manual
```powershell
.\.script\upgrade.ps1 -PackageId "0x123abc..." -UpgradeCapId "0x456def..." -Red testnet
```

### Gas Budget Personalizado
```powershell
.\.script\upgrade.ps1 -GasBudget "200000000"
```

---

## Ejemplos Detallados

### Ejemplo 1: Primera Actualización
```powershell
PS> .\.script\upgrade.ps1

🔄 SCRIPT INTELIGENTE DE ACTUALIZACIÓN SUI
==========================================

📦 Proyecto: empresa_system
🌐 Red actual: testnet

🔍 DETECTANDO UPGRADE CAPABILITIES...
   📄 Encontrado último despliegue:
      Package ID: 0x8ddace66e376f03067016c51820d512fa1a8fa9e2e518ed0c842086cdb27ae91
      Upgrade Cap: 0x039aba13ae7fae8f7ad0537f5ede79c334fbcc40055b9c14b6db737472967ab0

   ¿Usar este UpgradeCap? (y/n): y

🔨 COMPILANDO PROYECTO ACTUALIZADO...
✅ Compilación exitosa

🚀 EJECUTANDO ACTUALIZACIÓN...
✅ ¡ACTUALIZACIÓN EXITOSA!
   📦 El paquete 0x8ddace66... ha sido actualizado
   🔄 Se mantiene el mismo Package ID
```

### Ejemplo 2: Múltiples UpgradeCaps
```powershell
PS> .\.script\upgrade.ps1

🔍 DETECTANDO UPGRADE CAPABILITIES...
   🔍 Múltiples UpgradeCaps encontrados:
      1️⃣  0x039aba13ae7fae8f7ad0537f5ede79c334fbcc40055b9c14b6db737472967ab0
      2️⃣  0x5d0d6b1d4c035ef09abe4a3cd9e395673c3e3290b3f17bca5583ae3f2bb6802c
      3️⃣  0xccaf53beb7a1c9b9ff11edbaa37fac6e8d62e58fab69eb64bc9c0c7696336e56

   Selecciona el UpgradeCap (1-3): 1
```

### Ejemplo 3: Cambio de Red
```powershell
PS> .\.script\upgrade.ps1 -Red mainnet

🌐 Red actual: testnet
🔄 Cambiando a mainnet...

💰 VERIFICANDO BALANCE...
   💼 Balance actual: 2.50 SUI

⚠️  ACTUALIZACIÓN EN MAINNET
   💰 Costo estimado: ~0.3 SUI
   🔒 Esta operación usa SUI real

❓ ¿Estás seguro de actualizar en mainnet? (y/n): y
```

---

## Casos de Uso Específicos

### Desarrollo Iterativo
```powershell
# Actualización rápida durante desarrollo
.\.script\upgrade.ps1
```
> Para actualizaciones frecuentes en testnet

### Actualización en Producción
```powershell
# Actualización segura en mainnet
.\.script\upgrade.ps1 -Red mainnet -GasBudget "300000000"
```
> Con gas adicional para garantizar éxito

### Gestión de Múltiples Proyectos
```powershell
# Usar UpgradeCap específico
.\.script\upgrade.ps1 -UpgradeCapId "0x456789..."
```
> Cuando tienes varios contratos desplegados

---

## Información Técnica

### Diferencias entre Deploy y Upgrade

| Aspecto | Deploy | Upgrade |
|---------|--------|---------|
| **Package ID** | Genera nuevo | Mantiene el mismo |
| **Estado** | Se pierde | Se conserva |
| **Objetos** | Nuevos objetos | Objetos existentes |
| **Costo** | ~0.39 SUI (mainnet) | ~0.3 SUI (mainnet) |
| **Requiere** | Código compilado | UpgradeCap + código |

### Limitaciones de las Actualizaciones

1. **Compatibilidad de Tipos**: Los tipos existentes no pueden cambiar de manera incompatible
2. **Funciones Públicas**: No puedes eliminar funciones públicas existentes
3. **Campos de Struct**: Cuidado al modificar structs existentes
4. **UpgradeCap**: Necesitas el UpgradeCap para actualizar

---

## Solución de Problemas

### Error: "No se encontraron UpgradeCaps"
**Causa**: No hay UpgradeCaps en tu wallet o red incorrecta
**Soluciones**:
- Verifica que estás en la red correcta
- Asegúrate de haber desplegado un contrato actualizable
- Usa `check-packages.ps1` para ver tus paquetes

### Error: "Error al obtener Package ID"
**Causa**: UpgradeCap inválido o inaccesible
**Soluciones**:
- Verifica que el UpgradeCap existe: `sui client object <UpgradeCap-ID>`
- Confirma que tienes permisos sobre el UpgradeCap
- Usa un UpgradeCap diferente si tienes múltiples

### Error: "Balance insuficiente"
**Causa**: No tienes suficiente SUI para la actualización
**Soluciones**:
- Testnet: Usa el faucet https://faucet.sui.io/
- Mainnet: Transfiere más SUI a tu wallet
- Reduce el gas budget si es posible

### Error: "Compilación fallida"
**Causa**: Errores en el código Move actualizado
**Soluciones**:
- Revisa los errores de compilación
- Verifica compatibilidad con versión anterior
- Ejecuta `sui move build` manualmente para ver errores

### Comandos de Diagnóstico
```powershell
# Ver UpgradeCaps disponibles
sui client objects | Select-String "UpgradeCap"

# Verificar un UpgradeCap específico
sui client object <UpgradeCap-ID> --json

# Ver información de un paquete
sui client object <Package-ID>

# Compilar manualmente
sui move build
```

---

## Mejores Prácticas

### Para Desarrollo
1. **Prueba Primero**: Siempre prueba actualizaciones en testnet
2. **Compatibilidad**: Mantén compatibilidad con versiones anteriores
3. **Backup**: Guarda información de UpgradeCaps importantes
4. **Documentación**: Documenta cambios entre versiones

### Para Producción
1. **Testing Completo**: Prueba exhaustivamente antes de mainnet
2. **Gas Generoso**: Usa gas budget alto para mainnet
3. **Horarios**: Actualiza en horarios de bajo tráfico
4. **Rollback Plan**: Ten plan de contingencia si algo falla

### Flujo Recomendado
```powershell
# 1. Verificar paquetes existentes
.\.script\check-packages.ps1

# 2. Calcular costo de actualización
.\.script\calcular-costo-despliegue.ps1 solo-actualizacion

# 3. Actualizar en testnet primero
.\.script\upgrade.ps1 -Red testnet

# 4. Si todo está bien, actualizar en mainnet
.\.script\upgrade.ps1 -Red mainnet
```

---

## Integración con Otros Scripts

### Con check-packages.ps1
```powershell
# Ver todos los paquetes disponibles para actualizar
.\.script\check-packages.ps1 -SoloActualizables
```

### Con calcular-costo-despliegue.ps1
```powershell
# Calcular costo antes de actualizar
.\.script\calcular-costo-despliegue.ps1 solo-actualizacion
```

### Con deploy.ps1
```powershell
# Si necesitas desplegar uno nuevo en lugar de actualizar
.\.script\deploy.ps1 -Actualizable
```

---

## Próximos Pasos

Después de una actualización exitosa:

1. **Verificar**: Usa `sui client object <Package-ID>` para verificar la nueva versión
2. **Probar**: Ejecuta funciones del contrato para verificar funcionalidad
3. **Documentar**: Actualiza documentación con los cambios
4. **Monitorear**: Observa el comportamiento del contrato actualizado

**¡Felices actualizaciones en Sui! 🔄**