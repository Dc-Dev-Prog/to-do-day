# 💼 WALLET MANAGER SUI - DOCUMENTACIÓN

## 📋 Descripción
Sistema completo de gestión de wallets para la blockchain SUI con formato visual elegante.

## 🚀 Uso Rápido
```powershell
# Ver wallets con formato elegante
.\wallet-manager.ps1 -Lista

# Consultar saldos en todas las redes
.\wallet-manager.ps1 -Balance -Red all

# Exportar wallets
.\wallet-manager.ps1 -Export

# Menú interactivo
.\wallet-manager.ps1
```

## 📊 Funcionalidades
- ✅ **Lista elegante** con numeración y detección de wallet activa
- ✅ **Consulta multi-red** (mainnet/testnet/devnet)  
- ✅ **Conversión USD** automática (~$3.16/SUI)
- ✅ **Exportación JSON** con metadata
- ✅ **Menú interactivo** fácil de usar
- ✅ **Parsing Unicode** robusto para sui CLI
- ✅ **Reportes automáticos** organizados por tareas (lista/balance/export/operaciones)
- ✅ **Trazabilidad completa** de todas las operaciones realizadas

## 🌐 Redes Soportadas
- **mainnet** 🔴 - Red principal (transacciones reales)
- **testnet** 🟡 - Red de pruebas (tokens de prueba)  
- **devnet** 🟢 - Red de desarrollo (máxima libertad)
- **all** 🌈 - Todas las redes (consulta completa)

## 📁 Estructura de Archivos
```
wallet-manager/
├── wallet-manager.ps1          # Script principal
├── README.md                   # Esta documentación
├── examples/                   # Ejemplos de uso
│   └── EJEMPLOS.md
└── reports/                    # 📊 Reportes organizados por tarea
    ├── README.md               # Índice de reportes
    ├── lista/                  # Reportes de listado de wallets
    ├── balance/                # Reportes de consulta de saldos
    ├── export/                 # Reportes y archivos de exportación
    └── operaciones/            # Reportes de operaciones interactivas
```

## 🔧 Versión
- **Actual**: v2.3
- **Formato**: Visual elegante con emojis
- **Compatibilidad**: PowerShell 5.1+ y sui CLI 1.57.0+

## 📞 Soporte
Para reportar problemas o sugerencias, revisar el código fuente en el script principal.

---
*Sistema desarrollado para ProyectoCertificacionSui - $(Get-Date -Format "yyyy-MM-dd")*