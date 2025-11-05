package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtils {

    // Hashea la contraseña en SHA-256
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al hashear la contraseña", e);
        }
    }

    // Compara contraseña ingresada con la almacenada
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        String hashedInput = hashPassword(plainPassword);
        return hashedInput.equals(hashedPassword);
    }
}
