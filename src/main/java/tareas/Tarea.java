package tareas;

import java.sql.Date;
import categoriaTarea.CategoriaTarea;
import usuarios.Usuario;


public class Tarea {
	private int id;
	private String nombre;
	private String descripcion;
	private String estado; //pendiente, finalizada, etc
	private Date fechaInicio;
	private Date fechaFin;
	private int idEtapa;
	private CategoriaTarea categoria;
	private Usuario usuario;
	
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

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public int getIdEtapa() {
		return idEtapa;
	}

	public void setIdEtapa(int idEtapa) {
		this.idEtapa = idEtapa;
	}

	public CategoriaTarea getCategoria() {
		return categoria;
	}

	public void setCategoria(CategoriaTarea categoria) {
		this.categoria = categoria;
	}
	
	
	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	//Constructor
	public Tarea() {
		super();
	}
}
