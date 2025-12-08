package utils.mail;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class GmailEmailService implements EmailService {

    private final String username;
    private final String password; // contraseña de aplicación

    public GmailEmailService(String username, String password) {
        this.username = username;
        this.password = password;
    }

    @Override
    public void enviar(String destinatario, String asunto, String cuerpo) throws Exception {

        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(prop, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                // Gmail requiere contraseña de aplicación
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
        message.setSubject(asunto);
        //message.setText(cuerpo);
        message.setContent(cuerpo, "text/html; charset=UTF-8");

        Transport.send(message);

        System.out.println("[INFO] Email enviado correctamente a " + destinatario);
    }
}
