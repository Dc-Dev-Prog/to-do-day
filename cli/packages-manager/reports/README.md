# 📋 ÍNDICE DE REPORTES - PACKAGES MANAGER

## 📂 Estructura de Reportes por Operación

El sistema packages-manager genera reportes organizados en las siguientes categorías:

### 🚀 **deploy/** - Reportes de Despliegue
- **Propósito**: Documentar operaciones de despliegue de paquetes
- **Contenido**: PackageId generado, costos, transacciones, UpgradeCap
- **Formato**: Markdown con JSON estructurado
- **Archivos**: `deploy-report-YYYYMMDD-HHMMSS.md`

### 🔄 **upgrade/** - Reportes de Actualización
- **Propósito**: Documentar actualizaciones de paquetes existentes
- **Contenido**: UpgradeCap utilizada, cambios aplicados, costos
- **Formato**: Markdown con JSON estructurado
- **Archivos**: `upgrade-report-YYYYMMDD-HHMMSS.md`

### 📦 **check-packages/** - Reportes de Verificación
- **Propósito**: Documentar verificaciones de paquetes desplegados
- **Contenido**: Lista de paquetes por red, capabilities detectadas
- **Formato**: Markdown con JSON estructurado
- **Archivos**: `check-packages-report-YYYYMMDD-HHMMSS.md`

### 🔍 **inspect-package/** - Reportes de Inspección
- **Propósito**: Documentar inspecciones detalladas de paquetes específicos
- **Contenido**: Análisis de funciones, structs, capabilities, sistema detectado
- **Formato**: Markdown con JSON estructurado
- **Archivos**: `inspect-package-report-YYYYMMDD-HHMMSS.md`

### 💰 **calcular-costo/** - Reportes de Cálculo de Costos
- **Propósito**: Documentar estimaciones de costo de despliegue/actualización
- **Contenido**: Costos por red, conversión USD, recomendaciones
- **Formato**: Markdown con JSON estructurado
- **Archivos**: `calcular-costo-report-YYYYMMDD-HHMMSS.md`

## 🎯 **Información en Cada Reporte**

Todos los reportes incluyen:
- ✅ **Timestamp** completo de la operación
- ✅ **Red utilizada** (mainnet/testnet/devnet)
- ✅ **Wallet activa** durante la operación
- ✅ **Tipo de operación** y parámetros utilizados
- ✅ **Datos estructurados** en formato JSON
- ✅ **Resultados detallados** y métricas

## 📊 **Ejemplo de Nombrado**

```
reports/
├── deploy/
│   └── deploy-report-20250925-120000.md
├── upgrade/
│   └── upgrade-report-20250925-120500.md
├── check-packages/
│   └── check-packages-report-20250925-121000.md
├── inspect-package/
│   └── inspect-package-report-20250925-121500.md
└── calcular-costo/
    └── calcular-costo-report-20250925-122000.md
```

## 🔍 **Navegación Rápida**

Para encontrar reportes específicos:
- **Por operación**: Navega a la carpeta específica (deploy/, upgrade/, etc.)
- **Por fecha**: Los archivos usan formato `YYYYMMDD-HHMMSS`
- **Por red**: Filtra por contenido usando la red especificada
- **Más reciente**: El último archivo en cada carpeta

## 💡 **Tips de Uso**

- Los reportes se generan **automáticamente** en cada operación
- Formato **Markdown** para fácil lectura y documentación
- **JSON estructurado** para análisis y procesamiento automatizado
- **Historial completo** de todas las operaciones de paquetes
- **Trazabilidad** de despliegues, actualizaciones e inspecciones

## 🎯 **Datos Específicos por Tipo de Reporte**

### 🚀 Deploy Reports
- PackageId generado, UpgradeCap, costos de gas, dirección de publicador

### 🔄 Upgrade Reports  
- UpgradeCap utilizada, cambios aplicados, versión anterior vs nueva

### 📦 Check-Packages Reports
- Lista completa de paquetes por red, capabilities por paquete

### 🔍 Inspect-Package Reports
- Funciones públicas, structs, análisis de sistema, recomendaciones

### 💰 Calcular-Costo Reports
- Estimaciones por red, conversión USD, comparativas de costos

---
*Índice actualizado automáticamente - $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")*