package clientes;

public class Cliente {
	private int id;
	private String cuitCuil;
	private String razonSocial;
	private String mail;
	
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
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
	public Cliente(int id, String cuitCuil, String razonSocial, String mail) {
		super();
		this.id = id;
		this.cuitCuil = cuitCuil;
		this.razonSocial = razonSocial;
		this.mail = mail;
	}
	
}
