package utils.mail;

public interface EmailService {

    /**
     * Envía un correo simple (texto plano)
     */
    void enviar(String destinatario, String asunto, String cuerpo) throws Exception;
}
