package clientes;

public class Cliente {
	private String cuitCuil;
	private String razonSocial;
	private String mail;
	
	public String getCuitCuil() {
		return cuitCuil;
	}
	public void setCuitCuil(String cuitCuil) {
		this.cuitCuil = cuitCuil;
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
	
	public Cliente() {
		super();
	}
	public Cliente(String cuitCuil, String razonSocial, String mail) {
		super();
		this.cuitCuil = cuitCuil;
		this.razonSocial = razonSocial;
		this.mail = mail;
	}
	
}
