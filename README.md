Propuesta TP JAVA - Sistema de Gestión de Proyectos

**Integrantes**

52224 - Gambotto, Angel Uriel

52634 - Gregoret, Facundo Uriel

52420 - Lovatti, Francisco

52417 - Repupilli, Irina

**Enunciado del Sistema**

Este sistema permite gestionar proyectos colaborativos organizados por clientes, usuarios y tareas. Cada proyecto se asocia a un cliente, tiene un supervisor y múltiples usuarios involucrados, y se divide en etapas que contienen tareas específicas. Las tareas pueden tener empleados asignados, archivos, comentarios y registro de horas trabajadas, lo que permite un seguimiento detallado del avance. Además, las tareas se clasifican mediante categorías propias del proyecto, lo cual ayuda a mantener el orden y facilitar la planificación.

El sistema también contempla una estructura de roles y permisos para definir qué acciones puede realizar cada usuario, permitiendo diferenciar entre administradores, empleados y clientes. Gracias a esta organización, se facilita la supervisión del trabajo, el control del tiempo invertido, y la comunicación dentro de los equipos. En conjunto, el sistema ofrece una solución integral para la planificación, ejecución y seguimiento de proyectos en entornos colaborativos.























**Modelo de datos**

![](Aspose.Words.23876293-4ddf-4bf6-9d6c-6e85bec181ce.001.png)











**Requerimientos funcionales para regularidad**

|Requerimiento|Cantidad|Detalle|
| :- | :- | :- |
|ABMC simple|4|<p>1. ABMC - Usuario</p><p>2. ABMC - Proyecto</p><p>3. ABMC - Cliente</p><p>4. ABMC - Categoría de tarea</p>|
|ABMC dependiente|2|<p>1. ABMC - Etapa</p><p>2. ABMC - Tarea</p>|
|CU NO-ABMC|2|<p>1. CU - Ingresar horas trabajadas, solo pueden ser cargadas por usuarios asignados a la tarea.</p><p>2. CU - Visualizar seguimiento de proyecto y etapas, una etapa no puede finalizar si tiene tareas incompletas</p>|
|Listado simple|3|<p>1. Listado - Proyecto</p><p>2. Listado - Hora trabajada</p><p>3. Listado - Comentario</p>|

**Requerimientos funcionales para Aprobación Directa**

|Requerimiento|Cantidad|Detalle|
| :- | :- | :- |
|ABMC simple|4|<p>1. ABMC - Usuario</p><p>2. ABMC - Proyecto</p><p>3. ABMC - Cliente</p><p>4. ABMC - Categoría de tarea</p>|
|ABMC dependiente|3|<p>1. ABMC - Etapa</p><p>2. ABMC - Tarea</p><p>3. ABMC - Comentario</p>|
|CU "Complejo"(nivel resumen)|2|<p>1. CU - Gestionar proyecto: desde la creación del proyecto hasta su finalización, pasando por la definición y seguimiento de etapas.</p><p>2. CU - Gestionar tarea: desde la creación hasta la finalización, pasando por la asignación de empleado, carga de comentarios y horas trabajadas</p>|
|Listado complejo|1|<p>1. Listado - Tarea. Filtrado por categoría, usuario, estado.</p><p>2. Listado - Usuario. Filtrado por rol y/o búsqueda por nombre y apellido.</p>|
|Nivel de acceso|2|<p>1. Administrador</p><p>2. Usuario avanzado(empleados)</p><p>3. Usuario (cliente)</p>|
|Manejo de errores|-|-|
|Manejo de archivos|-|1. Carga de archivos a la descripción y comentarios de tareas|
|Envío de mails|-|<p>1. Avisos de tarea asignada y cambios de estado de la misma</p><p>2. Aviso a usuarios cliente de cambio de estado en etapas.</p>|

