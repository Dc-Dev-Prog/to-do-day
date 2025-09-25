# 📦 Verificador de Paquetes Inteligente

El script `check-packages.ps1` proporciona una vista completa de todos los paquetes Sui desplegados y sus capabilities de actualización.

## 📋 Tabla de Contenidos

- [Características Principales](#características-principales)
- [Parámetros del Script](#parámetros-del-script)  
- [Uso Básico](#uso-básico)
- [Modos de Visualización](#modos-de-visualización)
- [Ejemplos Detallados](#ejemplos-detallados)
- [Interpretando la Salida](#interpretando-la-salida)

---

## Características Principales

### Detección Completa de Paquetes
- Encuentra automáticamente todos los UpgradeCaps en tu wallet
- Lee información del último despliegue registrado
- Identifica paquetes actualizables vs inmutables
- Muestra estadísticas completas de tus despliegues

### Análisis Inteligente
- Conecta UpgradeCaps con sus Package IDs correspondientes
- Muestra versiones y estados de los paquetes
- Proporciona sugerencias de próximos pasos
- Detecta la red activa automáticamente

### Información Contextual
- Integra datos del archivo `ultimo-despliegue.txt`
- Proporciona enlaces a otros scripts relacionados
- Muestra estadísticas resumidas
- Ofrece opciones de visualización flexible

---

## Parámetros del Script

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `-Red` | String | Verificar paquetes en red específica |
| `-Detallado` | Switch | Muestra información técnica adicional |
| `-SoloActualizables` | Switch | Solo muestra paquetes con UpgradeCap |

---

## Uso Básico

### Verificación Completa
```powershell
.\.script\check-packages.ps1
```

### Salida Típica
```
📦 VERIFICADOR INTELIGENTE DE PAQUETES SUI
=========================================

🌐 Red actual: testnet

🔍 BUSCANDO UPGRADE CAPABILITIES...

⭐ ÚLTIMO DESPLIEGUE REGISTRADO:
📋 PAQUETE: 0x8ddace66e376f03067016c51820d512fa1a8fa9e2e518ed0c842086cdb27ae91
   🏷️  Versión: N/A
   🔑 UpgradeCap: 0x039aba13ae7fae8f7ad0537f5ede79c334fbcc40055b9c14b6db737472967ab0
   ✅ Actualizable: SÍ

🔍 OTROS PAQUETES ACTUALIZABLES:
📋 PAQUETE: 0x5d0d6b1d4c035ef09abe4a3cd9e395673c3e3290b3f17bca5583ae3f2bb6802c
   🏷️  Versión: 1
   🔑 UpgradeCap: 0x5d0d6b1d4c035ef09abe4a3cd9e395673c3e3290b3f17bca5583ae3f2bb6802c
   ✅ Actualizable: SÍ

📈 ESTADÍSTICAS:
   📦 Total paquetes actualizables: 2
   🔑 UpgradeCaps disponibles: 3
   🌐 Red actual: testnet

🎯 PRÓXIMOS PASOS:
   • Para actualizar: .\.script\upgrade.ps1
   • Para calcular costos: .\.script\calcular-costo-despliegue.ps1
   • Para nuevo despliegue: .\.script\deploy.ps1
```

---

## Modos de Visualización

### Modo Básico (Default)
```powershell
.\.script\check-packages.ps1
```
Muestra información esencial de todos los paquetes

### Modo Detallado
```powershell
.\.script\check-packages.ps1 -Detallado
```
Incluye información técnica adicional como fechas de creación y metadata

### Solo Actualizables
```powershell
.\.script\check-packages.ps1 -SoloActualizables
```
Filtra para mostrar únicamente paquetes que pueden ser actualizados

### Red Específica
```powershell
.\.script\check-packages.ps1 -Red mainnet
```
Verifica paquetes en una red específica

---

## Ejemplos Detallados

### Ejemplo 1: Primera Verificación
```powershell
PS> .\.script\check-packages.ps1

📦 VERIFICADOR INTELIGENTE DE PAQUETES SUI
=========================================

🌐 Red actual: testnet

🔍 BUSCANDO UPGRADE CAPABILITIES...

❌ NO SE ENCONTRARON PAQUETES DESPLEGADOS
   💡 Consejos:
      • Verifica que estés en la red correcta
      • Usa .\.script\deploy.ps1 para desplegar contratos
      • Revisa si tienes paquetes en otras redes

✅ Verificación completa!
```

### Ejemplo 2: Múltiples Paquetes con Modo Detallado
```powershell
PS> .\.script\check-packages.ps1 -Detallado

📦 VERIFICADOR INTELIGENTE DE PAQUETES SUI
=========================================

🌐 Red actual: testnet

⭐ ÚLTIMO DESPLIEGUE REGISTRADO:
📋 PAQUETE: 0x8ddace66e376f03067016c51820d512fa1a8fa9e2e518ed0c842086cdb27ae91
   🏷️  Versión: N/A
   🔑 UpgradeCap: 0x039aba13ae7fae8f7ad0537f5ede79c334fbcc40055b9c14b6db737472967ab0
   ✅ Actualizable: SÍ
   🔍 Obteniendo detalles...
   📅 Creado: Versión 1

🔍 OTROS PAQUETES ACTUALIZABLES:
📋 PAQUETE: 0x5d0d6b1d4c035ef09abe4a3cd9e395673c3e3290b3f17bca5583ae3f2bb6802c
   🏷️  Versión: 2
   🔑 UpgradeCap: 0x5d0d6b1d4c035ef09abe4a3cd9e395673c3e3290b3f17bca5583ae3f2bb6802c
   ✅ Actualizable: SÍ
   📅 Creado: Versión 2

📈 ESTADÍSTICAS:
   📦 Total paquetes actualizables: 2
   🔑 UpgradeCaps disponibles: 3
   🌐 Red actual: testnet
```

### Ejemplo 3: Verificación en Mainnet
```powershell
PS> .\.script\check-packages.ps1 -Red mainnet

📦 VERIFICADOR INTELIGENTE DE PAQUETES SUI
=========================================

🌐 Red actual: testnet
🔄 Cambiando a mainnet...

🔍 BUSCANDO UPGRADE CAPABILITIES...

⭐ ÚLTIMO DESPLIEGUE REGISTRADO:
📋 PAQUETE: 0x41c0712233a64af3b69dd5f2a557b3a05f4dabdaba0300880e130d59381be03f
   🏷️  Versión: N/A
   🔑 UpgradeCap: 0x987fed543ab2c1d0e9f8g7h6i5j4k3l2m1n0o9p8q7r6s5t4u3v2w1x0y9z8
   ✅ Actualizable: SÍ

📈 ESTADÍSTICAS:
   📦 Total paquetes actualizables: 1
   🔑 UpgradeCaps disponibles: 1
   🌐 Red actual: mainnet
```

---

## Interpretando la Salida

### Secciones de la Salida

#### Último Despliegue Registrado
- **Fuente**: Archivo `ultimo-despliegue.txt`
- **Información**: Package ID, UpgradeCap, fecha de despliegue
- **Propósito**: Identificar tu despliegue más reciente

#### Otros Paquetes Actualizables  
- **Fuente**: Búsqueda en objetos del wallet
- **Información**: Todos los UpgradeCaps encontrados
- **Propósito**: Ver todos los paquetes que puedes actualizar

#### Estadísticas Resumidas
- **Total paquetes actualizables**: Cuántos contratos puedes actualizar
- **UpgradeCaps disponibles**: Cuántos UpgradeCaps tienes
- **Red actual**: En qué red estás verificando

### Estados de Paquetes

| Estado | Descripción | Acción Disponible |
|--------|-------------|-------------------|
| ✅ **Actualizable: SÍ** | Tiene UpgradeCap | Puede ser actualizado |
| ❌ **Actualizable: NO** | Sin UpgradeCap | Solo lectura, inmutable |
| ⚠️ **Error** | No se puede acceder | Verificar permisos |

---

## Casos de Uso Específicos

### Auditoría de Paquetes
```powershell
# Ver todos los paquetes en todas las redes
.\.script\check-packages.ps1 -Red testnet
.\.script\check-packages.ps1 -Red mainnet
.\.script\check-packages.ps1 -Red devnet
```

### Preparación para Actualización
```powershell
# Ver solo paquetes actualizables
.\.script\check-packages.ps1 -SoloActualizables
```

### Análisis Técnico Detallado
```powershell
# Información completa con detalles técnicos
.\.script\check-packages.ps1 -Detallado
```

### Verificación Cruzada de Redes
```powershell
# Comparar despliegues entre redes
.\.script\check-packages.ps1 -Red testnet -Detallado
.\.script\check-packages.ps1 -Red mainnet -Detallado
```

---

## Integración con Otros Scripts

### Flujo de Desarrollo Típico

```powershell
# 1. Verificar estado actual
.\.script\check-packages.ps1

# 2. Si no hay paquetes, desplegar uno nuevo
.\.script\deploy.ps1

# 3. Si hay paquetes, calcular costo de actualización
.\.script\calcular-costo-despliegue.ps1 solo-actualizacion

# 4. Actualizar paquete existente
.\.script\upgrade.ps1
```

### Uso en Conjunto

#### Con deploy.ps1
```powershell
# Verificar antes de desplegar para evitar duplicados
.\.script\check-packages.ps1
.\.script\deploy.ps1  # Solo si no hay paquetes o quieres uno nuevo
```

#### Con upgrade.ps1
```powershell
# Identificar qué actualizar
.\.script\check-packages.ps1 -SoloActualizables
.\.script\upgrade.ps1  # Usa la información detectada automáticamente
```

#### Con calcular-costo-despliegue.ps1
```powershell
# Verificar paquetes existentes antes de calcular costos
.\.script\check-packages.ps1
.\.script\calcular-costo-despliegue.ps1 ambos  # Calcula para despliegue y actualización
```

---

## Solución de Problemas

### "No se encontraron paquetes desplegados"

**Posibles causas:**
- Estás en la red incorrecta
- No has desplegado ningún contrato
- Los contratos fueron desplegados desde otra dirección

**Soluciones:**
1. Verificar red activa: `sui client active-env`
2. Cambiar de red: `sui client switch --env <red>`
3. Verificar dirección activa: `sui client active-address`
4. Desplegar primer contrato: `.\.script\deploy.ps1`

### "Error al obtener detalles"

**Posibles causas:**
- Problemas de conexión con la red
- UpgradeCap inválido o eliminado
- Permisos insuficientes

**Soluciones:**
1. Verificar conexión: `sui client objects`
2. Usar modo básico en lugar de detallado
3. Verificar manualmente: `sui client object <UpgradeCap-ID>`

### Comandos de Diagnóstico
```powershell
# Verificar configuración básica
sui client active-env
sui client active-address
sui client balance

# Ver todos los objetos (incluye UpgradeCaps)
sui client objects

# Verificar un UpgradeCap específico
sui client object <UpgradeCap-ID> --json

# Ver redes configuradas
sui client envs
```

---

## Información Técnica

### Estructura del Archivo ultimo-despliegue.txt
```
Package ID: 0x8ddace66e376f03067016c51820d512fa1a8fa9e2e518ed0c842086cdb27ae91
Upgrade Cap ID: 0x039aba13ae7fae8f7ad0537f5ede79c334fbcc40055b9c14b6db737472967ab0
Red: testnet
Fecha: 9/24/2025 10:30:15 AM
Proyecto: to_do_day
Último update: 9/24/2025 2:45:30 PM
```

### Detección de UpgradeCaps
El script busca objetos que coincidan con el patrón:
```
(0x[a-f0-9]+).*UpgradeCap
```

### Obtención de Package IDs
Para cada UpgradeCap encontrado, el script ejecuta:
```powershell
$capInfo = sui client object $upgradeCapId --json | ConvertFrom-Json
$packageId = $capInfo.content.fields.package
```

---

## Mejores Prácticas

### Verificación Regular
```powershell
# Ejecutar regularmente para mantener visibilidad
.\.script\check-packages.ps1 -Detallado
```

### Antes de Actualizaciones
```powershell
# Siempre verificar antes de actualizar
.\.script\check-packages.ps1 -SoloActualizables
.\.script\upgrade.ps1
```

### Gestión Multi-Red
```powershell
# Mantener inventario de todas las redes
.\.script\check-packages.ps1 -Red testnet > testnet-packages.txt
.\.script\check-packages.ps1 -Red mainnet > mainnet-packages.txt
```

### Documentación
- Guarda las salidas del script para documentación
- Usa modo detallado para registros importantes
- Combina con screenshots para documentación visual

---

## Scripts Relacionados

- **[🚀 deploy.ps1](deploy-script.md)** - Para desplegar nuevos contratos
- **[🔄 upgrade.ps1](upgrade-script.md)** - Para actualizar contratos existentes  
- **[💰 calcular-costo-despliegue.ps1](cost-calculator-script.md)** - Para estimar costos

---

¡Con este script siempre tendrás visibilidad completa de tus paquetes Sui desplegados! 📦