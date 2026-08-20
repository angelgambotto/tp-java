package utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigLoader {
    private static final Properties props = new Properties();

    static {
        try (InputStream in = ConfigLoader.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (in != null) {
                props.load(in);
            }
        } catch (IOException e) {
            throw new RuntimeException("No se pudo cargar config.properties", e);
        }
    }

    public static String get(String key) {
        // Prioridad: variable de entorno del sistema > config.properties
        String env = System.getenv(key);
        if (env != null && !env.isBlank()) return env;
        return props.getProperty(key);
    }
}