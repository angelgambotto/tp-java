CREATE DATABASE  IF NOT EXISTS `gestionproyecto` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gestionproyecto`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gestionproyecto
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adjuntos_comentario`
--

DROP TABLE IF EXISTS `adjuntos_comentario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adjuntos_comentario` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_comentario` int unsigned NOT NULL,
  `nombre_guardado` varchar(256) NOT NULL,
  `nombre_original` varchar(256) NOT NULL,
  `ruta` varchar(400) NOT NULL,
  `tamano_kb` int NOT NULL DEFAULT '0',
  `tipo_mime` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_comentario_idx` (`id_comentario`),
  CONSTRAINT `id_comentario` FOREIGN KEY (`id_comentario`) REFERENCES `comentario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adjuntos_comentario`
--

LOCK TABLES `adjuntos_comentario` WRITE;
/*!40000 ALTER TABLE `adjuntos_comentario` DISABLE KEYS */;
INSERT INTO `adjuntos_comentario` VALUES (1,9,'9_1765204745792.png','736059.png','/uploads/comentarios/9_1765204745792.png',1570,'image/png');
/*!40000 ALTER TABLE `adjuntos_comentario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoriatarea`
--

DROP TABLE IF EXISTS `categoriatarea`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoriatarea` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoriatarea`
--

LOCK TABLES `categoriatarea` WRITE;
/*!40000 ALTER TABLE `categoriatarea` DISABLE KEYS */;
INSERT INTO `categoriatarea` VALUES (4,'Software','tareas de sw'),(10,'BackEnd','cosas del back'),(11,'FrontEnd','cosas del front'),(12,'Base de Datos','cosas de la BdD'),(16,'Documentacion','Creación y gestión de documentos de proyecto y técnicos');
/*!40000 ALTER TABLE `categoriatarea` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cuitCuil` varchar(45) NOT NULL,
  `razonSocial` varchar(45) NOT NULL,
  `mail` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cuitCuil_UNIQUE` (`cuitCuil`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (7,'99-9999999-9','La favorita','franciscolovatti08@gmail.com'),(14,'20-46263841-9','La Baska','labaska@labaska.com'),(17,'22-22222222-2','Corte Preciso','cortepreciso@gmail.com'),(18,'30-71234567-8','Tecno Soluciones S.A.','contacto@tecnosoluciones.com');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comentario`
--

DROP TABLE IF EXISTS `comentario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comentario` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `idTarea` int unsigned NOT NULL,
  `idAutor` int unsigned NOT NULL,
  `fecha` datetime NOT NULL,
  `texto` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idAutor_idx` (`idAutor`),
  KEY `idTarea_idx` (`idTarea`),
  CONSTRAINT `idAutor` FOREIGN KEY (`idAutor`) REFERENCES `usuario` (`id`),
  CONSTRAINT `idTarea` FOREIGN KEY (`idTarea`) REFERENCES `tarea` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comentario`
--

LOCK TABLES `comentario` WRITE;
/*!40000 ALTER TABLE `comentario` DISABLE KEYS */;
INSERT INTO `comentario` VALUES (1,1,15,'2025-11-13 02:04:51','prueba de comentarioServlet'),(5,1,15,'2025-11-13 02:24:53','otro comentario'),(7,12,16,'2025-11-19 11:14:23','voy a comentar algo'),(9,12,15,'2025-12-08 11:39:06','este es mi primer comentario con archivos'),(10,20,18,'2025-12-12 19:26:31','Esquema de la base de datos de productos finalizado y listo para la implementación de endpoints.'),(11,22,18,'2025-12-12 19:26:31','Los endpoints para obtener el catálogo están en un 50%. Falta la lógica de filtros.');
/*!40000 ALTER TABLE `comentario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `etapa`
--

DROP TABLE IF EXISTS `etapa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etapa` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `estado` varchar(45) NOT NULL DEFAULT 'pendiente',
  `fechaInicio` date DEFAULT NULL,
  `fechaTentativa` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `idProyecto` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idProyecto_idx` (`idProyecto`),
  CONSTRAINT `idProyecto` FOREIGN KEY (`idProyecto`) REFERENCES `proyecto` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etapa`
--

LOCK TABLES `etapa` WRITE;
/*!40000 ALTER TABLE `etapa` DISABLE KEYS */;
INSERT INTO `etapa` VALUES (1,'Inicio','Primera','To Do','2025-11-08','2025-11-30',NULL,4),(2,'Desarrollo','Comienza el desarrollo','In Progress','2025-11-09',NULL,NULL,4),(3,'Pruebas','Pruebas','To Do','2025-11-09','2025-11-30',NULL,4),(4,'Creacion','crear','Done','2025-11-10','2025-11-11','2025-11-10',4),(6,'Despliegue','Despliegue de la aplicacion al publico','To Do','2025-11-12','2025-12-01',NULL,4),(9,'Relevamiento','Recopilacion de la informacion de los procesos de negocio y la organizacion                ','Done','2025-12-10',NULL,NULL,10),(10,'Prototipado','desarrollo de prototipos                                                                                ','In Progress','2025-12-12','2025-12-26',NULL,10),(11,'Requerimientos','Definición detallada de los requisitos funcionales y no funcionales del portal.','In Progress','2025-12-12','2025-12-20',NULL,12),(12,'Diseño UX/UI','Creación de wireframes y prototipos de la interfaz de usuario.','To Do','2025-12-20','2025-12-31',NULL,12),(13,'Desarrollo Backend','Implementación de la lógica de negocio y API/Base de Datos.','To Do','2026-01-01','2026-01-25',NULL,12),(14,'Desarrollo Frontend','Implementación de la interfaz de usuario y su lógica.','To Do','2026-01-10','2026-02-05',NULL,12),(15,'Sprint 1 - MVP Básico','Funcionalidad de login, registro y catálogo de productos.','In Progress','2025-12-15','2025-12-29',NULL,13),(16,'Sprint 2 - Carrito y Pago','Implementación del carrito de compras y pasarela de pago.','To Do','2025-12-30','2026-01-13',NULL,13),(17,'Testing y Despliegue','Pruebas finales, corrección de bugs y subida a tiendas (App/Play Store).','To Do','2026-01-14','2026-01-28',NULL,13),(18,'Modelado de Datos','Definición de la estructura de las tablas de inventario y pedidos personalizados.','To Do','2026-01-01','2026-01-15',NULL,11),(19,'Prototipo Web','Creación del esqueleto de la aplicación web y la interfaz de diseño de pedidos.','To Do','2026-01-16','2026-02-10',NULL,11),(20,'Planificación Inicial','Definición de alcance, cronograma y recursos.','To Do','2026-01-01','2026-01-05',NULL,14),(21,'Análisis y Diseño','Análisis detallado de los sistemas de origen y diseño de la nueva estructura.','To Do','2026-01-06','2026-01-20',NULL,14),(22,'Implementación','Desarrollo de los módulos de migración y la nueva interfaz de gestión.','To Do','2026-01-21','2026-02-15',NULL,14),(23,'Configuración Inicial','Instalación de certificados y credenciales de AFIP.','Done','2025-10-01','2025-10-05','2025-10-04',15),(24,'Desarrollo y Pruebas Unitarias','Programación de la lógica de negocio y simulación de envío de facturas.','Done','2025-10-06','2025-10-25','2025-10-22',15),(25,'Puesta en Producción','Despliegue final y verificación de la primera factura real.','Done','2025-10-23','2025-10-31','2025-10-28',15),(26,'Definición de Contenido','Recolección de textos, imágenes y llamadas a la acción.','Done','2025-09-01','2025-09-05','2025-09-04',16),(27,'Diseño y Maquetación','Creación de la maqueta visual y desarrollo del código HTML/CSS/JS.','Done','2025-09-05','2025-09-15','2025-09-14',16),(28,'Lanzamiento y SEO Básico','Puesta en línea del sitio y optimización inicial para motores de búsqueda.','Done','2025-09-16','2025-09-20','2025-09-18',16);
/*!40000 ALTER TABLE `etapa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hora_trabajada`
--

DROP TABLE IF EXISTS `hora_trabajada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hora_trabajada` (
  `idTarea` int unsigned NOT NULL,
  `idEmpleado` int unsigned NOT NULL,
  `fecha` datetime NOT NULL,
  `cantidad` int unsigned NOT NULL,
  `detalle` varchar(200) DEFAULT NULL,
  KEY `idTarea_idx` (`idTarea`),
  KEY `idEmpleado_idx` (`idEmpleado`),
  CONSTRAINT `idEmpleadoHora` FOREIGN KEY (`idEmpleado`) REFERENCES `usuario` (`id`),
  CONSTRAINT `idTareaHora` FOREIGN KEY (`idTarea`) REFERENCES `tarea` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hora_trabajada`
--

LOCK TABLES `hora_trabajada` WRITE;
/*!40000 ALTER TABLE `hora_trabajada` DISABLE KEYS */;
INSERT INTO `hora_trabajada` VALUES (1,15,'2025-11-16 22:03:57',4,'prueba'),(1,18,'2025-11-11 01:55:00',3,'prueba'),(1,18,'2025-11-11 23:55:00',6,'prueba'),(1,18,'2025-11-16 22:03:57',1,'prueba'),(1,22,'2025-11-16 22:03:57',4,'prueba'),(1,22,'2025-12-10 15:06:00',4,'estoy viendo si anda desde mis tareas'),(7,18,'2025-11-11 20:56:00',2,'prueba'),(7,18,'2025-11-16 22:03:57',5,'prueba'),(10,15,'2025-11-16 22:03:57',2,'prueba'),(10,19,'2025-11-16 22:03:57',2,'prueba'),(12,15,'2025-12-08 11:39:00',3,NULL),(12,16,'2025-11-19 11:13:00',3,'prueba'),(12,16,'2025-12-05 16:56:00',5,'prueba'),(14,22,'2025-12-10 16:59:00',1,'hola'),(16,30,'2025-12-13 10:00:00',4,'Reunion inicial con gerencia de ventas'),(16,30,'2025-12-14 14:00:00',3,'Reunion con equipo de soporte'),(20,18,'2025-12-15 09:00:00',5,'Modelado inicial de tablas de menú'),(20,18,'2025-12-16 11:00:00',3,'Ajustes en el esquema de precios'),(21,16,'2025-12-17 14:00:00',3,'Estructura base del componente de Login'),(22,18,'2025-12-18 10:00:00',4,'Definición de rutas para GET /productos'),(33,31,'2025-10-01 10:00:00',4,'Investigación y descarga de WSDL'),(35,30,'2025-10-08 09:00:00',8,'Implementación de reglas de negocio para IVA'),(35,31,'2025-10-09 09:00:00',6,'Pruebas unitarias sobre cálculos de impuestos'),(37,30,'2025-10-23 13:00:00',2,'Actualización de credenciales de AFIP en entorno productivo'),(39,22,'2025-09-01 13:00:00',3,'Revisión y ajustes del texto inicial'),(41,30,'2025-09-06 09:00:00',7,'Implementación de CSS Grid y Media Queries');
/*!40000 ALTER TABLE `hora_trabajada` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyecto`
--

DROP TABLE IF EXISTS `proyecto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyecto` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `fechaCreacion` date NOT NULL,
  `idSupervisor` int unsigned NOT NULL,
  `estado` varchar(45) NOT NULL DEFAULT '"To do"',
  `idCliente` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idSupervisor_idx` (`idSupervisor`),
  KEY `idCliente_idx1` (`idCliente`),
  CONSTRAINT `idCliente` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`id`),
  CONSTRAINT `idSupervisor` FOREIGN KEY (`idSupervisor`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyecto`
--

LOCK TABLES `proyecto` WRITE;
/*!40000 ALTER TABLE `proyecto` DISABLE KEYS */;
INSERT INTO `proyecto` VALUES (4,'test','testeoooo','2025-10-10',15,'In Progress',7),(10,'Sistema comercio La Baska','Sistema de gestion para pedidos, manejo de stock y facturacion de un local de empanadas','2025-12-10',22,'In Progress',14),(11,'Corte Preciso','Sistema de stock y pedidos personalizados para grabados y cortes laser','2025-12-11',22,'Canceled',17),(12,'Portal de Clientes','Desarrollo de un portal web para la gestión de servicios y facturación para Tecno Soluciones','2025-12-12',16,'In Progress',18),(13,'App Móvil para Pedidos','Desarrollo de una aplicación móvil (iOS/Android) para que los clientes de La Baska puedan hacer pedidos.','2025-12-12',20,'In Progress',14),(14,'Migración de Sistema de Legajos','Migración completa de la gestión de legajos y documentación a la nueva plataforma de gestión.','2025-12-12',20,'To Do',7),(15,'Módulo de Facturación Electrónica','Integración y puesta en marcha del sistema de facturación electrónica requerido por AFIP.','2025-10-01',22,'Done',7),(16,'Landing Page Promocional','Diseño y desarrollo de una página de destino para campañas de marketing digital.','2025-09-01',22,'Done',17);
/*!40000 ALTER TABLE `proyecto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proyecto_usuario`
--

DROP TABLE IF EXISTS `proyecto_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proyecto_usuario` (
  `idProyecto` int unsigned NOT NULL,
  `idEmpleado` int unsigned NOT NULL,
  `fechaAlta` datetime NOT NULL,
  `fechaBaja` date DEFAULT NULL,
  PRIMARY KEY (`idProyecto`,`idEmpleado`,`fechaAlta`),
  KEY `idEmpleado_idx` (`idEmpleado`),
  CONSTRAINT `idEmpleadoProyecto` FOREIGN KEY (`idEmpleado`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `idProyectoAsignado` FOREIGN KEY (`idProyecto`) REFERENCES `proyecto` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proyecto_usuario`
--

LOCK TABLES `proyecto_usuario` WRITE;
/*!40000 ALTER TABLE `proyecto_usuario` DISABLE KEYS */;
INSERT INTO `proyecto_usuario` VALUES (4,15,'2025-12-08 00:00:00',NULL),(4,16,'2025-11-13 00:00:00','2025-11-14'),(4,16,'2025-11-14 00:00:00','2025-11-14'),(4,16,'2025-11-14 16:46:18',NULL),(4,16,'2025-11-15 00:00:00','2025-11-17'),(4,16,'2025-11-16 00:00:00','2025-11-14'),(4,18,'2025-11-18 00:00:00',NULL),(4,19,'2025-11-18 00:00:00',NULL),(4,20,'2025-11-18 00:00:00',NULL),(4,22,'2025-11-18 00:00:00',NULL),(10,15,'2025-12-10 00:00:00',NULL),(10,16,'2025-12-10 00:00:00',NULL),(10,17,'2025-12-10 00:00:00',NULL),(10,18,'2025-12-10 00:00:00',NULL),(10,19,'2025-12-10 00:00:00',NULL),(10,20,'2025-12-10 00:00:00',NULL),(10,22,'2025-12-10 00:00:00',NULL),(12,30,'2025-12-12 19:20:18',NULL),(12,31,'2025-12-12 19:20:18',NULL),(13,16,'2025-12-12 19:26:31',NULL),(13,18,'2025-12-12 19:26:31',NULL),(14,16,'2025-12-12 19:37:22',NULL),(14,22,'2025-12-12 19:37:22',NULL),(15,30,'2025-10-01 00:00:00',NULL),(15,31,'2025-10-01 00:00:00',NULL),(16,22,'2025-09-01 00:00:00',NULL),(16,30,'2025-09-01 00:00:00',NULL);
/*!40000 ALTER TABLE `proyecto_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarea`
--

DROP TABLE IF EXISTS `tarea`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarea` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `estado` varchar(45) NOT NULL DEFAULT 'pendiente',
  `fechaInicio` date NOT NULL,
  `fechaFin` date DEFAULT NULL,
  `idEtapa` int unsigned NOT NULL,
  `idCategoria` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idEtapa_idx` (`idEtapa`),
  KEY `idCategoria_idx` (`idCategoria`),
  CONSTRAINT `idCategoria` FOREIGN KEY (`idCategoria`) REFERENCES `categoriatarea` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `idEtapa` FOREIGN KEY (`idEtapa`) REFERENCES `etapa` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarea`
--

LOCK TABLES `tarea` WRITE;
/*!40000 ALTER TABLE `tarea` DISABLE KEYS */;
INSERT INTO `tarea` VALUES (1,'Prueba','Esta tarea consiste en probar los diferentes requerimientos necesarios para hacer funcional el crud de tarea junto al de horas trabajadas y comentarios','Done','2025-11-08','2025-11-15',1,11),(4,'prueba base de datos','Checkeo de la integridad de la base','To Do','2025-11-09','2025-11-30',1,12),(5,'Instalacion de programas','Instalar programas necesarios para el desarrollo','In Progress','2025-11-09','2025-11-30',1,4),(7,'Crear el proyecto','Si, eso nomas','Done','2025-11-09','2025-11-10',4,12),(10,'Porcentaje','Quiero ver disminuir el progreso','Done','2025-11-12','2025-11-29',1,10),(12,'CRUD Usuarios','Comenzar con el desarrollo del AMB de la clase Usuarios','To Do','2025-11-19','2025-11-30',2,4),(14,'Definicion de PEN','Vamos a definir cuales son los procesos elementales de negocio','Done','2025-12-10','2025-12-31',9,12),(16,'Entrevistas con el cliente','Realizar reuniones para capturar los requisitos de las diferentes áreas.','Done','2025-12-12','2025-12-15',11,16),(17,'Redacción ERS','Elaborar el Documento de Especificación de Requisitos del Sistema.','In Progress','2025-12-16','2025-12-20',11,16),(18,'Configurar Base de Datos','Creación del esquema inicial de la base de datos de usuarios y facturación.','To Do','2026-01-01','2026-01-05',13,10),(19,'Maquetar Home Page','Desarrollo del HTML/CSS de la página de inicio.','To Do','2026-01-10','2026-01-15',14,11),(20,'Diseño de la BDD de Productos','Definición de tablas para catálogo, precios e ingredientes.','Done','2025-12-15','2025-12-16',15,12),(21,'Implementación del Login (FE)','Desarrollo de la interfaz y la lógica de inicio de sesión.','In Progress','2025-12-17','2025-12-21',15,11),(22,'Creación de Endpoints para Catálogo','Crear APIs REST para listar productos y obtener detalles.','In Progress','2025-12-17','2025-12-23',15,10),(23,'Diseño de Pantalla de Productos (UI)','Maquetación y estilos de la vista principal del catálogo.','In Progress','2025-12-18','2025-12-22',15,11),(24,'Integración de Catálogo','Conexión de la vista del catálogo con los endpoints del backend.','To Do','2025-12-24','2025-12-28',15,11),(25,'Diseño de Entidades (Stock)','Definir el modelo de datos para el inventario de materiales (madera, acrílico, metal).','To Do','2026-01-01','2026-01-08',18,4),(26,'Documentación de Flujo de Pedidos','Mapear el proceso desde que el cliente solicita el diseño hasta la producción.','To Do','2026-01-09','2026-01-15',18,16),(27,'Wireframes de Interfaz de Carga de Archivos','Diseñar las pantallas para que el cliente suba y ajuste su archivo de corte/grabado.','To Do','2026-01-16','2026-01-25',19,11),(28,'Configuración de Entorno de Desarrollo','Preparar el proyecto base (frameworks y dependencias) para el frontend.','To Do','2026-01-26','2026-01-30',19,4),(29,'Reunión de Kick-off','Reunión de inicio con todos los stakeholders del proyecto.','To Do','2026-01-01','2026-01-01',20,16),(30,'Crear WBS','Elaborar la Estructura de Desglose del Trabajo.','To Do','2026-01-02','2026-01-05',20,16),(31,'Mapeo de Datos','Definición de las equivalencias de campos entre el sistema antiguo y el nuevo.','To Do','2026-01-06','2026-01-10',21,12),(32,'Diseño de Interfaz de Búsqueda','Diseñar la pantalla principal para la búsqueda y gestión de legajos.','To Do','2026-01-11','2026-01-15',21,11),(33,'Obtención de WSDL y Certificados','Conseguir los archivos necesarios para la comunicación con el WS de AFIP.','Done','2025-10-01','2025-10-02',23,10),(34,'Validación de Credenciales','Prueba de autenticación con el servicio web de la AFIP en entorno de test.','Done','2025-10-03','2025-10-04',23,10),(35,'Módulo de Cálculo de Impuestos','Implementar la lógica para el cálculo automático de IVA y percepciones.','Done','2025-10-06','2025-10-15',24,4),(36,'Desarrollo de Interfaz de Emisión','Creación de la vista para cargar y visualizar la factura antes de enviarla.','Done','2025-10-16','2025-10-22',24,4),(37,'Migración de Configuración a Producción','Cambio de los endpoints de prueba a los de producción.','Done','2025-10-23','2025-10-25',25,10),(38,'Monitoreo Post-Despliegue','Seguimiento de las primeras 48h de operación en vivo.','Done','2025-10-26','2025-10-28',25,4),(39,'Redacción del Copy','Escritura del texto persuasivo para la página.','Done','2025-09-01','2025-09-02',26,16),(40,'Selección de Imágenes y Gráficos','Elegir el material visual adecuado.','Done','2025-09-03','2025-09-04',26,16),(41,'Desarrollo Responsive','Programación para asegurar la visualización en móvil y desktop.','Done','2025-09-05','2025-09-10',27,11),(42,'Integración de Formulario de Contacto','Implementación del formulario que envía datos al CRM.','Done','2025-09-11','2025-09-14',27,11);
/*!40000 ALTER TABLE `tarea` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarea_usuario`
--

DROP TABLE IF EXISTS `tarea_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarea_usuario` (
  `idTarea` int unsigned NOT NULL,
  `idEmpleado` int unsigned NOT NULL,
  PRIMARY KEY (`idTarea`,`idEmpleado`),
  KEY `idEmpleadoTarea_idx` (`idEmpleado`),
  CONSTRAINT `idEmpleadoTarea` FOREIGN KEY (`idEmpleado`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `idTareaAsignada` FOREIGN KEY (`idTarea`) REFERENCES `tarea` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarea_usuario`
--

LOCK TABLES `tarea_usuario` WRITE;
/*!40000 ALTER TABLE `tarea_usuario` DISABLE KEYS */;
INSERT INTO `tarea_usuario` VALUES (1,15),(10,15),(12,15),(12,16),(21,16),(23,16),(24,16),(29,16),(31,16),(1,18),(7,18),(12,18),(20,18),(22,18),(24,18),(10,19),(5,20),(26,20),(27,20),(1,22),(14,22),(25,22),(28,22),(29,22),(30,22),(32,22),(16,30),(19,30),(17,31),(18,31);
/*!40000 ALTER TABLE `tarea_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `apellido` varchar(45) NOT NULL,
  `clave` varchar(64) NOT NULL,
  `usuario` varchar(45) NOT NULL,
  `rol` varchar(45) NOT NULL,
  `mail` varchar(45) NOT NULL,
  `supervisor` int unsigned DEFAULT NULL,
  `salt` varchar(64) NOT NULL,
  `cliente` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_UNIQUE` (`usuario`),
  UNIQUE KEY `mail_UNIQUE` (`mail`),
  KEY `supervisor_idx` (`supervisor`),
  KEY `cliente_idx` (`cliente`),
  CONSTRAINT `cliente` FOREIGN KEY (`cliente`) REFERENCES `cliente` (`id`),
  CONSTRAINT `supervisor` FOREIGN KEY (`supervisor`) REFERENCES `usuario` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (15,'Admin','Admin','e020c920af724549445e47b2d66b43c357b357a03ae29d513efdceb72a8fff23','admin','Administrador','admin@quemail.com',NULL,'6nctceSI0mjEBIdsKHjvYw==',NULL),(16,'Angel','Gambotto','ab800efc668a24a1cd3e263e4a9662b3433d7ce21c7a7c4fddd291c48f44e771','angel','Empleado','agambotto@mail.com',NULL,'2J4d/8DblvUOFLOQM3fpdA==',NULL),(17,'Facu','Gregoret','b3417f86b18b49db9567230316f024ba4b4cb2f8b00b0b014aa721c90abc5922','facu','Empleado','facuelcrack@mail.com',17,'DfbDN34ukSwggq1qICeGYQ==',NULL),(18,'Pepe','Romano','4d0b369a3c8ba52bc281662fee2647888c480773198a2349e62a096f43e26b6f','pepe','Empleado','peperomano@mail.com',16,'dt+lmdSOKCwzU8p67Bfr6A==',NULL),(19,'Iri','Repupilli','8b4eb3428f9104d4f1fdd74820f3cbdc7951b9a36e8e928be6e70b4185a07233','irina','Empleado','iririr@mail.com',17,'W+vibUy9XjFlNvEeVK0/lg==',NULL),(20,'Adrian','Meca','ab757a9c0052d8e9b1f8ccbbb3aa809309ff05a6111fb985b4d003712baef045','meca','Empleado','mecaadrian@mail.com',17,'uqW2CWB/tsGBbKi7W5SHNQ==',NULL),(22,'Francisco','Lovatti','2f3653444be09c8e19f3a988a57d814c37c59ea8da45cc1cda166a0f7c19c032','fran','Empleado','franciscolovatti08@gmail.com',NULL,'bzeRqjJ005wQvVjKEveFDg==',NULL),(23,'fav','fav','cda4d20a6cf2853f8a4d39b7cd3d3755bb407da8b8778b3b3c46e83b74a33dfc','favorita','Cliente','fav@fav.com',NULL,'cNQd8L4Ih/nne2BEH3474A==',7),(27,'walter','lovatti','54ad1b86eda82f650c1141712f1f73998d3d093066fb732abded87565d5e12db','colo','Cliente','cololovatti@gmail.com',NULL,'s2g8CORrvyOp7XY6hr8tBw==',14),(29,'florencia','lovatti','cc72f66e19e3e03a38823953b80ad860899b8ee271a0e11386df035b935e159a','flor','Cliente','florencialovatti15@gmail.com',NULL,'La3mXspZpx0FYKznT7VxwA==',17),(30,'Laura','Perez','4187e17e7e4bd05d06a7051e39106cd60cad3c3bbb74be5a4e70b2185015e337','laura_p','Empleado','laura.perez@corp.com',NULL,'DSKjKnSy1tRlhuFNLJp4Dg==',NULL),(31,'Javier','Gomez','831ce959c526eedf687eeaddfdbc2f5264f3a634c0c086cae7466f5ef8875047','javier_g','Empleado','javier.gomez@corp.com',NULL,'aaoJ2dbYcV9IATOBF4R5cQ==',NULL),(32,'Juan','Rodriguez','08a66dcb0b5d2e55bd8e1a0ed8073cb3704dcb43467f903541bfb3b46f491100','tecnosoluciones','Cliente','juan.rodriguez@tecnosoluciones.com',NULL,'i/a9tqqt821r5MG79vk14A==',18);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-12 19:46:04
