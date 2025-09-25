🏠[Readme](README.md) \ 📚[Docs](../docs/documentacion-detallada.md) \ 📄 **🤝 Guía de Contribución**

# Guía de Contribución

¡Gracias por tu interés en contribuir al proyecto **To-Do-Day**! Esta guía te ayudará a entender cómo puedes participar y hacer del proyecto algo aún mejor.

## [Tabla de Contenidos](#guía-de-contribución)

- [Tabla de Contenidos](#tabla-de-contenidos)
- [Empezando](#empezando)
- [Tipos de Contribuciones](#tipos-de-contribuciones)
- [Proceso de Contribución](#proceso-de-contribución)
- [Configuración del Entorno](#configuración-del-entorno)
- [Estándares de Código](#estándares-de-código)
- [Reportar Bugs](#reportar-bugs)
- [Solicitar Funcionalidades](#solicitar-funcionalidades)
- [Mejorar Documentación](#mejorar-documentación)
- [Pull Requests](#pull-requests)
- [Obtener Ayuda](#obtener-ayuda)
- [Reconocimientos](#reconocimientos)
- [Licencia](#licencia)

---

## [Empezando](#guía-de-contribución)

### Prerrequisitos

Antes de contribuir, asegúrate de tener:

- **Git** instalado en tu sistema
- **PowerShell 7.0+** (para Windows)
- **Sui CLI v1.57.0+** instalado y configurado
- **Visual Studio Code** (recomendado) con extensiones de Move
- Conocimientos básicos de **Move language** y **Sui blockchain**

### Primera Configuración

1. **Fork el repositorio** en tu cuenta de GitHub
2. **Clona tu fork** localmente:

   ```bash
   git clone https://github.com/TU-USUARIO/to-do-day.git
   cd to-do-day
   ```

3. **Configura el upstream**:

   ```bash
   git remote add upstream https://github.com/Dc-Dev-Prog/to-do-day.git
   ```

---

## [Tipos de Contribuciones](#guía-de-contribución)

Aceptamos varios tipos de contribuciones:

### **Reportes de Bugs**

- Encuentra y reporta errores en scripts o documentación
- Usa nuestras [plantillas de bug report](#reportar-bugs)
- Proporciona información detallada para reproducir el problema

### **Nuevas Funcionalidades**

- Mejoras a scripts existentes
- Nuevos scripts de automatización
- Optimizaciones de rendimiento

### **Documentación**

- Correcciones de typos o errores
- Mejoras en claridad y estructura
- Traducción de documentación
- Nuevos casos de uso y ejemplos

### **Mejoras de Scripts**

- Optimización de scripts PowerShell
- Mejor manejo de errores
- Nuevas opciones y funcionalidades

### **Testing**

- Pruebas en diferentes entornos
- Validación de funcionalidades
- Pruebas de regresión

---

## [Proceso de Contribución](#guía-de-contribución)

### **Antes de Empezar**

- **Lee** nuestro [Código de Conducta](CODE_OF_CONDUCT.md)
- **Busca** si ya existe un issue relacionado
- **Discute** cambios grandes antes de implementarlos

### **Creando tu Contribución**

```bash
# 1. Actualiza tu fork
git fetch upstream
git checkout main
git merge upstream/main

# 2. Crea una nueva rama
git checkout -b feature/mi-nueva-funcionalidad
# o
git checkout -b fix/corrección-bug
# o
git checkout -b docs/mejora-documentación

# 3. Realiza tus cambios
# ... edita archivos ...

# 4. Commit tus cambios
git add .
git commit -m "tipo: descripción breve del cambio

Descripción más detallada si es necesario.
Explica qué y por qué, no cómo.

- Punto específico 1
- Punto específico 2

Fixes #123"
```

### **Enviando tu Contribución**

```bash
# 5. Push a tu fork
git push origin feature/mi-nueva-funcionalidad

# 6. Crea un Pull Request desde GitHub
# Usa nuestras plantillas de PR
```

---

## [Configuración del Entorno](#guía-de-contribución)

### **Setup Completo**

```powershell
# 1. Verificar Sui CLI
sui --version  # Debe ser v1.57.0 o superior

# 2. Configurar red de testnet
sui client switch --env testnet

# 3. Obtener SUI de faucet (si es necesario)
# Visita: https://faucet.sui.io/

# 4. Verificar scripts
.\.script\check-packages.ps1
```

### **Herramientas Recomendadas**

- **VS Code Extensions**:
  - Move Language Support
  - PowerShell Extension
  - Markdown All in One
  - GitLens

- **Configuración VS Code** (opcional):

    ```json
    {
        "move.cli.path": "sui",
        "powershell.execution.policy": "RemoteSigned"
    }
    ```

---

## [Estándares de Código](#guía-de-contribución)

### **PowerShell Scripts**

```powershell
# ✅ Buenas prácticas
function Show-Progress {
    param(
        [string]$Message,
        [string]$Color = "Green"
    )

    Write-Host "🔄 $Message" -ForegroundColor $Color
}

# ✅ Manejo de errores
try {
    # Código que puede fallar
    Invoke-SuiCommand
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# ✅ Validación de parámetros
if (-not (Test-Path "Move.toml")) {
    Write-Host "❌ No se encuentra Move.toml. Ejecuta desde el directorio del proyecto." -ForegroundColor Red
    exit 1
}
```

### **Documentación Markdown**

- Incluye ejemplos de código donde sea apropiado
- Organiza con headers claros y navegación
- Mantén líneas bajo 100 caracteres cuando sea posible

### **Convenciones de Commit**

Usamos conventional commits:

```bash
tipo(ámbito): descripción

[cuerpo opcional]

[footer opcional]
```

**Tipos válidos**:

- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Formato, punto y coma faltantes, etc
- `refactor`: Refactoring de código
- `test`: Agregar o modificar tests
- `chore`: Mantenimiento

**Ejemplos**:

```bash
feat(scripts): agregar validación de balance en deploy.ps1

- Verificar balance suficiente antes del despliegue
- Mostrar costo estimado vs balance disponible
- Permitir continuar con confirmación del usuario

Closes #45

fix(docs): corregir enlaces rotos en README.md

docs(contributing): agregar guía de setup del entorno

chore: actualizar versión de Sui CLI requerida
```

---

## [Reportar Bugs](#guía-de-contribución)

### **Antes de Reportar**

1. **Busca** issues existentes
2. **Verifica** que sea reproducible
3. **Prueba** con la última versión

### **Plantilla de Bug Report**

Usa esta plantilla al crear un issue:

```markdown
## 🐛 Descripción del Bug

Una descripción clara y concisa del problema.

## 🔄 Pasos para Reproducir

1. Ve a '...'
2. Ejecuta '...'
3. Observa el error

## ✅ Comportamiento Esperado

Describe qué esperabas que sucediera.

## ❌ Comportamiento Actual

Describe qué sucedió en realidad.

## 📸 Screenshots/Logs

Si es aplicable, agrega screenshots o logs.

## 🖥️ Información del Sistema

**OS**: [e.g. Windows 11]
**PowerShell**: [e.g. 7.3.0]
**Sui CLI**: [e.g. 1.57.0]
**Rama**: [e.g. main, feature/xyz]

## 📋 Contexto Adicional

Cualquier información adicional relevante.

## ✅ Checklist

- [ ] Busqué issues similares existentes
- [ ] Puedo reproducir el error consistentemente
- [ ] Incluí toda la información del sistema
- [ ] Agregué logs/screenshots relevantes

```

---

## [Solicitar Funcionalidades](#guía-de-contribución)

### **Plantilla de Feature Request**

```markdown
## 🚀 Descripción de la Funcionalidad

Una descripción clara del feature que te gustaría ver.

## 🎯 Problema que Resuelve

¿Qué problema resolvería este feature?

## 💭 Solución Propuesta

Describe tu solución ideal.

## 🔄 Alternativas Consideradas

¿Qué otras soluciones has considerado?

## 📋 Criterios de Aceptación

- [ ] Criterio 1
- [ ] Criterio 2
- [ ] Criterio 3

## 🎨 Mockups/Ejemplos

Si tienes ejemplos visuales o de código.

## 📈 Impacto Esperado

¿Cómo beneficiaría esto al proyecto?
```

---

## [Mejorar Documentación](#guía-de-contribución)

### **Tipos de Mejoras**

- **Correcciones**: Typos, gramática, enlaces rotos
- **Clarificación**: Hacer explicaciones más claras
- **Ejemplos**: Agregar casos de uso prácticos
- **Traducción**: Traducir a otros idiomas
- **Estructura**: Mejorar organización y navegación

### **Guías Específicas**

- Mantén consistencia con el estilo existente
- Usa emojis para mejorar legibilidad
- Incluye ejemplos prácticos
- Verifica todos los enlaces
- Actualiza tabla de contenidos si es necesario

---

## [Pull Requests](#guía-de-contribución)

### **Checklist de PR**

Antes de enviar tu PR, verifica:

- [ ] **Código**: Funciona correctamente y sigue estándares
- [ ] **Tests**: Probado en entorno local
- [ ] **Documentación**: Actualizada si es necesario  
- [ ] **Commits**: Mensajes claros y descriptivos
- [ ] **Rama**: Actualizada con upstream/main
- [ ] **Conflictos**: Resueltos si los hay

### **Plantilla de PR**

```markdown
## 📋 Descripción

Breve descripción de los cambios realizados.

## 🔄 Tipo de Cambio

- [ ] 🐛 Bug fix (cambio que corrige un problema)
- [ ] ✨ New feature (cambio que agrega funcionalidad)
- [ ] 💥 Breaking change (fix o feature que causaría incompatibilidad)
- [ ] 📚 Documentation update (cambios solo en documentación)

## 🧪 Testing

Describe las pruebas realizadas:

- [ ] Pruebas locales realizadas
- [ ] Scripts ejecutados correctamente
- [ ] Documentación verificada

## 📋 Checklist

- [ ] Mi código sigue las convenciones del proyecto
- [ ] He realizado una auto-revisión de mi código
- [ ] He comentado mi código en áreas difíciles de entender
- [ ] He actualizado la documentación correspondiente
- [ ] Mis cambios no generan nuevas advertencias
- [ ] He agregado tests que prueban mi fix/feature
- [ ] Tests nuevos y existentes pasan localmente

## 📸 Screenshots

Si aplica, agregar screenshots de los cambios.

## 🔗 Issues Relacionados

Closes #(issue number)
Related to #(issue number)
```

### **Proceso de Revisión**

1. **Auto-revisión**: Revisa tu código antes de enviar
2. **CI/CD**: Los checks automáticos deben pasar
3. **Code Review**: Al menos una aprobación requerida
4. **Testing**: Verificación manual si es necesario
5. **Merge**: Squash and merge preferido

---

## [Obtener Ayuda](#guía-de-contribución)

### 💬 **Canales de Comunicación**

- **Issues**: Para bugs y feature requests
- **Discussions**: Para preguntas generales
- **Email**: [Coreo](dcdevtk@gmail.com) para temas sensibles
- **Docs**: Revisa la documentación primero

### **Recursos Útiles**

- [Documentación de Sui](https://docs.sui.io/)
- [Move Language Book](https://move-book.com/)
- [Sui Examples](https://github.com/MystenLabs/sui/tree/main/examples)
- [Sui Discord](https://discord.gg/sui)

### **Preguntas Frecuentes**

**P: ¿Puedo contribuir si soy principiante?**
R: ¡Absolutamente! Tenemos issues marcados como "good first issue" perfectos para empezar.

**P: ¿Cuánto tiempo toma revisar un PR?**
R: Generalmente 2-5 días hábiles, dependiendo de la complejidad.

**P: ¿Puedo trabajar en un issue ya asignado?**
R: Por favor comenta en el issue antes. Si no hay actividad reciente, puedes preguntarsi puedes ayudar.

---

## [Reconocimientos](#guía-de-contribución)

Agradecemos a todos los contribuyentes que ayudan a hacer este proyecto mejor:

- 🎯 **Contribuyentes de código**
- 📚 **Mejoradores de documentación**
- 🐛 **Reportadores de bugs**
- 💡 **Sugeridores de features**
- 🧪 **Testers de la comunidad**

---

## [Licencia](#guía-de-contribución)

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo la misma [MIT License](LICENSE) que cubre el proyecto.

---

**🚀 ¡Gracias por contribuir al ecosistema Sui! Juntos hacemos que el desarrollo en Move sea más accesible para todos.**

**Creado con ❤️ por el equipo de desarrollo de [Dc Studio]()**
