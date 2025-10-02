package usuarios;

public class Usuario {
	private int id;
	private String nombre;
	private String apellido;
	private String mail;
	private String clave;
	private String usuario;
	private String rol;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellido() {
		return apellido;
	}
	public void setApellido(String apellido) {
		this.apellido = apellido;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getRol() {
		return rol;
	}
	public void setRol(String rol) {
		this.rol = rol;
	}
	public Usuario() {
		super();
	}
	public Usuario(int id, String nombre, String apellido, String mail, String clave, String usuario, String rol) {
		super();
		this.id = id;
		this.nombre = nombre;
		this.apellido = apellido;
		this.mail = mail;
		this.clave = clave;
		this.usuario = usuario;
		this.rol = rol;
	}
	
	public String getNombreCompleto() {
		return this.nombre.concat(" ").concat(apellido);
	}
	
	
}
