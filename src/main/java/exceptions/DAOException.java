package exceptions;

public class DAOException extends Exception {
	
	//si usaramos un framework u otras cosas quizas nos convendria serializar
	
	//Constructor con mensaje
	public DAOException(String message) {
        super(message);
    }
	//Constructor con mensaje y causa
    public DAOException(String message, Throwable cause) {
        super(message, cause);
    }
    
}
