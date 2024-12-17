# Proyecto de Gestión y Monitorización de Procesos en Bash

## Descripción
**Proyecto Creado Por:** Ing. Fabrizio Castro

Este proyecto es un **script en Bash** diseñado para facilitar la **monitorización de procesos**, **gestión de servicios**, **análisis de recursos** y **programación de tareas automáticas** en sistemas Linux. Ofrece un **menú interactivo** que guía al usuario para ejecutar las funcionalidades de forma sencilla y eficiente.

---

## Requisitos
- **Sistema Operativo:** Linux con soporte para Bash.
- **Permisos:** Algunos comandos, como `systemctl` y `cron`, pueden requerir permisos de superusuario (sudo).
- **Terminal:** Compatible con comandos Bash.

---

## Funcionalidades Disponibles

### **1. Monitorización de Procesos**
- **Listar procesos en ejecución:**  
  Muestra una lista de los procesos activos en el sistema.
- **Mostrar procesos con mayor consumo de CPU y memoria:**  
  Filtra y ordena los procesos más exigentes en recursos.
- **Información detallada por PID:**  
  Proporciona detalles específicos de un proceso seleccionado mediante su PID.
- **Exportar información a un archivo:**  
  Guarda los detalles de los procesos en un archivo de registro.

### **2. Gestión de Servicios**
- **Iniciar servicios:**  
  Permite iniciar un servicio especificado por el usuario.
- **Detener servicios:**  
  Finaliza un servicio en ejecución.
- **Reiniciar servicios:**  
  Reinicia un servicio activo.
- **Cambiar estado de servicios:**  
  Habilita (`enabled`) o deshabilita (`disabled`) servicios en el sistema.

### **3. Analizador de Procesos**
- **Supervisión de recursos:**  
  Monitorea los procesos que consumen más recursos (CPU o memoria).
- **Generación de alertas:**  
  Genera advertencias cuando un proceso excede umbrales definidos de CPU o memoria.

### **4. Programación de Tareas**
- **Configurar tareas automáticas:**  
  Permite programar el cierre automático del script usando `cron` en intervalos de tiempo definidos.
- **Eliminar tareas programadas:**  
  Facilita la eliminación de tareas automáticas configuradas previamente.

---

## Ejemplo de Uso

### Ejecutar el script
```bash
./script.sh
```

### Pasos de Uso
1. **Navegar por los menús interactivos:** Selecciona la funcionalidad deseada mediante el menú interactivo.
2. **Ejemplo de funcionalidades:**
   * **Monitorizar procesos:** Selecciona la opción correspondiente para listar procesos o ver información detallada.
   * **Gestionar servicios:** Inicia, detén o reinicia un servicio escribiendo su nombre.
   * **Programar tareas:** Configura un intervalo para ejecutar o cerrar automáticamente el script.
3. **Sigue las instrucciones:** El script mostrará mensajes y confirmaciones durante la ejecución.

## Notas Importantes
* Algunas funcionalidades, como la **gestión de servicios**, pueden no estar disponibles en sistemas que no utilicen `systemctl`.
* Asegúrate de contar con **permisos adecuados** antes de ejecutar el script para evitar errores de acceso.
* Para sistemas con configuraciones restringidas, ejecuta el script con permisos de superusuario (`sudo`).
