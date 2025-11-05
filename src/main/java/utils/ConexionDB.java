package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionDB {
    private static final String URL = "jdbc:mysql://localhost/gestionproyecto";
    private static final String USER = "javaAdmin";
    private static final String PASS = "123";

    public static Connection getConexion() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            throw new RuntimeException("Error al conectar a la BD: " + e.getMessage());
        }
    }
    public static void shutdownCleanupThread() {
        try {
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("[INFO] Limpieza del hilo de conexión MySQL completada");
        } catch (Exception e) {
            System.err.println("[WARN] Error al cerrar hilo de limpieza MySQL: " + e.getMessage());
        }
    }
}