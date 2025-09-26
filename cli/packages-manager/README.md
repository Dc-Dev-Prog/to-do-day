# 📦 PACKAGES MANAGER SUI - DOCUMENTACIÓN

## 📋 Descripción
Sistema completo de gestión de paquetes para la blockchain SUI con reportes organizados por tareas.

## 🚀 Scripts Disponibles

### 🚀 **deploy.ps1** - Despliegue Inteligente
```powershell
# Despliegue básico
.\deploy.ps1

# Despliegue en red específica
.\deploy.ps1 -Red testnet

# Modo DEMO (sin transacciones reales)
.\deploy.ps1 -DEMO
```

### 🔄 **upgrade.ps1** - Actualización de Paquetes
```powershell
# Actualización básica
.\upgrade.ps1

# Actualización en red específica
.\upgrade.ps1 -Red mainnet

# Modo DEMO
.\upgrade.ps1 -DEMO
```

### 📦 **check-packages.ps1** - Verificación de Paquetes
```powershell
# Verificar en todas las redes
.\check-packages.ps1

# Verificar red específica
.\check-packages.ps1 -Red devnet

# Verificación completa
.\check-packages.ps1 -Red all
```

### 🔍 **inspect-package.ps1** - Inspección Detallada
```powershell
# Inspección interactiva
.\inspect-package.ps1

# Inspeccionar package específico
.\inspect-package.ps1 -PackageId 0x123... -Red mainnet
```

### 💰 **calcular-costo-despliegue.ps1** - Cálculo de Costos
```powershell
# Calcular costos básico
.\calcular-costo-despliegue.ps1

# Calcular en red específica
.\calcular-costo-despliegue.ps1 -Red testnet
```

## 📊 Sistema de Reportes

Los reportes se organizan automáticamente por tarea:

### 📂 Estructura de Reportes
```
reports/
├── deploy/             # Reportes de despliegues
├── upgrade/            # Reportes de actualizaciones  
├── check-packages/     # Reportes de verificaciones
├── inspect-package/    # Reportes de inspecciones
└── calcular-costo/     # Reportes de cálculos de costo
```

## 🌐 Redes Soportadas
- **mainnet** 🔴 - Red principal (transacciones reales)
- **testnet** 🟡 - Red de pruebas (tokens de prueba)  
- **devnet** 🟢 - Red de desarrollo (máxima libertad)
- **all** 🌈 - Todas las redes (verificaciones completas)

## 📁 Estructura Completa
```
packages-manager/
├── deploy.ps1                      # 🚀 Despliegue inteligente
├── upgrade.ps1                     # 🔄 Actualización de paquetes
├── check-packages.ps1              # 📦 Verificación de paquetes
├── inspect-package.ps1             # 🔍 Inspección detallada
├── calcular-costo-despliegue.ps1   # 💰 Cálculo de costos
├── README.md                       # Esta documentación
└── reports/                        # 📊 Reportes por tarea
    ├── deploy/
    ├── upgrade/  
    ├── check-packages/
    ├── inspect-package/
    └── calcular-costo/
```

## 🎯 Características Principales
- ✅ **Detección automática de red** y configuración
- ✅ **Modo DEMO** para pruebas sin transacciones reales
- ✅ **Reportes automáticos** organizados por tarea
- ✅ **Soporte multi-red** (mainnet/testnet/devnet)
- ✅ **Inspección inteligente** de paquetes y capabilities
- ✅ **Cálculo de costos** con conversión USD
- ✅ **Gestión de UpgradeCaps** automática
- ✅ **Trazabilidad completa** de operaciones

## 🔧 Requisitos
- **PowerShell** 5.1 o superior
- **Sui CLI** v1.57.0 o superior
- **Wallet configurada** en sui client
- **Conexión a internet** para conversiones USD

## 📖 Documentación Adicional
- Ver `reports/README.md` para detalles de reportes
- Cada script incluye ayuda con `-Ayuda` o `-Help`
- Ejemplos completos en la documentación de cada script

---
*Sistema desarrollado para ProyectoCertificacionSui - $(Get-Date -Format "yyyy-MM-dd")*