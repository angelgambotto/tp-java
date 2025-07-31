package proyectos;

import java.util.Date;
import java.util.LinkedList;

import categoriaTarea.CategoriaTarea;
import usuarios.Usuario;

public class Proyecto {
	private int id;
	private String nombre;
	private String descripcion;
	private String cuitCuil;
	private Date fechaCreacion;
	private Usuario supervisor;
	private LinkedList<Usuario> usuarios;
	private CategoriaTarea categoria;
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
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCuitCuil() {
		return cuitCuil;
	}
	public void setCuitCuil(String cuitCuil) {
		this.cuitCuil = cuitCuil;
	}
	public Date getFechaCreacion() {
		return fechaCreacion;
	}
	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	public Usuario getSupervisor() {
		return supervisor;
	}
	public void setSupervisor(Usuario supervisor) {
		this.supervisor = supervisor;
	}
	public LinkedList<Usuario> getUsuarios() {
		return usuarios;
	}
	public void setUsuarios(LinkedList<Usuario> usuarios) {
		this.usuarios = usuarios;
	}
	public CategoriaTarea getCategoria() {
		return categoria;
	}
	public void setCategoria(CategoriaTarea categoria) {
		this.categoria = categoria;
	}
	public Proyecto(int id, String nombre, String descripcion, String cuitCuil, Date fechaCreacion, Usuario supervisor,
			LinkedList<Usuario> usuarios, CategoriaTarea categoria) {
		super();
		this.id = id;
		this.nombre = nombre;
		this.descripcion = descripcion;
		this.cuitCuil = cuitCuil;
		this.fechaCreacion = fechaCreacion;
		this.supervisor = supervisor;
		this.usuarios = usuarios;
		this.categoria = categoria;
	}
	
	
}
