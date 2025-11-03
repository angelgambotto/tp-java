package proyectos;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import clientes.Cliente;
import etapas.Etapa;
import usuarios.Usuario;

public class Proyecto {
	private int id;
	private String nombre;
	private String descripcion;
	private String estado;
	private Cliente cliente;
	private Date fechaCreacion;
	private Usuario supervisor;
	private LinkedList<Usuario> usuarios;
	private List<Etapa> etapas;
	
	
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
	public Cliente getCliente() {
		return cliente;
	}
	public void setCliente(Cliente cliente) {
		this.cliente = cliente;
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
	public Proyecto() {
		super();
	}
	public List<Etapa> getEtapas() {
		return etapas;
	}
	public void setEtapas(List<Etapa> estapas) {
		this.etapas = estapas;
	}
	public Proyecto(int id, String nombre, String descripcion, String estado, Cliente cliente, Date fechaCreacion, Usuario supervisor,
			LinkedList<Usuario> usuarios) {
		this.id = id;
		this.nombre = nombre;
		this.descripcion = descripcion;
		this.estado = estado;
		this.cliente = cliente;
		this.fechaCreacion = fechaCreacion;
		this.supervisor = supervisor;
		this.usuarios = usuarios;
	}
	
	
}
