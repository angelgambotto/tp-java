# Sistema de Gestión de Proyectos - Propuesta TP JAVA

## Integrantes
- 52224 - Gambotto, Angel Uriel
- 52634 - Gregoret, Facundo Uriel
- 52420 - Lovatti, Francisco
- 52417 - Repupilli, Irina

## Enunciado del Sistema
Este sistema permite gestionar proyectos colaborativos organizados por clientes, usuarios y tareas. Cada proyecto se asocia a un cliente, tiene un supervisor y múltiples usuarios involucrados, y se divide en etapas que contienen tareas específicas. Las tareas pueden tener empleados asignados, archivos, comentarios y registro de horas trabajadas, lo que permite un seguimiento detallado del avance. Además, las tareas se clasifican mediante categorías propias del proyecto, lo cual ayuda a mantener el orden y facilitar la planificación.

El sistema también contempla una estructura de roles y permisos para definir qué acciones puede realizar cada usuario, permitiendo diferenciar entre administradores, empleados y clientes. Gracias a esta organización, se facilita la supervisión del trabajo, el control del tiempo invertido y la comunicación dentro de los equipos. En conjunto, el sistema ofrece una solución integral para la planificación, ejecución y seguimiento de proyectos en entornos colaborativos.

## Modelo de Datos
*Nota: El modelo de datos se representa mediante tablas, las cuales se detallarán en la documentación correspondiente.*

## Requerimientos Funcionales para Regularidad

| **Requerimiento**       | **Cantidad** | **Detalle**                                                                 |
|-------------------------|--------------|-----------------------------------------------------------------------------|
| **ABMC simple**         | 4            | ABMC - Usuario                                                             |
|                         |              | ABMC - Proyecto                                                            |
|                         |              | ABMC - Cliente                                                             |
|                         |              | ABMC - Categoría de tarea                                                  |
| **ABMC dependiente**    | 2            | ABMC - Etapa                                                               |
|                         |              | ABMC - Tarea                                                               |
| **CU NO-ABMC**         | 2            | CU - Ingresar horas trabajadas, solo por usuarios asignados a la tarea.     |
|                         |              | CU - Visualizar seguimiento de proyecto y etapas (etapa no finaliza si tiene tareas incompletas). |
| **Listado simple**      | 3            | Listado - Proyecto                                                         |
|                         |              | Listado - Hora trabajada                                                   |
|                         |              | Listado - Comentario                                                       |

## Requerimientos Funcionales para Aprobación Directa

| **Requerimiento**       | **Cantidad** | **Detalle**                                                                 |
|-------------------------|--------------|-----------------------------------------------------------------------------|
| **ABMC simple**         | 4            | ABMC - Usuario                                                             |
|                         |              | ABMC - Proyecto                                                            |
|                         |              | ABMC - Cliente                                                             |
|                         |              | ABMC - Categoría de tarea                                                  |
| **ABMC dependiente**    | 3            | ABMC - Etapa                                                               |
|                         |              | ABMC - Tarea                                                               |
|                         |              | ABMC - Comentario                                                          |
| **CU "Complejo"**       | 2            | CU - Gestionar proyecto: desde la creación hasta la finalización, pasando por la definición y seguimiento de etapas. |
|                         |              | CU - Gestionar tarea: desde la creación hasta la finalización, pasando por asignación de empleado, carga de comentarios y horas trabajadas. |
| **Listado complejo**    | 1            | Listado - Tarea: Filtrado por categoría, usuario, estado.                   |
|                         |              | Listado - Usuario: Filtrado por rol y/o búsqueda por nombre y apellido.     |
| **Nivel de acceso**     | 2            | Administrador                                                              |
|                         |              | Usuario avanzado (empleados)                                               |
|                         |              | Usuario (cliente)                                                          |
| **Manejo de errores**   | -            | -                                                                          |
| **Manejo de archivos**  | -            | Carga de archivos a la descripción y comentarios de tareas.                 |
| **Envío de mails**      | -            | Avisos de tarea asignada y cambios de estado de la misma.                   |
|                         |              | Aviso a usuarios cliente de cambio de estado en etapas.                     |
