package utils.mail;

public class ConsoleEmailService implements EmailService {

    @Override
    public void enviar(String destinatario, String asunto, String cuerpo) {
        System.out.println("\n========== EMAIL SIMULADO ==========");
        System.out.println("Para:   " + destinatario);
        System.out.println("Asunto: " + asunto);
        System.out.println("Cuerpo:\n" + cuerpo);
        System.out.println("=====================================\n");
    }
}
