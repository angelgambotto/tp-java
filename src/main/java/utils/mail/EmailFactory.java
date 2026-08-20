package utils.mail;
import utils.ConfigLoader;

public class EmailFactory {

    /**
     * Crear EmailService real o simulado
     *
     * @param modoReal true = Gmail SMTP, false = consola
     */
    public static EmailService crearEmailService(boolean modoReal) {
        if (modoReal) {
            return new GmailEmailService(
                ConfigLoader.get("GMAIL_USER"),
                ConfigLoader.get("GMAIL_APP_PASSWORD"),
            );
        } 
        return new ConsoleEmailService();
    }
}
