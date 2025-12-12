package utils.mail;

public class EmailFactory {

    /**
     * Crear EmailService real o simulado
     *
     * @param modoReal true = Gmail SMTP, false = consola
     */
    public static EmailService crearEmailService(boolean modoReal) {
        if (modoReal) {
            return new GmailEmailService(
                "alertaplanera@gmail.com",
                "gilzkizxcrsqcqyg "   // generada en Google
            );
        } 
        return new ConsoleEmailService();
    }
}
