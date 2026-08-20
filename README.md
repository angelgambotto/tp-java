# Sistema de Gestión de Proyectos

Trabajo Práctico de Java — Gambotto, Gregoret, Lovatti, Repupilli.

Aplicación web para gestionar proyectos colaborativos organizados por clientes, con seguimiento de etapas, tareas, horas trabajadas y comentarios. Desarrollada con Servlets + JSP puro (sin frameworks MVC), pensada como ejercicio de arquitectura en capas sobre Jakarta EE.

## Roles de usuario

- **Administrador**: gestión completa de usuarios, clientes, proyectos y categorías de tarea.
- **Empleado**: gestión de proyectos, clientes, categorías y tareas asignadas; carga de horas trabajadas y comentarios.
- **Cliente**: seguimiento de sus propios proyectos y etapas.

El control de acceso por rol se resuelve de forma centralizada en `filtros/SeguridadFilter.java`, que intercepta todas las rutas (`/*`) y redirige según sesión y rol.

## Funcionalidades principales

- Login / logout con sesión y filtro de seguridad global.
- ABMC de usuarios, clientes, proyectos y categorías de tarea.
- Proyectos organizados en etapas, y etapas en tareas (una etapa no puede finalizar con tareas incompletas).
- Asignación de empleados a tareas, con adjuntos y comentarios por tarea.
- Registro de horas trabajadas por tarea, con reportes filtrables por fecha, proyecto, etapa y tarea.
- Envío de notificaciones por mail (asignación de tarea, cambios de estado) vía Gmail SMTP, con un modo consola para desarrollo sin credenciales reales (`EmailFactory`).

## Stack técnico

- **Backend**: Java 21, Servlets + JSP (Jakarta EE, facet `jst.web` 5.0), patrón DAO por entidad.
- **Servidor de aplicaciones**: Apache Tomcat 10.0.x.
- **Base de datos**: MySQL 8, acceso vía JDBC (`mysql-connector-j`).
- **Frontend**: JSP + Bootstrap (vía CDN), sin build step.
- **Mailing**: JavaMail (`javax.mail`), con `GmailEmailService` (SMTP real) y `ConsoleEmailService` (simulado) intercambiables por factory.
- **Proyecto Eclipse**: Dynamic Web Project sin Maven/Gradle; las dependencias se resuelven como `.jar` en `lib/` y `WEB-INF/lib/`.

## Estructura del repositorio

- `src/main/java/`: código fuente organizado por dominio (`usuarios`, `clientes`, `proyectos`, `etapas`, `tareas`, `categoriaTarea`, `comentarios`, `adjuntosComentario`, `horastrabajadas`, `horasReporte`), cada uno con su entidad, DAO y, cuando aplica, su Servlet.
  - `auth/`: `LoginServlet` y `LogoutServlet`.
  - `filtros/SeguridadFilter.java`: control de acceso por rol.
  - `utils/ConexionDB.java`: conexión JDBC a MySQL.
  - `utils/ConfigLoader.java`: carga de credenciales desde variables de entorno o `config.properties`.
  - `utils/PasswordUtils.java`: hashing de contraseñas.
  - `utils/mail/`: `EmailService`, `GmailEmailService`, `ConsoleEmailService` y `EmailFactory`.
  - `exceptions/DAOException.java`: excepción propia de la capa de datos.
  - `config.properties.example`: plantilla de configuración (copiar a `config.properties`, que no se commitea).
- `src/main/webapp/`: vistas JSP agrupadas por dominio (`proyectos/`, `tareas/`, `etapas/`, `clientes/`, `usuarios/`, `categorias/`, `horasTrabajadas/`), más `login.jsp`, `signup.jsp` y `header.jsp` como layout compartido.
- `db/dump.sql`: dump de la base `gestionproyecto` con estructura y datos de ejemplo.
- `doc/`: documentación funcional del TP (propuesta y planificación) en PDF.
- `lib/`: `.jar` de MySQL Connector y JavaMail usados fuera del classpath de `WEB-INF/lib`.

## Puesta en marcha

### 1) Requisitos

- JDK 21.
- Apache Tomcat 10.0.x (o superior compatible con Jakarta EE 9+, ya que el código usa el paquete `jakarta.servlet`).
- MySQL 8.
- Eclipse IDE for Enterprise Java Developers (el repo incluye metadata de proyecto Eclipse: `.project`, `.classpath`, `.settings/`) — o cualquier IDE que soporte Dynamic Web Projects sin Maven/Gradle.

### 2) Base de datos

Crear la base a partir del dump incluido:

```
mysql -u root -p < db/dump.sql
```

Esto crea la base `gestionproyecto` con su estructura y datos de ejemplo.

### 3) Configurar credenciales

La conexión a MySQL y las credenciales de Gmail se leen desde `utils/ConfigLoader`, que prioriza variables de entorno y cae a un archivo de propiedades si no las encuentra.

Copiar la plantilla y completarla con tus valores:

```
cp src/main/java/config.properties.example src/main/java/config.properties
```

`config.properties` (no se commitea):

```properties
DB_URL=jdbc:mysql://localhost/gestionproyecto
DB_USER=javaAdmin
DB_PASS=tu_password_local
GMAIL_USER=tu_cuenta@gmail.com
GMAIL_APP_PASSWORD=tu_contraseña_de_aplicacion
```

Va en la raíz de `src/main/java` (no dentro de un paquete): así Eclipse lo copia a `WEB-INF/classes` al desplegar, que es donde `ConfigLoader` lo busca en el classpath.

Alternativamente, se pueden definir las mismas claves (`DB_URL`, `DB_USER`, `DB_PASS`, `GMAIL_USER`, `GMAIL_APP_PASSWORD`) como variables de entorno del sistema o del servidor — `ConfigLoader` las toma con prioridad sobre el archivo.

### 4) Importar y desplegar

1. Importar el proyecto en Eclipse como **Existing Projects into Workspace**.
2. Agregar un servidor Apache Tomcat 10.0.x en la vista *Servers*.
3. Agregar el proyecto al servidor (*Add and Remove...*) y arrancarlo.
4. La aplicación queda disponible en `http://localhost:8080/<nombre-del-proyecto>/login.jsp`.

Para el envío real de mails, `EmailFactory.crearEmailService(true)` usa `GmailEmailService`; con `false` usa `ConsoleEmailService`, que solo loguea el mail por consola — útil para desarrollar sin exponer una cuenta real.

## Integrantes

- Gambotto, Angel Uriel — 52224
- Gregoret, Facundo Uriel — 52634
- Lovatti, Francisco — 52420
- Repupilli, Irina — 52417