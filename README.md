Proyecto Creado Por Ing. Fabrizio Castro

## Requisitos
- **Sistema Operativo:** Linux con Bash instalado.
- **Permisos:** Algunos comandos, como `systemctl` y `cron`, pueden requerir permisos de superusuario (sudo).
- **Terminal:** Soporte para comandos Bash.

Funcionalidades Disponibles:

-Monitorización de Procesos
-Lista procesos en ejecución.
-Muestra procesos que consumen más CPU y memoria.
-Proporciona información detallada de un proceso por su PID.
-Exporta información de procesos a un archivo de registro.

Gestión de Servicios:
-Inicia, detiene y reinicia servicios.
-Cambia el estado de habilitación de los servicios (enabled o disabled).

Analizador de Procesos:
-Supervisa el consumo de recursos de procesos.
-Genera alertas para procesos que exceden umbrales definidos.

Programación de Tareas:
-Configura tareas automáticas para cerrar el script después de un intervalo.
-Permite eliminar tareas automáticas configuradas.

Ejemplo de Uso:
-Ejecuta el script.
-Navega por los menús interactivos para seleccionar la funcionalidad deseada.
-Sigue las instrucciones proporcionadas en pantalla.

Notas:
-Algunas funcionalidades, como la gestión de servicios, pueden no estar disponibles en sistemas que no utilicen systemctl.
-Para mayor seguridad, verifica que tienes permisos adecuados antes de ejecutar el script.
