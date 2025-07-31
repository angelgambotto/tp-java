package clientes;

public class Cliente {
	private String cuilCuit;
	private String razonSocial;
	private String mail;
	
	public String getCuilCuit() {
		return cuilCuit;
	}
	public void setCuilCuit(String cuilCuit) {
		this.cuilCuit = cuilCuit;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	
	public Cliente(String cuilCuit, String razonSocial, String mail) {
		super();
		this.cuilCuit = cuilCuit;
		this.razonSocial = razonSocial;
		this.mail = mail;
	}
	
}
